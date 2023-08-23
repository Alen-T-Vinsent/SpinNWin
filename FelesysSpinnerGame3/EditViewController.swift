//
//  EditViewController.swift
//  FelesysSpinnerGame3
//
//  Created by Apple  on 23/08/23.
//

import UIKit
import SwiftFortuneWheel

class EditViewController: UIViewController {

    weak var delegate:EditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didUpdateSpinner(slices: createSlices())
        dismiss(animated: true,completion: nil)
    }
    
    
    

    //MARK: Functions
    func createSlices()->[Slice]{
        var slices: [Slice] = []
        
        let colors: [UIColor] = Constants.colors
        
        let offerImages:[String] = Constants.offerImages
        
        for each in 0...4{
            let imagePreferences = ImagePreferences(preferredSize: CGSize(width: 60, height: 60), verticalOffset: 40)
            let imageSliceContent = Slice.ContentType.assetImage(name: offerImages[each], preferences: imagePreferences)
            
            let newSliceContent = Slice.ContentType.text(text: "\(each)", preferences: .init(textColorType:.customPatternColors(colors: [UIColor.black], defaultColor: UIColor.black), font: .boldSystemFont(ofSize: 16)))
            
            let slice = Slice(contents: [imageSliceContent,newSliceContent],backgroundColor: colors[each])
            slices.append(slice)
        }
        return slices
    }
    
}


protocol EditViewControllerDelegate:AnyObject{
    func didUpdateSpinner(slices:[Slice])
    
}
