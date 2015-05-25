//
//  LocationsTableViewController.swift
//  On The Map
//
//  Created by Shruti Pawar on 15/04/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    var didRefreshData : Bool = false {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        // Customize table view
        self.tabBarController!.navigationController?.edgesForExtendedLayout = UIRectEdge.None
        
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return Client.sharedInstance().studentLocations != nil ? Client.sharedInstance().studentLocations!.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Show each student data in table view row with student's first name and last name
        let cell = tableView.dequeueReusableCellWithIdentifier("studentLocaitonCell", forIndexPath: indexPath) as! UITableViewCell

        let studentLocation = Client.sharedInstance().studentLocations![indexPath.row]
        
        let firstName = studentLocation.firstName != nil ? studentLocation.firstName! : ""
        let lastName = studentLocation.lastName != nil ? studentLocation.lastName! : ""
        cell.textLabel?.text = "\(firstName) \(lastName)"
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Open the student's URL when row is selected
        
        let studentLocation = Client.sharedInstance().studentLocations![indexPath.row]
        
        if let mediaURL = studentLocation.mediaURL {
            if let url = NSURL(string:mediaURL) {
        UIApplication.sharedApplication().openURL(url)
            }
        }
        
    }
   
}
