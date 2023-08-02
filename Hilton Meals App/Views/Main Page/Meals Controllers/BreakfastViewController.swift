//
//  BreakfastViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/01.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import Reachability
import FirebaseDatabase
import AVFoundation

class BreakfastViewController: UIViewController , GADBannerViewDelegate{
    
    let defaults = UserDefaults.standard
    var name = ""
    var localBreakfastID = ""
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    let network = NetworkManager.sharedInstance
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var mealTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "***"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        addBannerViewToView(bannerView)
        
        if UserDefaults.standard.bool(forKey: "hasRemovedAds") {
            bannerView.isHidden = true
        } else {
            bannerView.isHidden = false
        }
        
        
        mealLabel.text = ""
        let swipeGestureRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showSecondViewController))
        swipeGestureRecognizer.direction = .down
        let holdGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(speakVoice))
        self.view.addGestureRecognizer(holdGestureRecognizer)
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        
        name = defaults.string(forKey: "nameValue") ?? ""
        welcomeLabel.text = "Welcome \(name)"
        
        applyTheme()
        retrieveMessage()
        
        if view.backgroundColor == UIColor.black {
            setStatusBarBackgroundColor(color: .white)
        } else if view.backgroundColor == UIColor.white {
            setStatusBarBackgroundColor(color: .white)
        }
        
        welcomeLabel.alpha = 1.0
        settingsButton.alpha = 1.0
        logoImage.alpha = 1.0
        mealTypeLabel.alpha = 0.0
        mealLabel.alpha = 0.0
        
        network.reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "NetworkOffline", sender: self)
            }
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view.safeAreaLayoutGuide.bottomAnchor,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2) {
            self.mealLabel.alpha = 1.0
            self.mealTypeLabel.alpha = 1.0
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            self.settingsButton.transform = CGAffineTransform(rotationAngle: 355.0)
        }) { (_) in
            self.performSegue(withIdentifier: "ToSettings", sender: self)
        }
    }

    func retrieveMessage()
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_JP")
        
        
        let mealsDatabase = Database.database().reference().child("MealsData/\(formatter.string(from: Date()))")
            
            mealsDatabase.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as! Dictionary<String,String>
                let breakfastValue = snapshotValue["Breakfast"]
                self.mealLabel.text = breakfastValue
        
        }
        
        createUserActivity()
        
        print("Recieved a message")
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle { if view.backgroundColor == UIColor.black {
//        return .lightContent
//    } else {
//        return .default
//        }
//    }
    @objc func speakVoice() {
        let utterance = AVSpeechUtterance(string: "Hi \(UserDefaults.standard.string(forKey: "nameValue") ?? ""). Breakfast is \(mealLabel.text ?? "")")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @objc func showSecondViewController() {
        UIView.animate(withDuration: 1, animations: {
            self.settingsButton.transform = CGAffineTransform(rotationAngle: 355.0)
        }) { (_) in
            self.performSegue(withIdentifier: "ToSettings", sender: self)
        }
    }
    
    func applyTheme() {

         settingsButton.setBackgroundImage(Theme.current.settingsImage, for: .normal)
        logoImage.image = Theme.current.logoImage
        welcomeLabel.textColor = Theme.current.textColour
        mealLabel.textColor = Theme.current.textColour
        mealTypeLabel.textColor = Theme.current.textColour
        view.backgroundColor = Theme.current.backgroundColour
        
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    
    func createUserActivity() {
        let activity = NSUserActivity(activityType: UserActivityType.CheckMeals)
        
        activity.title = "What's cooking?"
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
        
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
    }
}
