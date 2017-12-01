//
//  BaseViewController.swift
//  ARKitClient
//
//  Created by NelliStudio on 26/09/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    // defined a constant
    let scriptUrl = "http://192.168.137.116:8888/server/nakay/rest/arkit/"
    let _timer : Double = 1
    
    // defined a variable
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var fetchedUser = [UserCL]()
    var fetchedNillous = [NillousCL]()
    var nillousesCount: Int = 0
    var userID: Int? = nil
    var userFIRSTNAME: String = ""
    var userLASTNAME: String = ""
    var userPHONE: String = ""
    var userADDRESS: String = ""
    var userNAME: String = ""
    var userEMAIL: String = ""
    var userPASSWORD: String = ""
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
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("\n--- BaseViewController | slideMenuItemSelectedAtIndex ---\n")
        print("View Controller is : \(topViewController) \n", terminator: "")
        
        switch (index) {
            case 0:
                print("\n--- BaseViewController | slideMenuItemSelectedAtIndex ---\n")
                print("Home\n", terminator: "")
                self.openViewControllerBasedOnIdentifier("Home")
                break
            
            case 1:
                print("\n--- BaseViewController | slideMenuItemSelectedAtIndex ---\n")
                print("Nillous\n", terminator: "")
                self.openViewControllerBasedOnIdentifier("ARkitVC")
                break
            
            case 2:
                print("\n--- BaseViewController | slideMenuItemSelectedAtIndex ---\n")
                print("ARTicTacToe\n", terminator: "")
                self.openViewControllerBasedOnIdentifier("ARTicTacToeVC")
                break
            
            case 3:
                print("\n--- BaseViewController | slideMenuItemSelectedAtIndex ---\n")
                print("QRCode\n", terminator: "")
                self.openViewControllerBasedOnIdentifier("QRCodeVC")
                break
            
            case 4:
                print("\n--- BaseViewController | slideMenuItemSelectedAtIndex ---\n")
                print("User\n", terminator: "")
                self.openViewControllerBasedOnIdentifier("UserVC")
                break
            
            default:
                print("\n--- BaseViewController | slideMenuItemSelectedAtIndex ---\n")
                print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!) {
            print("\n--- BaseViewController | openViewControllerBasedOnIdentifier ---\n")
            print("Same VC \n")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
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
    
    // MARK: - Save Current User
    func saveCurrentUser(user: User) -> Void {
        var myUser = [User]()
        let currentUser = User(id: user.id, firstName: user.firstName, name: user.name, phone: user.phone, address: user.address, userName: user.userName, email: user.email, password: user.password)
        myUser.append(currentUser)
        Storage.store(myUser, to: .documents, as: "arkit_current_user.json")
    }
    
    // MARK: - Get Current User
    func getCurrentUser() -> [User] {
        return Storage.retrieve("arkit_current_user.json", from: .documents)
    }
    
    // MARK: - Display Current User Info
    func showCurrentUserInfo() -> Void {
        LoadingIndicatorView.show("- Loading -")
        
        delay(time: _timer) {
            LoadingIndicatorView.hide()
            // retrieve data in store from the key
            DispatchQueue.main.async {
                for usr in self.getCurrentUser() {
                    let id: Int = usr.id!
                    let firstName: String = usr.firstName!
                    let name: String = usr.name!
                    let phone: String = usr.phone!
                    let address: String = usr.address!
                    let userName: String = usr.userName!
                    let email: String = usr.email!
                    
                    let info: String = "info: \(id) - " + firstName + " - " + name + " - " + phone + " - " + address + " - " + userName + " - " + email + " :)"
                    
                    self.showAlertMessage(title: "Current User", message: info)
                }
            }
        }
    }
    
    // MARK: - LogOut User
    func logOutUser() -> Void {
        // alert
        let alertController = UIAlertController(title: "Main", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        // subView
        let subView = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subView.backgroundColor = UIColor(red: (230/255.0), green: (230/255.0), blue: (250/255.0), alpha: 1.0)
        // 255,240,245 | 230,230,250
        alertController.view.tintColor = UIColor.black
        
        // action
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            LoadingIndicatorView.show("- Loading -")
            
            // clear current user
            Storage.clear(.documents)
            
            // wait
            self.delay(time: self._timer) {
                LoadingIndicatorView.hide()
                DispatchQueue.main.async {
                    // back to login view
                    self.performSegue(withIdentifier: "mainToLoginView", sender: self)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("\n--- BaseViewController | logOutUser ---\n")
            print("Cancel button tapped \n");
        }
        
        // add action
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        // present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    // MARK: - API User Connect
    func apiUserConnect(phone: String, password: String) -> Void {
        print("\n--- BaseViewController | apiUserConnect ---\n")
        
        // params
        let parameters = ["phone": "" + phone, "password": "" + password]
        print("parameters: ", parameters, "\n")
        
        // url
        var urlPath = scriptUrl + "/api/userConnect"
        urlPath += self.buildQueryString(fromDictionary: parameters)
        guard let requestURL = URL(string: urlPath) else {
            return
        }
        print("URLPath: ", urlPath, "\n")
        
        // urlRequest
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // session
        LoadingIndicatorView.show("- Loading -")
        self.delay(time: self._timer) {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // data
                if let data = data {
                    DispatchQueue.main.async { // Correct
                        do {
                            // serializing json from data
                            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            // check if is a good user
                            let userConnected: Bool = (json["userConnected"] as? Bool)!
                            if (!userConnected) {
                                LoadingIndicatorView.hide()
                                self.showAlertMessage(title: "Login", message: "Incorrect phone number and/or password.")
                                return
                            }
                            
                            // mapping data in struct
                            if let userJSON = json["user"] as? NSDictionary {
                                // set values
                                self.userID = userJSON["id"] as? Int
                                self.userFIRSTNAME = (userJSON["firstName"] as? String)!
                                self.userLASTNAME = (userJSON["name"] as? String)!
                                self.userPHONE = (userJSON["phone"] as? String)!
                                self.userADDRESS = (userJSON["address"] as? String)!
                                self.userNAME = (userJSON["userName"] as? String)!
                                self.userEMAIL = (userJSON["email"] as? String)!
                                self.userPASSWORD = (userJSON["password"] as? String)!
                             
                                // append values in struct
                                let user = User(id: self.userID, firstName: self.userFIRSTNAME, name: self.userLASTNAME, phone: self.userPHONE, address: self.userADDRESS, userName: self.userNAME, email: self.userEMAIL, password: self.userPASSWORD)
                             
                                // encoded userJSON
                                if let encoded = try? JSONEncoder().encode(user), let json = String(data: encoded, encoding: .utf8) {
                                    print("JSON (encoded): ", json, "\n")
                             
                                    // decode json
                                    let jsonData = json.data(using: .utf8)!
                                    if let decoded = try? JSONDecoder().decode(User.self, from: jsonData) {
                                        print("JSON (decoded): ", decoded, "\n")
                             
                                        // store user to disk
                                        self.saveCurrentUser(user: decoded)
                             
                                        // go to main view
                                        LoadingIndicatorView.hide()
                                        self.performSegue(withIdentifier: "loginToMainView", sender: self)
                                    }
                                }
                             }
                        } catch let jsonErr {
                            LoadingIndicatorView.hide()
                            print("Error serializing json: ", jsonErr, "\n")
                            self.showAlertMessage(title: "Login", message: "\nError serializing json : \(jsonErr.localizedDescription)")
                        }
                    }
                }
                LoadingIndicatorView.hide()
            }
            task.resume()
        }
    }
    
    // MARK: - API User Register
    func apiUserRegister(userFirstName: String, userLastName: String, userPhone: String, userPassword: String) -> Void {
        print("\n--- BaseViewController | apiUserRegister ---\n")
        
        // values
        let fakeAddress: String = "fake"
        let fakeUserName: String = "fake"
        let fakeEmail: String = userFirstName + "@fake.com"
        
        // parameters
        let parameters = ["firstName": "" + userFirstName, "name": "" + userLastName, "phone": "" + userPhone, "address": "" + fakeAddress, "userName": "" + fakeUserName, "email": "" + fakeEmail, "password": "" + userPassword]
        print("parameters: ", parameters, "\n")
        
        // urlPath
        let urlPath = scriptUrl + "/api/postNewUser"
        let myUrl = URL(string: urlPath)
        print("myURL: ", myUrl!, "\n")
        
        // request
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        // compose a query string
        let postString = "" + self.buildBodyString(fromDictionary: parameters)
        print("postString: ", postString, "\n")
        
        // body
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // session
        LoadingIndicatorView.show("- Loading -")
        self.delay(time: self._timer) {
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    LoadingIndicatorView.hide()
                    self.showAlertMessage(title: "Login", message: "Response error: \(String(describing: error))")
                    print("error: ", String(describing: error), "\n")
                    return
                }
                print("response: ", String(describing: response), "\n")

                // convert response sent from a server side script to a NSDictionary object:
                DispatchQueue.main.async {
                    do {
                        // serializing json from data
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        // parsing json
                        if let parseJSON = json {
                            print("parseJSON: ", parseJSON, "\n")
                            
                            // check if is a good user
                            let result: Bool = (parseJSON["result"] as? Bool)!
                            if (!result) {
                                LoadingIndicatorView.hide()
                                self.showAlertMessage(title: "Login", message: (parseJSON["message"] as! String))
                                return
                            }
                            
                            // mapping data in struct
                            if let userJSON = parseJSON["user"] as? NSDictionary {
                                // set values
                                self.userID = userJSON["id"] as? Int
                                self.userFIRSTNAME = (userJSON["firstName"] as? String)!
                                self.userLASTNAME = (userJSON["name"] as? String)!
                                self.userPHONE = (userJSON["phone"] as? String)!
                                self.userADDRESS = (userJSON["address"] as? String)!
                                self.userNAME = (userJSON["userName"] as? String)!
                                self.userEMAIL = (userJSON["email"] as? String)!
                                self.userPASSWORD = (userJSON["password"] as? String)!
                                
                                // append values in struct
                                let user = User(id: self.userID, firstName: self.userFIRSTNAME, name: self.userLASTNAME, phone: self.userPHONE, address: self.userADDRESS, userName: self.userNAME, email: self.userEMAIL, password: self.userPASSWORD)

                                // encoded userJSON
                                if let encoded = try? JSONEncoder().encode(user), let json = String(data: encoded, encoding: .utf8) {
                                    print("JSON (encoded): ", json, "\n")
                                    
                                    // decode json
                                    let jsonData = json.data(using: .utf8)!
                                    if let decoded = try? JSONDecoder().decode(User.self, from: jsonData) {
                                        print("JSON (decoded): ", decoded, "\n")
                                        
                                        // store user to disk
                                        self.saveCurrentUser(user: decoded)
                                        
                                        // go to main view
                                        LoadingIndicatorView.hide()
                                        self.performSegue(withIdentifier: "registerToMainView", sender: self)
                                    }
                                }
                            }
                        }
                    } catch let jsonErr {
                        LoadingIndicatorView.hide()
                        print("Error serializing json: ", jsonErr.localizedDescription, "\n")
                        self.showAlertMessage(title: "Login", message: "\nError serializing json : \(jsonErr.localizedDescription)")
                    }
                }
            }
            task.resume()
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
