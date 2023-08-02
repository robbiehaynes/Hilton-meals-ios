//
//  RootPageViewController.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/01.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    lazy var viewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "BreakfastVC")
        let vc2 = sb.instantiateViewController(withIdentifier: "TeaVC")
        let vc3 = sb.instantiateViewController(withIdentifier: "LunchVC")
        let vc4 = sb.instantiateViewController(withIdentifier: "DinnerVC")
        let vc5 = sb.instantiateViewController(withIdentifier: "AdVC")
        let vc6 = sb.instantiateViewController(withIdentifier: "DROVC")
        
        return [vc1, vc2, vc3, vc4, vc5, vc6]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { if view.backgroundColor == UIColor.black {
        return .lightContent
    } else {
        return .default
        }
    }
    

}
