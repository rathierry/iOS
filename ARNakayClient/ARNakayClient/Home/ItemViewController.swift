//
//  ItemViewController.swift
//  ARKitClient
//
//  Created by NelliStudio on 30/10/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }

    @IBOutlet weak var contentImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentImageView.image = UIImage(named: imageName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
