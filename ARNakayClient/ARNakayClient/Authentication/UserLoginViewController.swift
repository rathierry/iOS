//
//  UserLoginViewController.swift
//  ARKitClient
//
//  Created by NelliStudio on 26/09/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class UserLoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var btnValidate: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    
    
    // load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBarBackgroundColor()
        initView()
    }
    
    // appear view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // hide keyboard whe user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // hide keyboard when user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case self.userPhoneTextField:
                self.userPasswordTextField.becomeFirstResponder()
                break
            case self.userPasswordTextField:
                self.view.endEditing(true)
                self.login()
                break
            default:
                break
        }
        return true
    }
    
    // block keyboard when character length of textField is 10 or 25
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        if textField == self.userPhoneTextField {
            return newLength <= 10
        } else if textField == self.userPasswordTextField {
            return newLength <= 25
        }
        return true
    }
    
    // MARK: - StatusBar Background
    func setStatusBarBackgroundColor() -> Void {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.black
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        }
    }
    
    // MARK: - Init view
    func initView() -> Void {
        adjustButtonText(button: btnValidate)
        adjustButtonText(button: btnAccount)
    }
    
    // MARK: - Validate login
    func login() -> Void {
        // value
        let phone: String = userPhoneTextField.text!
        let password: String = userPasswordTextField.text!
        
        // check for empty fields
        if (phone.isEmpty || password.isEmpty) {
            self.showAlertMessage(title: "Login", message: "All fiels are required.")
            return
        }
        
        // call api
        apiUserConnect(phone: phone, password: password)
    }
    
    @IBAction func onClickButtonValidate(_ sender: UIButton) {
        self.login()
    }
    
    @IBAction func onClickButtonAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: "loginToRegisterView", sender: self)
        // self.takeScreenShot()
    }
    
}
