//
//  SplashController.swift
//  ARKitExample
//
//  Created by NelliStudio on 25/09/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    // load view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        
        // launch progress view
        startProgressView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    // can hide the status bar in any or all of your view controllers just by adding this code:
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // start progress
    func startProgressView() -> Void {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {(timer: Timer) in
            self.progressView.setProgress(self.progressView.progress + 0.1, animated: true)
            if self.progressView.progress >= 1 {
                timer.invalidate()
                self.checkCurrentUser()
            }
        }
        timer.fire()
    }
    
    // check current user
    func checkCurrentUser() -> Void {
        
        if self.getCurrentUser().count == 0 {
            self.performSegue(withIdentifier: "splashToLoginView", sender: self)
        } else {
            self.performSegue(withIdentifier: "splashToMainView", sender: self)
        }
    }

}
