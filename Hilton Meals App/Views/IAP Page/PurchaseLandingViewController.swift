//
//  PurchaseLandingViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/05/22.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PurchaseLandingViewController: UIViewController {

    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var randPurchaseButton: UIButton!
    @IBOutlet weak var coinPurchaseButton: UIButton!
    @IBOutlet weak var currentCoinLabel: UILabel!
    var coins = Int(UserDefaults.standard.string(forKey: "Coins") ?? "0")
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IAPService.shared.getProducts()
        
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
        
        randPurchaseButton.layer.cornerRadius = 20.0
        coinPurchaseButton.layer.cornerRadius = 20.0
        restoreButton.layer.cornerRadius = 20.0
        
        setStatusBarBackgroundColor(color: .white)
        
        currentCoinLabel.text = "Current coins: \(coins ?? 0)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func currencyButtonPressed(_ sender: UIButton) {
        IAPService.shared.purchase(product: .removeAds)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func coinButtonPressed(_ sender: UIButton) {
        presentCoinsAlert()
    }
    
    @IBAction func restoreButtonPressed(_ sender: UIButton) {
        IAPService.shared.restorePurchases()
    }
    
    func presentCoinsAlert() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you would like to make this purchase?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.makePurchase()
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    func makePurchase() {
        if coins ?? 0 >= 2500 {
            UserDefaults.standard.set(true, forKey: "hasRemovedAds")
            coins = coins! - 2500
            UserDefaults.standard.set(coins, forKey: "coins")
            currentCoinLabel.text = "Current coins: \(coins ?? 0)"
            bannerView.isHidden = true
        } else {
            let alert = UIAlertController(title: "Oops", message: "You do not have enough coins. You need 2500 to remove ads", preferredStyle: .alert)
            let exitAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(exitAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
}

extension PurchaseLandingViewController : GADBannerViewDelegate {
    
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
}
