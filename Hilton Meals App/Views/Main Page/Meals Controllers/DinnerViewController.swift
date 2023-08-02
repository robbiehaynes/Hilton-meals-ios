//
//  DinnerViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/01.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import FirebaseDatabase
import AVFoundation

class DinnerViewController: UIViewController, GADBannerViewDelegate {

    let network = NetworkManager.sharedInstance
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
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
        
        let holdGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(speakVoice))
        self.view.addGestureRecognizer(holdGestureRecognizer)
        
        mealLabel.text = ""
        retrieveMessage()
        applyTheme()
        if view.backgroundColor == UIColor.black {
            setStatusBarBackgroundColor(color: .white)
        } else if view.backgroundColor == UIColor.white {
            setStatusBarBackgroundColor(color: .white)
        }
        
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
    
    @objc func speakVoice() {
        let utterance = AVSpeechUtterance(string: "Dinner is \(mealLabel.text ?? "")")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
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
            
            let dinnerValue = snapshotValue["Dinner"]
            self.mealLabel.text = dinnerValue
        }
    }
    func applyTheme() {
        
        logoImage.image = Theme.current.logoImage
        mealLabel.textColor = Theme.current.textColour
        mealTypeLabel.textColor = Theme.current.textColour
        view.backgroundColor = Theme.current.backgroundColour
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
}
