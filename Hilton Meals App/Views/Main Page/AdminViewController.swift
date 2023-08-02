//
//  AdminViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/02.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class AdminViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dinnerText: UILabel!
    @IBOutlet weak var lunchText: UILabel!
    @IBOutlet weak var teaText: UILabel!
    @IBOutlet weak var breakfastText: UILabel!
    @IBOutlet weak var breakfastTextField: UITextField!
    @IBOutlet weak var teaTextField: UITextField!
    @IBOutlet weak var lunchTextField: UITextField!
    @IBOutlet weak var dinnerTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var contentsView: UIView!
    
    
    var activeTextField : UITextField!
    let passwordAlert = UIAlertController(title: "Enter the password", message: "", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        breakfastTextField.delegate = self
        teaTextField.delegate = self
        lunchTextField.delegate = self
        dinnerTextField.delegate = self
        
        updatePlaceholders()

        breakfastText.alpha = 0.0
        breakfastTextField.alpha = 0.0
        teaText.alpha = 0.0
        teaTextField.alpha = 0.0
        lunchText.alpha = 0.0
        lunchTextField.alpha = 0.0
        dinnerText.alpha = 0.0
        dinnerTextField.alpha = 0.0
        
    }
    

    override func viewDidAppear(_ animated: Bool) {

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.breakfastText.alpha = 1.0
            self.breakfastTextField.alpha = 1.0
            self.teaText.alpha = 1.0
            self.teaTextField.alpha = 1.0
            self.lunchText.alpha = 1.0
            self.lunchTextField.alpha = 1.0
            self.dinnerText.alpha = 1.0
            self.dinnerTextField.alpha = 1.0
            self.breakfastText.transform = CGAffineTransform(translationX: 0, y: -100)
            self.breakfastTextField.transform = CGAffineTransform(translationX: 0, y: -100)
            self.teaTextField.transform = CGAffineTransform(translationX: 0, y: -100)
            self.teaText.transform = CGAffineTransform(translationX: 0, y: -100)
            self.lunchTextField.transform = CGAffineTransform(translationX: 0, y: -100)
            self.lunchText.transform = CGAffineTransform(translationX: 0, y: -100)
            self.dinnerTextField.transform = CGAffineTransform(translationX: 0, y: -100)
            self.dinnerText.transform = CGAffineTransform(translationX: 0, y: -100)
            
        }) { (_) in
            self.displayAlert()
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        updateData()
    }
    
    @IBAction func tomorrowValueChanged(_ sender: UISwitch) {
        
    }
    func hideKeyboard()
    {
        breakfastTextField.resignFirstResponder()
        teaTextField.resignFirstResponder()
        lunchTextField.resignFirstResponder()
        dinnerTextField.resignFirstResponder()
    }
    
    func displayAlert()
    {
        passwordAlert.addTextField(configurationHandler: { (textField) in
            textField.text = ""
            textField.placeholder = "Password Here"
            textField.textContentType = .password
            textField.returnKeyType = .go
            textField.isSecureTextEntry = true
        })
        
        let enterAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            
            let textField = self.passwordAlert.textFields![0]
            
            Auth.auth().signIn(withEmail:"admin@hiltoncollege.com", password: textField.text!, completion: { (result, error) in
                
                if error != nil {
                    let errorAlert = UIAlertController(title: "Oops", message: error!.localizedDescription, preferredStyle: .alert)
                    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                        self.present(self.passwordAlert, animated: true, completion: nil)
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    errorAlert.addAction(tryAgainAction)
                    errorAlert.addAction(cancelAction)
                    
                    self.present(errorAlert, animated: true, completion: nil)
                } else {
                    self.passwordAlert.dismiss(animated: true, completion: nil)
                }
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        passwordAlert.addAction(enterAction)
        passwordAlert.addAction(cancelAction)
        
        present(passwordAlert, animated: true, completion: nil)
        
    }
    
    func updateData()
    {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_JP")

        
        let mealsDatabase = Database.database().reference().child("MealsData/\(formatter.string(from: Date()))")
        let mealsDictionary = ["Breakfast":breakfastTextField.text!,"Tea":teaTextField.text!,"Lunch":lunchTextField.text!,"Dinner":dinnerTextField.text!]
        
        mealsDatabase.childByAutoId().setValue(mealsDictionary) {
            (error, reference) in
            
            if error != nil {
                
                let errorAlert = UIAlertController(title: "Oops!", message: error!.localizedDescription, preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                    self.present(self.passwordAlert, animated: true, completion: nil)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                errorAlert.addAction(tryAgainAction)
                errorAlert.addAction(cancelAction)
                self.present(errorAlert, animated: true, completion: nil)
                
            } else {
                let successAlert = UIAlertController(title: "Success!", message: "The data has been saved successfully", preferredStyle: .alert)
                let exitAction = UIAlertAction(title: "Exit", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                successAlert.addAction(exitAction)
                self.present(successAlert, animated: true, completion: nil)
                print("Data saved successfully")
                
            }
        }
    }
    
    func updatePlaceholders()
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_JP")
        
        let mealsDatabase = Database.database().reference().child("MealsData/\(formatter.string(from: Date()))")
        
        mealsDatabase.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let breakfastValue = snapshotValue["Breakfast"]
            let lunchValue = snapshotValue["Lunch"]
            let teaValue = snapshotValue["Tea"]
            let dinnerValue = snapshotValue["Dinner"]
            
            self.breakfastTextField.placeholder = breakfastValue
            self.lunchTextField.placeholder = lunchValue
            self.teaTextField.placeholder = teaValue
            self.dinnerTextField.placeholder = dinnerValue
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    
}
