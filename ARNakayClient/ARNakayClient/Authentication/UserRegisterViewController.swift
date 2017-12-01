//
//  UserRegisterViewController.swift
//  ARKitClient
//
//  Created by NelliStudio on 26/09/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class UserRegisterViewController: BaseViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    

    // MARK: - Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBarBackgroundColor()
        moveViewWithKeyboard()
        hideKeyboardWhenTappedAround()
        initView()
    }
    
    // MARK: - Appear view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Hide keyboard whe user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Next/Done | Hide keyboard when user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case self.userFirstNameTextField:
                self.userNameTextField.becomeFirstResponder()
                break
            case self.userNameTextField:
                self.userPhoneTextField.becomeFirstResponder()
                break
            case self.userPasswordTextField:
                self.userRepeatPasswordTextField.becomeFirstResponder()
                break
            case self.userRepeatPasswordTextField:
                self.register()
                //self.userRepeatPasswordTextField.resignFirstResponder()
                break
            default:
                break
        }
        return true
    }
    
    // MARK: - Block keyboard when character length of textField is 10 or 25
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        switch textField {
        case self.userFirstNameTextField, self.userNameTextField, self.userPasswordTextField:
                return newLength <= 25
            case self.userPhoneTextField, self.userRepeatPasswordTextField:
                return newLength <= 10
            default:
                break
        }
        return true
    }
    
    // MARK: - Move view with Keyboard
    func moveViewWithKeyboard() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        // move view 150 points upward
        self.view.frame.origin.y = -150
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        // move view to original position
        self.view.frame.origin.y = 0
        // self.view.frame.origin.y += 150
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
        
        // hide scroll view indicator
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // responsive btn text
        adjustButtonText(button: btnRegister)
        adjustButtonText(button: btnCancel)
        
        // image avatar : init event
        userAvatar.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userAvatar.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Make image circular
    func circularRoundedImage(image: UIImageView) -> Void {
        //let image = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: - Check when user's click on image
    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Profile picture", message: "Please take or choose your avatar.", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction!) in
            self.pickPhoto()
        }
        let galleryAction = UIAlertAction(title: "Caméra", style: .default) { (action:UIAlertAction!) in
            self.takePhoto()
        }
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func pickPhoto() -> Void {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func takePhoto() -> Void {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Getting the photo you just took
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userAvatar.contentMode = .scaleAspectFit
            userAvatar.image = pickedImage
            self.circularRoundedImage(image: userAvatar)
        } else {
            showAlertMessage(title: "Profile picture", message: "An error has been found.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Register button
    @IBAction func onClickButtonRegister(_ sender: UIButton) {
        self.register()
    }
    
    func register() -> Void {
        // value
        let firstName = userFirstNameTextField.text!
        let name = userNameTextField.text!
        let phone = userPhoneTextField.text!
        let password = userPasswordTextField.text!
        let repeatPassword = userRepeatPasswordTextField.text!
        
        // check for empty fields
        if (firstName.isEmpty || phone.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
            showAlertMessage(title: "Inscription", message: "All fields are required except the 'Last Name' field.")
            return
        }
        
        // check if passwords match
        if(password != repeatPassword) {
            showAlertMessage(title: "Inscription", message: "Passwords do not match.")
            return
        }
        
        // call api
        apiUserRegister(userFirstName: firstName, userLastName: name, userPhone: phone, userPassword: password)
    }
    
    // MARK: - Cancel button
    @IBAction func onClickButtonCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
