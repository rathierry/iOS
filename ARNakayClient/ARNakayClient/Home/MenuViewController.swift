//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by NelliStudio on 27/10/2017.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var logOutView: UIView!
    
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---
        tblMenuOptions.tableFooterView = UIView()
        
        // view for logOut
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.logOutView.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions() {
        arrayMenuOptions.append(["title":"Home", "icon":"ic_menu_home"])
        arrayMenuOptions.append(["title":"ARKit", "icon":"ic_menu_nillous"])
        arrayMenuOptions.append(["title":"ARTicTacToe", "icon":"ic_menu_tictac"])
        arrayMenuOptions.append(["title":"QRCode", "icon":"ic_menu_qrcode"])
        arrayMenuOptions.append(["title":"User", "icon":"ic_menu_user"])
        
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!) {
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if (button == self.btnCloseMenuOverlay) {
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    // Mark: - LOGOUT
    // 3. this method is called when a tap is recognized
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.logOutUser()
    }
}
