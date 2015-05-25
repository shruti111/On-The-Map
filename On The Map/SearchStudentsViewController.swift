//
//  SearchStudentsViewController.swift
//  On The Map
//
//  Created by Shruti Pawar on 19/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


/* Parse API searches data by providing exact alphabets search , so currently data is searched by case sensitive inputs */

class SearchStudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Proeprties and outlets
    var refreshButton : UIBarButtonItem?
    var search = [String: String]()
    private var searchResults: [StudentInformation]?
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var studentSearchbar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    //MARK:- Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search bar delegate
        studentSearchbar.delegate = self
        studentSearchbar.becomeFirstResponder()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        tapGestureRecognizer?.numberOfTapsRequired = 1
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        self.view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    func configureUI() {
        
        // Disable refresh button
        let rightbarButtons = self.tabBarController!.navigationItem.rightBarButtonItems as! [UIBarButtonItem]
        refreshButton =  rightbarButtons[0]
        refreshButton!.enabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        refreshButton!.enabled = true
        self.view.removeGestureRecognizer(tapGestureRecognizer!)
    }
    
    func dismissKeyboard(gestureRecognizer: UITapGestureRecognizer) {

        self.view.endEditing(true)
    }

    // Segment changed event
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        // Update search bar text based on selected segment
        
        if segmentedControl.selectedSegmentIndex == 0 {
             studentSearchbar.placeholder = "Search Students By First Name"
        } else if segmentedControl.selectedSegmentIndex == 1 {
            studentSearchbar.placeholder = "Search Student By Last Name"
        } else if segmentedControl.selectedSegmentIndex == 2 {
             studentSearchbar.placeholder = "Search Students By Location"
        } else {
             studentSearchbar.placeholder = "Search Students By Udacity Id"
        }
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults != nil ? (searchResults!.count == 0 ? 1 : searchResults!.count) : 0
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // If no data is found, show NOResult cell
            if searchResults!.count == 0 {
               let cell = tableView.dequeueReusableCellWithIdentifier("NoResultTableViewCell", forIndexPath: indexPath) as! UITableViewCell
                return cell
            } else {
               
                // Show Search Cell if data is there
                let cell = tableView.dequeueReusableCellWithIdentifier("searchStudentTableViewCell", forIndexPath: indexPath) as! SearchTableViewCell
                
                let studentLocation = searchResults![indexPath.row]
                cell.nameLabel.text = "\(studentLocation.firstName!) \(studentLocation.lastName!)"
                cell.locationLabel.text = studentLocation.mapString
                cell.visitButton.tag = indexPath.row
                
                return cell
        }       
    }
    
    /* visit button click event, when button is clicked navigate to user's URL */
    
    @IBAction func visitURL(sender: UIButton) {
        
        let studentLocation = searchResults![sender.tag]
        
        if let mediaURL = studentLocation.mediaURL {
            if let url = NSURL(string:mediaURL) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

}

extension SearchStudentsViewController: UISearchBarDelegate {
    
    // Search operation when search button is clicked
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearch()
    }
    
    // Search students locations based on First Name, Last name, Location and Udacity Key
    
    func performSearch() {
        
        var searchText = studentSearchbar.text
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            search = [ Client.JSONResponseKeys.FirstName  : searchText ]
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            
             search = [ Client.JSONResponseKeys.LastName  : searchText ]
            
        } else if segmentedControl.selectedSegmentIndex == 2 {
            
           search = [ Client.JSONResponseKeys.MapString  : searchText ]
            
        } else {
            
             search = [ Client.JSONResponseKeys.UniqueKey  : searchText ]
        }
        
        let hudView = HUDActivityIndicatorView.hudActivityIndicatorInView(view, animated: true)
        hudView.text = "Loading..."
        
        // Peform Search query on Parse
        
        Client.sharedInstance().searchLocations(search, completionHandler: {
            searchResults, error in
            
        dispatch_async(dispatch_get_main_queue()) {
            
            hudView.hideHudActivityIndicatorView(self.view)
            
            self.studentSearchbar.resignFirstResponder()
            
            // Show network error
            
            if let error = error {
                if error.domain == "OnTheMap NetworkError" {
                    self.showNetworkError()
                    
                } else {
                    
                    let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
                    hudMessageView.titleText = "Oops..."
                    hudMessageView.messageText = error.localizedDescription
                }
            } else {
                
                    // Show data in tableview
                    if let studentsData = searchResults {
                        self.searchResults = studentsData
                        self.searchResultsTableView.reloadData()
                       
                    }
                
            }
        }
        })
    }
    
    // Utility method to show Network erro
    
    func showNetworkError() {
        
        var errorView = HUDErrorView(frame: CGRectZero)
        errorView.title = "Could not connect"
        errorView.message = "Please check your internet connection and try again."
        errorView.showInView(self.view)
        
    }
}
