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
    
    
    //MARK: @IBOutlet varibles
    @IBOutlet weak var fortuneWheel: SwiftFortuneWheel! {
        didSet {
            //turns on tap gesture recognizer
            fortuneWheel.wheelTapGestureOn = true
            
            //selected index by tap
            fortuneWheel.onWheelTap = { (index) in
                print("tap to index: \(index)")
            }
        }
    }
    
    @IBOutlet var goBackBtn: UIButton!
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureFortuneWheelUI()
        configureButtonUI()
    }
    
    
    //MARK: Fuctions to Configure UI
    func configureFortuneWheelUI(){
        fortuneWheel.configuration = .defaultConfiguration
        fortuneWheel.slices = createSlices()
        fortuneWheel.onSpinButtonTap = {
            self.spinButton(self)
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
                
                // Create top constraint with 20 points padding
                let topConstraint = goBackBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
                
                // Create leading constraint with 20 points padding
                let leadingConstraint = goBackBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
                
                // Activate the constraints
                NSLayoutConstraint.activate([topConstraint, leadingConstraint])
        
        // Add tap action to the button
        goBackBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    //MARK: @IBAction Functions
    @IBAction func spinButton(_ sender: Any) {
        arrayCount = array.count
        print(arrayCount)
        let finishAtIndex = Int.random(in: 0...arrayCount-1)
        fortuneWheel.startRotationAnimation(finishIndex: finishAtIndex, continuousRotationTime: 1) { (finished) in
            print(finished)
            self.showAlert(_outcome: finishAtIndex)
            print("finished")
        }
        
       
    }
    
    //MARK: @objc Functions
    @objc func buttonTapped() {
            // Handle button tap here
            print("Button tapped!")
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
    func showAlert(_outcome:Int) {
        let offers:[String] = Constants.offers
        
        var alertTitle:String =  "Congratulation 🎁"
        let alertMessage:String = offers[_outcome]
        
        if _outcome == 0 || _outcome == 4 {
            alertTitle = "Oops"
        }
        
        let alert = UIAlertController(title:alertTitle, message:alertMessage , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Spin again",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
            self.spinButton(self)
        }))
        alert.addAction(UIAlertAction(title: "Got it",
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

//MARK: Extension
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



