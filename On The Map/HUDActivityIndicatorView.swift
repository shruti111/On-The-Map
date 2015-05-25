//
//  HUDActivityIndicatorView.swift
//  On The Map
//
//  Created by Shruti Pawar on 17/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

/* This class creates custom Activity Indicator using Activity Indicator, Core Drawing and View Animations */
/* This Custom UI Control is used to show Activity Indicator with text */

class HUDActivityIndicatorView: UIView {

    // Activity Text
    var text = "Signing..."
   
    // Class function to return View
    
    class func hudActivityIndicatorInView(view: UIView, animated: Bool) -> HUDActivityIndicatorView {
        
        let hudView = HUDActivityIndicatorView(frame: view.bounds)
        hudView.opaque = false
        
        // Change alpha of parent p=view
        view.alpha = 0.7
        
        view.addSubview(hudView)
        
        // Disable user interaction on parent view
        view.userInteractionEnabled = false
      
        // Show with animation
        hudView.showAnimated(animated)
        return hudView
    }
    
    // View animation to change the alpha property with duration to get animations effect
    func showAnimated(animated: Bool) {
        if animated {
            alpha = 0
            
            transform = CGAffineTransformMakeScale(1.3, 1.3)
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7,initialSpringVelocity: 0.5, options: UIViewAnimationOptions(0), animations: {
                self.alpha = 1
                self.transform = CGAffineTransformIdentity
                },
                completion: nil)
        }
    }
    
    // Hide view
    
    func hideHudActivityIndicatorView(view: UIView) {
        
        // Enable user interaction and reset alpha
        view.userInteractionEnabled = true
        
        alpha = 0
        hidden = true
        view.alpha = 1.0
        
        // remove from super view
        
        self.removeFromSuperview()
       
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        // Drawing code
        
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        // Create a rectangle for controls
        
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        // activity indicator
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        let xcoordinate = center.x - round(activityIndicatorView.frame.size.width / 2)
        let ycoordiante = center.y - round(activityIndicatorView.frame.size.height / 2) - boxHeight / 8
        
        let newFrame = CGRect(x: xcoordinate, y: ycoordiante, width: activityIndicatorView.frame.size.width, height: activityIndicatorView.frame.size.height)
        
        activityIndicatorView.frame = newFrame
        
        activityIndicatorView.startAnimating()
        
        self.addSubview(activityIndicatorView)
        
        // Set Text attributes
        let attribs = [ NSFontAttributeName: UIFont.systemFontOfSize(16.0),
            NSForegroundColorAttributeName: UIColor.whiteColor() ]
        
        let textSize = text.sizeWithAttributes(attribs)
        
        // Draw Text
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)
        
        text.drawAtPoint(textPoint, withAttributes: attribs)
    }

}
    


