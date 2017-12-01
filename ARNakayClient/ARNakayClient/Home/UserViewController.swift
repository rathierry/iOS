//
//  UserViewController.swift
//  ARKitClient
//
//  Created by NelliStudio on 24/10/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var userTableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate
        userTableView.delegate = self
        userTableView.dataSource = self
        
        // init view
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        addSlideMenuButton()
        self.title = "User"
        
        // set up the refresh control
        let attr = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh all data", attributes:attr)
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.userTableView?.addSubview(refreshControl)
        
        // api, searchBar
        apiGetAllUserInfo()
        searchBar()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func refresh(_ sender: UIRefreshControl?) {
        if fetchedUser.count > 0 {
            self.userTableView.reloadData()
            sender?.endRefreshing()
        } else {
            sender?.endRefreshing()
        }
        // self.apiGetAllUserInfo()
    }
    
    func searchBar() -> Void {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.white
        searchBar.scopeButtonTitles = ["ID", "Email"]
        self.userTableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            apiGetAllUserInfo()
        } else {
            if searchBar.selectedScopeButtonIndex == 0 {
                fetchedUser = fetchedUser.filter({ (user) -> Bool in
                    return user.firstName.lowercased().contains(searchText.lowercased())
                })
            } else {
                fetchedUser = fetchedUser.filter({ (user) -> Bool in
                    return user.email.lowercased().contains(searchText.lowercased())
                })
            }
        }
        self.userTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedUser.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = (fetchedUser[indexPath.row].id as NSNumber).stringValue
        // cell?.textLabel?.text = fetchedUser[indexPath.row].firstName
        cell?.detailTextLabel?.text = fetchedUser[indexPath.row].email
        cell?.imageView?.image = UIImage(named: "account_filled")
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n--- UserViewController | tableView ---\n")
        
        print("You selected cell #", indexPath.row, "\n")
        
        // getting the index path of selected row
        let itemPath = tableView.indexPathForSelectedRow

        // getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: itemPath!)! as UITableViewCell

        // getting the text of that cell
        let currentItem = currentCell.detailTextLabel!.text

        let message: String = "You selected item #\(indexPath.row) (\(currentItem!))"
        print("message: ", message, "\n")
        self.showAlertMessage(title: "Item", message: message)
        
        currentCell.backgroundColor = UIColor.clear
    }
    
    // optional public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("You deselected cell #", indexPath.row, "\n")
    }
    
    // MARK: - API User Fetch All
    internal func apiGetAllUserInfo() -> Void {
        
        print("\n--- UserViewController | apiGetAllUserInfo ---\n")
        
        fetchedUser = []
        
        // urlPath
        let urlPath = scriptUrl + "/api/getUserList"
        print("URLPath: ", urlPath, "\n")
        
        // request
        var request  = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "GET"
        
        // config
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        // task
        LoadingIndicatorView.show("- Loading -")
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                LoadingIndicatorView.hide()
                print("Error from server \n")
                self.showAlertMessage(title: "User", message: "Error from server")
                return
            } else {
                
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    print("fetchedData: ", fetchedData, "\n")
                    
                    for eachFetchedUser in fetchedData {
                        let eachUser = eachFetchedUser as! [String : Any]
                        
                        let id = eachUser["id"] as! Int
                        let firstName = eachUser["firstName"] as? String ?? ""
                        let name = eachUser["name"] as? String ?? ""
                        let phone = eachUser["phone"] as? String ?? ""
                        let address = eachUser["address"] as? String ?? ""
                        let userName = eachUser["userName"] as? String ?? ""
                        let email = eachUser["email"] as? String ?? ""
                        let password = eachUser["password"] as? String ?? ""
                        
                        self.fetchedUser.append(UserCL(id: id, firstName: firstName, name: name, phone: phone, address: address, userName: userName, email: email, password: password))
                    }
                    
                    // tell refresh control it can stop showing up now
                    LoadingIndicatorView.hide()
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    
                    // reload data
                    self.userTableView.reloadData()
                    print("fetchedUser: ", self.fetchedUser, "\n")
                    
                } catch {
                    LoadingIndicatorView.hide()
                    print("Error Serializing Json \n")
                    self.showAlertMessage(title: "User", message: "Error serializing json")
                    return
                }
            }
        }
        task.resume()
    }

}
