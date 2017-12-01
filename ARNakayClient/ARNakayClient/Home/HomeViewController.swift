//
//  MainViewController.swift
//  ARKitClient
//
//  Created by NelliStudio on 25/10/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    var index: Int = 0
    let imageArray = ["wallpaper_swift_0", "wallpaper_swift_1", "wallpaper_swift_2"]

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var menuLogOut: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        addSlideMenuButton()
        createPageViewController()
        setupPageControl()
    }
    
    func createPageViewController() {
        let pageController = self.storyboard?.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        
        pageController.dataSource = self
        
        if imageArray.count > 0 {
            let firstController = getItemController(0)
            let startingViewControllers = [firstController]
            
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }
    
    func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor(red: 0, green: 149, blue: 255, alpha: 0.00)
    }
    
    // avant
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! ItemViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        
        // return nil
        return getItemController(2)
    }
    
    // après
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! ItemViewController
        
        if itemController.itemIndex+1 < imageArray.count {
            return getItemController(itemController.itemIndex + 1)
        }
        
        // return nil
        return getItemController(0)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return imageArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func currentControllerIndex() -> Int {
        let pageItemController = self.currentControllerIndex()
        
        if let controller = pageItemController as? ItemViewController {
            return controller.itemIndex
        }
        
        return -1
    }
    
    func currentController() -> UIViewController? {
        if (self.pageViewController?.viewControllers?.count)! > 0 {
            return self.pageViewController?.viewControllers![0]
        }
        
        return nil
    }
    
    func getItemController(_ itemIndex: Int) -> ItemViewController? {
        
        if itemIndex < imageArray.count {
            let pageItemController = self.storyboard?.instantiateViewController(withIdentifier: "ItemController") as! ItemViewController
            
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = imageArray[itemIndex]
            
            return pageItemController
        }
        
        return nil
    }

}
