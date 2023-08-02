//
//  ViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/03/30.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit
import LocalAuthentication
import FirebaseRemoteConfig

class LandingPage: UIViewController {

    let whiteEnter = UIImage(named: "Enter Button White")
    let enter = UIImage(named: "Enter Button")
    @IBOutlet weak var HaynesDevLogo: UIImageView!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        if view.backgroundColor == UIColor.black {
            navigationController?.navigationBar.barStyle = .default
        } else {
            navigationController?.navigationBar.barStyle = .black
        }
        
        let name = UserDefaults.standard.string(forKey: "nameValue") ?? ""
        welcomeText.text = "Welcome \(name)"
        
        logoImage.image = Theme.current.logoImage
        view.backgroundColor = Theme.current.backgroundColour
        welcomeText.textColor = Theme.current.textColour
        HaynesDevLogo.image = Theme.current.haynesDevLogo
        enterButton.setBackgroundImage(Theme.current.enterImage, for: .normal)
        disclaimerLabel.textColor = Theme.current.textColour
        
        disclaimerLabel.alpha = 0.0
        welcomeText.alpha = 0.0
        logoImage.alpha = 0.0
        enterButton.alpha = 0.0
        HaynesDevLogo.alpha = 0.0
        if view.backgroundColor == UIColor.black {
            setStatusBarBackgroundColor(color: .black)
        } else {
            setStatusBarBackgroundColor(color: .white)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2, delay: 1, options: .curveEaseIn, animations: {
            self.welcomeText.alpha = 1.0
            self.logoImage.alpha = 1.0
            self.HaynesDevLogo.alpha = 1.0
            self.disclaimerLabel.alpha = 1.0
        })
        
        UIView.animate(withDuration: 1.5, delay: 1, options: .curveEaseOut, animations: {
                self.enterButton.alpha = 1.0
                self.enterButton.transform = CGAffineTransform(translationX: 0, y: -100)
            })
    }
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        
        
        if UserDefaults.standard.bool(forKey: "setupCompleted") == true {
            
            if UserDefaults.standard.bool(forKey: "policyAccepted") == false {
                performSegue(withIdentifier: "toPolicy", sender: self)
            } else {
                animateElements()
                NetworkManager.isReachable { (_) in
                    self.performSegue(withIdentifier: "LandingToMain", sender: self)
                }
                NetworkManager.isUnreachable { (_) in
                    self.performSegue(withIdentifier: "NetworkOffline", sender: self)
                }
            }
            
        } else {
            
            animateElements()
    
            performSegue(withIdentifier: "LandingToSetup", sender: self)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { if view.backgroundColor == UIColor.black {
        return .lightContent
    } else {
        return .default
        }
    }
    
    func animateElements() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            self.HaynesDevLogo.alpha = 0.0
            self.welcomeText.alpha = 0.0
            self.logoImage.alpha = 0.0
            self.enterButton.alpha = 0.0
            self.disclaimerLabel.alpha = 0.0
        })
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
}

