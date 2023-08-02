//
//  AdViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/05/14.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdViewController: UIViewController {
    

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    let currentCoins = Int(UserDefaults.standard.string(forKey: "Coins") ?? "0")
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityView.alpha = 0.0
        showButton.layer.cornerRadius = 20.0
        activityView.startAnimating()
        
        bannerView.adUnitID = "***"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        addBannerViewToView(bannerView)
        
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            activityView.stopAnimating()
            
            UIView.animate(withDuration: 1) {
                self.activityView.alpha = 0.0
                self.showButton.alpha = 1.0
            }
        }
        
        if UserDefaults.standard.bool(forKey: "hasRemovedAds") {
            bannerView.isHidden = true
        } else {
            bannerView.isHidden = false
        }
        
        applyTheme()
        
        // Do any additional setup after loading the view.

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        currentLabel.text = "Current coins is: \(currentCoins ?? 0)"
    }

    @IBAction func refresh(_ sender: UIButton) {
        updateView()
    }
    
    @IBAction func showButtonPressed(_ sender: UIButton) {
        
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            activityView.stopAnimating()
            
            UIView.animate(withDuration: 1) {
                self.activityView.alpha = 0.0
                self.showButton.alpha = 1.0
            }
            
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
            
        } else {
            
            topLabel.text = "Error loading video"
            
        }
        
    }
}

extension AdViewController : GADBannerViewDelegate {
    
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
    
    func updateView() {
        let coins = Int(UserDefaults.standard.string(forKey: "Coins") ?? "0")
        let valueToSet = coins ?? 0 + 1
        currentLabel.text = "Current coins is: \(valueToSet)"
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.current.backgroundColour
        titleLabel.textColor = Theme.current.textColour
        subtitleLabel.textColor = Theme.current.textColour
        currentLabel.textColor = Theme.current.textColour
        showButton.backgroundColor = Theme.current.textColour
        showButton.setTitleColor(Theme.current.backgroundColour, for: .normal)
    }
}
