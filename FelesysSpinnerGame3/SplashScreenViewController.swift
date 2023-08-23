//
//  SplashScreenViewController.swift
//  FelesysSpinnerGame3
//
//  Created by Apple  on 23/08/23.
//

import UIKit

class SplashScreenViewController: UIViewController {

    
    @IBAction func btnAction(_ sender: Any) {
        performSegue(withIdentifier: "showGameScreen", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation
     

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
