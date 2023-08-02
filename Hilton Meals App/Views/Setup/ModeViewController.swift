//
//  ModeViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/10.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit

class ModeViewController: UIViewController {

    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var lightModeLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toggleSwitch.alpha = 0.0
        lightModeLabel.alpha = 0.0
        confirmButton.layer.cornerRadius = 20.0
        confirmButton.alpha = 0.0
        
        if view.backgroundColor == UIColor.black {
            setStatusBarBackgroundColor(color: .white)
        } else if view.backgroundColor == UIColor.white {
            setStatusBarBackgroundColor(color: .white)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 1.5, options: .curveEaseOut, animations: {
            
            self.lightModeLabel.alpha = 1.0
            self.toggleSwitch.alpha = 1.0
            
            self.lightModeLabel.transform = self.lightModeLabel.transform.translatedBy(x: 0, y: self.view.center.y-80)
            self.toggleSwitch.transform = self.toggleSwitch.transform.translatedBy(x: 0, y: self.view.center.y-80)
            
        })
        
        UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseIn, animations: {
            self.confirmButton.alpha = 1.0
        })
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            Theme.current = LightTheme()
            view.backgroundColor = .white
            lightModeLabel.textColor = .black
            confirmButton.backgroundColor = .black
            confirmButton.setTitleColor(.white, for: .normal)
            setStatusBarBackgroundColor(color: .white)
        } else {
            Theme.current = DarkTheme()
            view.backgroundColor = .black
            lightModeLabel.textColor = .white
            confirmButton.backgroundColor = .white
            confirmButton.setTitleColor(.black, for: .normal)
            setStatusBarBackgroundColor(color: .black)
        }
        
        UserDefaults.standard.set(sender.isOn, forKey: "LightTheme")
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "setupCompleted")
        
        if toggleSwitch.isOn {
            Theme.current = LightTheme()
        } else {
            Theme.current = DarkTheme()
        }
        
        UserDefaults.standard.set(toggleSwitch.isOn, forKey: "LightTheme")
        
        if UserDefaults.standard.bool(forKey: "policyAccepted") == true {
            performSegue(withIdentifier: "toMain", sender: self)
        } else {
            performSegue(withIdentifier: "toPolicy", sender: self)
        }
    }
    

    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
}
