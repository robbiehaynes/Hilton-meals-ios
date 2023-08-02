//
//  SettingsViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/01.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    var nameText = ""
    var name : String = ""
    var defaults = UserDefaults.standard
    var activeTextField : UITextField!
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextPageIcon: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var nextPageIconTwo: UIImageView!
    @IBOutlet weak var adminLoginView: UIView!
    @IBOutlet weak var nextPageIconThree: UIImageView!
    @IBOutlet weak var purchaseItemsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showSecondView))
        let swipeGestureRecognizerTwo = UISwipeGestureRecognizer(target: self, action: #selector(showSecondViewTwo))
        swipeGestureRecognizer.direction = .left
        swipeGestureRecognizerTwo.direction = .left
        adminLoginView.addGestureRecognizer(swipeGestureRecognizer)
        
        if UserDefaults.standard.string(forKey: "nameValue") == "" {
            nameInput.placeholder = "Example"
        } else {
        nameInput.placeholder = UserDefaults.standard.string(forKey: "nameValue")
        }
        
        nameInput.delegate = self

        if UserDefaults.standard.bool(forKey: "LightTheme") == true {
            darkModeSwitch.setOn(true, animated: true)
            nameInput.textColor = Theme.current.textColour
            closeButton.setBackgroundImage(UIImage(named: "Close Button"), for: .normal)
            nextPageIcon.image = UIImage(named: "Next Page Icon")
            nextPageIconTwo.image = UIImage(named: "Next Page Icon")
            nextPageIconThree.image = UIImage(named: "Next Page Icon")
        } else {
            darkModeSwitch.setOn(false, animated: true)
            nameInput.borderStyle = .roundedRect
            nameInput.backgroundColor = UIColor.white
            nameInput.textColor = Theme.current.backgroundColour
            closeButton.setBackgroundImage(UIImage(named: "Close Button Black"), for: .normal)
            nextPageIcon.image = UIImage(named: "Next Page Icon White")
            nextPageIconTwo.image = UIImage(named: "Next Page Icon White")
            nextPageIconThree.image = UIImage(named: "Next Page Icon White")
        }
        
        applyTheme()
        
        darkModeLabel.alpha = 0.0
        darkModeSwitch.alpha = 0.0
        nameLabel.alpha = 0.0
        nameInput.alpha = 0.0
        adminLabel.alpha = 0.0
        nextPageIcon.alpha = 0.0
        resetLabel.alpha = 0.0
        nextPageIconTwo.alpha = 0.0
        closeButton.alpha = 0.0
        purchaseItemsLabel.alpha = 0.0
        nextPageIconThree.alpha = 0.0
        
        if topBarView.backgroundColor == UIColor.black {
            setStatusBarBackgroundColor(color: .black)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
            self.darkModeLabel.alpha = 1.0
            self.darkModeSwitch.alpha = 1.0
            self.nameLabel.alpha = 1.0
            self.nameInput.alpha = 1.0
            self.adminLabel.alpha = 1.0
            self.nextPageIcon.alpha = 1.0
            self.resetLabel.alpha = 1.0
            self.nextPageIconTwo.alpha = 1.0
            self.purchaseItemsLabel.alpha = 1.0
            self.nextPageIconThree.alpha = 1.0
            
        })
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.closeButton.alpha = 1.0
            self.closeButton.transform = CGAffineTransform(rotationAngle: 355)
        })
        
        if topBarView.backgroundColor == UIColor.black {
            setStatusBarBackgroundColor(color: .black)
        } else {
            setStatusBarBackgroundColor(color: .white)
        }
    }

    func hideKeyboard()
    {
        nameInput.resignFirstResponder()
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.closeButton.transform = CGAffineTransform(rotationAngle: 355)
        }) { (_) in
            self.performSegue(withIdentifier: "toRoot", sender: self)
        }
        
    }
    

    @IBAction func themeChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            Theme.current = LightTheme()
            nameInput.borderStyle = .none
            nameInput.backgroundColor = UIColor.white
            nameInput.textColor = UIColor.black
            nameInput.keyboardAppearance = .light
            closeButton.setBackgroundImage(UIImage(named: "Close Button"), for: .normal)
            nextPageIcon.image = UIImage(named: "Next Page Icon")
            resetLabel.textColor = .black
            nextPageIconTwo.image = UIImage(named: "Next Page Icon")
            nextPageIconThree.image = UIImage(named: "Next Page Icon")
            setStatusBarBackgroundColor(color: .black)
            
        } else {
            Theme.current = DarkTheme()
            nameInput.borderStyle = .roundedRect
            nameInput.backgroundColor = UIColor.white
            nameInput.textColor = UIColor.black
            nameInput.keyboardAppearance = .dark
            closeButton.setBackgroundImage(UIImage(named: "Close Button Black"), for: .normal)
            nextPageIcon.image = UIImage(named: "Next Page Icon White")
            resetLabel.textColor = .white
            nextPageIconTwo.image = UIImage(named: "Next Page Icon White")
            nextPageIconThree.image = UIImage(named: "Next Page Icon White")
            setStatusBarBackgroundColor(color: .white)
        }
        
        UserDefaults.standard.set(sender.isOn, forKey: "LightTheme")
        
        applyTheme()
    }
    
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toAdRemove", sender: self)
    }
    
    @IBAction func adminLoginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToAdmin", sender: self)
    }
    

    
    @IBAction func setupButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "You will reset your current settings", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.performSegue(withIdentifier: "ToSetup", sender: self)
            UserDefaults.standard.set(false, forKey: "setupCompleted")
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameInput.text == "" {
            hideKeyboard()
        } else {
            name = nameInput.text!
            defaults.set(self.name, forKey: "nameValue")
            hideKeyboard()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameInput.text == "" {
            hideKeyboard()
        } else {
            name = nameInput.text!
            defaults.set(self.name, forKey: "nameValue")
            hideKeyboard()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func showSecondView() {
        performSegue(withIdentifier: "ToAdmin", sender: self)
    }
    
    @objc func showSecondViewTwo() {
        performSegue(withIdentifier: "ToSetup", sender: self)
    }
    
    func applyTheme() {
        
        resetLabel.textColor = Theme.current.textColour
        topBarView.backgroundColor = Theme.current.textColour
        settingsLabel.textColor = Theme.current.backgroundColour
        darkModeLabel.textColor = Theme.current.textColour
        nameLabel.textColor = Theme.current.textColour
        adminLabel.textColor = Theme.current.textColour
        view.backgroundColor = Theme.current.backgroundColour
        contentView.backgroundColor = Theme.current.backgroundColour
        purchaseItemsLabel.textColor = Theme.current.textColour
        scrollView.backgroundColor = Theme.current.backgroundColour
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }

}
