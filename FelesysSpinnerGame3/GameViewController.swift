//
//  ViewController.swift
//  FelesysSpinnerGame3
//
//  Created by Apple  on 23/08/23.
//

import UIKit
import SwiftFortuneWheel

class GameViewController: UIViewController{
    
    //MARK: Properties
    var arrayCount = 0
    var array:[Slice] = []
    var isSpinning:Bool = false
    
    //MARK: @IBOutlet varibles
    @IBOutlet weak var fortuneWheel: SwiftFortuneWheel!
    
    @IBOutlet var goBackBtn: UIButton!
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        configureFortuneWheelUI()
        configureButtonUI()
    }
    
    //MARK: Fuctions to Configure UI
    func configureFortuneWheelUI(){
        fortuneWheel.configuration = .defaultConfiguration
        fortuneWheel.slices = createSlices()
        fortuneWheel.onSpinButtonTap = {
            if !self.isSpinning{
                self.spinButton(self)
            }
        }
        
        //added to edit constrains
        fortuneWheel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fortuneWheel)
        
        let isCompactWidth = traitCollection.horizontalSizeClass == .compact
        let constantValue: CGFloat = isCompactWidth ? 370 : 500
        
        NSLayoutConstraint.activate([
            fortuneWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fortuneWheel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fortuneWheel.widthAnchor.constraint(equalToConstant: constantValue),
            fortuneWheel.heightAnchor.constraint(equalToConstant: constantValue)
        ])
    }
    
    
    func configureButtonUI(){
        goBackBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goBackBtn)
        
        //create top constraint with 20 padding points
        let topConstraint = goBackBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        
        //create leading constraint with 20
        let leadingConstraint = goBackBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        
        //activate the constraints
        NSLayoutConstraint.activate([topConstraint, leadingConstraint])
        
        goBackBtn.addTarget(self, action: #selector(goBackDismissAction), for: .touchUpInside)
    }
    
    //MARK: @IBAction Functions
    @IBAction func spinButton(_ sender: Any) {
        if !self.isSpinning{
            spin()
        }
    }
    
    //MARK: Spin Function
    func spin(){
        arrayCount = array.count
        let finishAtIndex = Int.random(in: 0...arrayCount-1)
        
        guard finishAtIndex >= 0 && finishAtIndex < arrayCount else {
            print("Index \(finishAtIndex) is out of bounds")
            showSomethingWentWrongAlert()
            return
        }
        
        ///making self.isSpinning = true
        /// because if index is out of bound it will return from spin function(its checking in above guard ) ,
        /// so if index is not out of bound then only we need to make self.isSpinning = true ,
        ///  otherwise we need additional one more step to make it false
        ///  thats why we given self.isSpinning = true , under the  guard
        self.isSpinning = true
        fortuneWheel.startRotationAnimation(finishIndex: finishAtIndex, continuousRotationTime: 1) { (finished) in
            //MARK: End of Spinning
            // this area works only after spin animation stops
            // also if we print finished it will print true
            self.showOutcomeAlert(_outcomeIndex: finishAtIndex)
            self.isSpinning = false
            
        }
        
    }
    
    //MARK: @objc Functions
    @objc func goBackDismissAction() {
        self.dismiss(animated: true,completion: nil)
    }
    
    //MARK: Create Slices Function
    func createSlices()->[Slice]{
        var slices: [Slice] = []
        self.array.removeAll()
        
        let colors: [UIColor] = Constants.colors
        let offerImages:[String] = Constants.offerImages
        
        for each in 0...7{
            let imagePreferences = ImagePreferences(preferredSize: CGSize(width: 60, height: 60), verticalOffset: 40)
            let imageSliceContent = Slice.ContentType.assetImage(name: offerImages[each], preferences: imagePreferences)
            
            let newSliceContent = Slice.ContentType.text(text: "\(each)", preferences: .init(textColorType:.customPatternColors(colors: [UIColor.black], defaultColor: UIColor.black), font: .boldSystemFont(ofSize: 16)))
            
            let slice = Slice(contents: [imageSliceContent,newSliceContent],backgroundColor: colors[each])
            slices.append(slice)
            self.array.append(slice)
        }
        return slices
    }
    
    //MARK: Alert Function
    func showOutcomeAlert(_outcomeIndex:Int) {
        let offers:[String] = Constants.offers
        
        var alertTitle:String =  "Congratulation 🎁"
        let alertMessage:String = offers[_outcomeIndex]
        
        if _outcomeIndex == 0 || _outcomeIndex == 4 {
            alertTitle = "Oops"
        }
        
        let alert = UIAlertController(title:alertTitle, message:alertMessage , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Spin again",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
            if !self.isSpinning{
                self.spinButton(self)
            }
        }))
        alert.addAction(UIAlertAction(title: "Got it",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showSomethingWentWrongAlert(){
        let alert = UIAlertController(title:"Something went wrong ⚠️", message:"try after sometime..." , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "got it",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


//MARK: Constants Struct
struct Constants{
    static let offers: [String] = [
        "Try again",
        "Trip to Goa",
        "Cashback of 100 rupees",
        "Gift card for Shoes",
        "Better luck next time",
        "2 Tickets on BVR",
        "Free Carwash",
        "Discount coupon for iPhone 15"
        
    ]
    
    static let offerImages:[String] = [
        "offer-8_TryAgain",
        "offer-1_goaTour",
        "offer-2_100rs",
        "offer-3_shoeGiftCard",
        "offer-4_betterluck",
        "offer-9-2cinemaTicket",
        "offer-1_freecarwash",
        "offer-10_apple"
    ]
    
    static let colors: [UIColor] = [
        UIColor.red,
        UIColor.blue,
        UIColor.green,
        UIColor.orange,
        UIColor.purple,
        UIColor.yellow,
        UIColor.magenta,
        UIColor.brown
    ]
}

//MARK: Extensions
extension SFWConfiguration {
    static var defaultConfiguration: SFWConfiguration {
        let sliceColorType = SFWConfiguration.ColorType.evenOddColors(evenColor: .yellow, oddColor: .orange)
        
        let slicePreferences = SFWConfiguration.SlicePreferences(backgroundColorType: sliceColorType, strokeWidth: 5, strokeColor: .white)
        
        let circlePreferences = SFWConfiguration.CirclePreferences(strokeWidth: 8, strokeColor: .white)
        
        let wheelPreferences = SFWConfiguration.WheelPreferences(circlePreferences: circlePreferences, slicePreferences: slicePreferences, startPosition: .bottom)
        
        var spinButtonPreferences = SFWConfiguration.SpinButtonPreferences(size: CGSize(width: 100, height: 100))
        spinButtonPreferences.backgroundColor = .cyan
        spinButtonPreferences.cornerRadius = 50
        
        var pinImage = SFWConfiguration.PinImageViewPreferences(size: CGSize(width: 10, height: 20), position: .bottom)
        pinImage.backgroundColor = .clear
        pinImage.tintColor = .black
        
        
        let configuration = SFWConfiguration(wheelPreferences: wheelPreferences,pinPreferences: pinImage, spinButtonPreferences: spinButtonPreferences)
        
        
        return configuration
    }
}

