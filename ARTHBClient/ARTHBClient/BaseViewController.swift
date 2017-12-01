//
//  BaseViewController.swift
//  ARKitClient
//
//  Created by NelliStudio on 26/09/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // defined a constant
    // let scriptUrl = "http://192.168.137.116:8888/server/nakay/rest/arkit/"
    let scriptUrl = "https://stats.e-fanorona.com/publish/arkit/"
    let _timer : Double = 1
    
    // defined a variable
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var fetchedNillous = [NillousCL]()
    var nillousesCount: Int = 0
    var nillousID: Int? = nil
    var nillousImage: String = ""
    var nillousIndexObject: Int? = nil
    var nillousPositionX: Float? = nil
    var nillousPositionY: Float? = nil
    var nillousPositionZ: Float? = nil
    var nillousCameraX1: Float? = nil
    var nillousCameraY1: Float? = nil
    var nillousCameraZ1: Float? = nil
    var nillousCameraW1: Float? = nil
    var nillousCameraX2: Float? = nil
    var nillousCameraY2: Float? = nil
    var nillousCameraZ2: Float? = nil
    var nillousCameraW2: Float? = nil
    var nillousCameraX3: Float? = nil
    var nillousCameraY3: Float? = nil
    var nillousCameraZ3: Float? = nil
    var nillousCameraW3: Float? = nil
    var nillousCameraX4: Float? = nil
    var nillousCameraY4: Float? = nil
    var nillousCameraZ4: Float? = nil
    var nillousCameraW4: Float? = nil

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - didReceiveMemoryWarning()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Current View Controller
    func currentTopViewController() -> UIViewController {
        var topVC: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    // MARK: - Responsive Button Text
    func adjustButtonText(button: UIButton) -> Void {
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Trying to make a screenshot button that sends the screenshot to my camera roll
    func takeScreenShot() -> Void {
        LoadingIndicatorView.show("- Loading -")
        
        delay(time: _timer) {
            LoadingIndicatorView.hide()
            
            DispatchQueue.main.async {
                UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.main.scale)
                self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            }
        }
    }
    
    // MARK: - Display Alert
    func showAlertMessage(title: String, message: String) -> Void {
        // alert
        let alertController = UIAlertController(title: title, message: "\n\(message)", preferredStyle: .alert)
        
        // subView
        let subView = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subView.backgroundColor = UIColor(red: (230/255.0), green: (230/255.0), blue: (250/255.0), alpha: 1.0)
        // 255,240,245 | 230,230,250
        alertController.view.tintColor = UIColor.black
        
        // action
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        
        // context
        let currentTopVC: UIViewController? = self.currentTopViewController()
        currentTopVC?.present(alertController, animated: true, completion: {
            for textfield: UIView in alertController.textFields! {
                let container: UIView = textfield.superview!
                let effectView: UIView = container.superview!.subviews[0]
                container.backgroundColor = UIColor.clear
                effectView.removeFromSuperview()
            }
        })
    }
    
    // MARK: - API GET using params
    func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars:[String] = []
        
        for (k,value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
    
    // MARK: - API POST using body
    func buildBodyString(fromDictionary parameters: [String:String]) -> String {
        var urlVars:[String] = []
        
        for (k,value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        
        return urlVars.isEmpty ? "" : urlVars.joined(separator: "&")
    }
    
    // MARK: - Function to run code after a delay
    func delay(time: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            closure()
        }
    }
    
    // MARK: - Nillous Count
    func nillousCount(array: Array<Any>) -> Bool {
        if array.count < 0 {
            self.showAlertMessage(title: "Nillous", message: "No objects found in database.")
            return false
        }
        return true
    }
}
