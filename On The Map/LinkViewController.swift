//
//  LinkViewController.swift
//  On The Map
//
//  Created by Shruti Pawar on 11/04/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

// Delegate to update data in text field

protocol LinkViewControllerDelegate: class {
    
    func sendLink(linkViewController: LinkViewController, didSendLink link: String)
}


class LinkViewController: UIViewController, UIWebViewDelegate {
    
    // weak reference to delegate
    weak var delegate: LinkViewControllerDelegate?

    @IBOutlet weak var linkWebView: UIWebView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkWebView.delegate = self
        linkWebView.scalesPageToFit = true
        
        // if URL string is not provided, use google
        if urlString == nil  {
           urlString = "http://www.google.com"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Request
        let urlRequest =  NSURL(string: urlString!)
        let request = NSURLRequest(URL: urlRequest!)
        
        // Load request in webview
        linkWebView.loadRequest(request)
    }
    
    // Select link and invoke delegate method
    @IBAction func selectLinkforUserLocation(sender: UIBarButtonItem) {
        
        if let delegate = delegate {
            let currentURLString = linkWebView.request!.URL!.absoluteString
             delegate.sendLink(self, didSendLink: currentURLString!)
        }
        
    }
   
    // Do nothing on cancel
    @IBAction func cancelRequest(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:-  Webview Delegate Methods
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        println("Sorry. Content cannnot be loaded at this time. \(error)")
    }
    

}
