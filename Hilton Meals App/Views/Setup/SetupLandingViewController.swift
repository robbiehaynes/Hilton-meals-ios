//
//  SetupLandingViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/10.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit

class SetupLandingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    var activeTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nameInput.delegate = self
        
        hiLabel.alpha = 0.0
        welcomeLabel.alpha = 0.0
        nameLabel.alpha = 0.0
        nameInput.alpha = 0.0
        
        if view.backgroundColor == UIColor.black {
            setStatusBarBackgroundColor(color: .white)
        } else if view.backgroundColor == UIColor.white {
            setStatusBarBackgroundColor(color: .white)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 3, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
            self.hiLabel.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                self.hiLabel.alpha = 0.0
            })
        }
        
        UIView.animate(withDuration: 3, delay: 4.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
            self.welcomeLabel.alpha = 1.0
        }, completion: { (_) in
            UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                self.welcomeLabel.alpha = 0.0
            }, completion: { (_) in
                
            })
        })
        UIView.animate(withDuration: 1, delay: 8, options: .curveEaseOut, animations: {
            
            self.nameLabel.alpha = 1.0
            self.nameLabel.transform = self.nameLabel.transform.translatedBy(x: 0, y: 200)
            
        })
        UIView.animate(withDuration: 1, delay: 8, options: .curveEaseOut, animations: {
            
            self.nameInput.alpha = 1.0
            self.nameInput.transform = self.nameInput.transform.translatedBy(x: 0, y: -220)
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameInput.text != nil || nameInput.text == "" { UserDefaults.standard.set(nameInput.text!, forKey: "nameValue")
        } else {
            let alert = UIAlertController(title: "Invalid Entry", message: "Please enter a valid name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.nameInput.endEditing(true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameInput.text != nil || nameInput.text == ""{ UserDefaults.standard.set(nameInput.text!, forKey: "nameValue")
            print("name saved")
            nameInput.resignFirstResponder()
            performSegue(withIdentifier: "LandingToMode", sender: self)
        } else {
            let alert = UIAlertController(title: "Invalid Entry", message: "Please enter a valid name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.nameInput.endEditing(true)
            }))
            nameInput.resignFirstResponder()
            self.present(alert, animated: true, completion: nil)
        }
        
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
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
