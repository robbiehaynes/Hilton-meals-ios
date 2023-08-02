//
//  PolicyViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/05/29.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit

class PolicyViewController: UIViewController {

    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var TandCButton: UIButton!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var footerText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme()
        finishButton.layer.cornerRadius = 20.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "policyAccepted")
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    
    @IBAction func TandCButtonPressed(_ sender: UIButton) {
        let url = URL(string: "https://hiltonmeals.co.za/terms-and-conditions/termsandconditions.html")
        UIApplication.shared.open(url!)
    }
    
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        let url = URL(string: "https://hiltonmeals.co.za/privacy-policy/policy.html")
        UIApplication.shared.open(url!)
    }
    
    func applyTheme() {
        mainText.textColor = Theme.current.textColour
        heading.textColor = Theme.current.textColour
        view.backgroundColor = Theme.current.backgroundColour
        footerText.textColor = Theme.current.textColour
        finishButton.setTitleColor(Theme.current.backgroundColour, for: .normal)
        finishButton.backgroundColor = Theme.current.textColour
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
