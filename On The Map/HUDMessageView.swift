//
//  HUDConnectioErrorView.swift
//  On The Map
//
//  Created by Shruti Pawar on 18/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

/* This class creates custom Message view using Label, Button, Core Drawing and View Animations */
/* This Custom UI Control is used to show error messages and validation messages */

class HUDMessageView: UIView {

    // Set message Text
    var messageText : NSString = ""
    
    //Set title text
    var titleText: NSString = ""
    
    //Set super view
    var superView: UIView?
    
    // return message view
    
    class func hudMessageInView(view: UIView, animated: Bool) -> HUDMessageView {

        let hudView = HUDMessageView(frame: view.bounds)
        hudView.opaque = false
        hudView.superView = view
        
        // Change the superview's opacity
        view.alpha = 0.9
        view.addSubview(hudView)

        // Disable user interactions for all children views
        
        if let subViews = hudView.superView!.subviews as? [UIView] {
        
        for subView in subViews {
            
            if let messageView = subView as? HUDMessageView {
                messageView.userInteractionEnabled = true
            } else {
                subView.userInteractionEnabled = false
            }
        }
        }
        
        hudView.showAnimated(animated)
        return hudView
    }
    
    // Change view properties with animations
    func showAnimated(animated: Bool) {
        if animated {
          
            alpha = 0
            
            transform = CGAffineTransformMakeScale(1.3, 1.3)
            
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7,initialSpringVelocity: 0.5, options: UIViewAnimationOptions(0), animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransformIdentity
                },
                completion: nil)
        }
    }
    
    // Hide view on button click
    
    func pressed() {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
       
        if let subViews = self.superView!.subviews as? [UIView] {
            
            for subView in subViews {
                
                subView.userInteractionEnabled = true
                
            }
        }

        UIView.animateWithDuration(0.5, delay: 0 , options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
                self.superView!.alpha = 1.0
                
        })
    }
    
    // Draw user controls on this view
    
    override func drawRect(rect: CGRect) {
       
        let boxWidth: CGFloat = bounds.size.width - 32
        let boxHeight: CGFloat = 180
        
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
       
        UIColor(white: 1, alpha: 0.9).setFill()
        
        roundedRect.fill()
        
        // Draw imageview and set the image
        
        if let image = UIImage(named: "SadFace") {
            
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width / 2),
                y: boxRect.origin.y + 10)
            
            image.drawAtPoint(imagePoint)
           
            // Set title attributes and set title
            let titleattribs = [ NSFontAttributeName: UIFont.systemFontOfSize(18.0),
                NSForegroundColorAttributeName: UIColor.blackColor() ]
            
            let titleTextSize = titleText.sizeWithAttributes(titleattribs)
            let titleTextPoint = CGPoint(
                x: center.x - round(titleTextSize.width / 2),
                y: imagePoint.y + image.size.height + 10 )
            
            titleText.drawAtPoint(titleTextPoint, withAttributes: titleattribs)
            
            // Set message text attributes and draw message label
            
            let attribs = [ NSFontAttributeName: UIFont.systemFontOfSize(14.0),
                NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7) ]
            
            let textSize = self.messageText.boundingRectWithSize(boxRect.size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attribs, context: nil).size
            
            let textPoint = CGPoint(
                x: boxRect.origin.x + 10,
                y: titleTextPoint.y + titleTextSize.height + 10)
            
            
           let messageLabel = UILabel() //(frame: CGRect(x: 10, y: 0, width: 0, height: 0))
            messageLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont.systemFontOfSize(14)
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            messageLabel.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleWidth)

           messageLabel.frame = CGRectMake(boxRect.origin.x + 10, titleTextPoint.y + titleTextSize.height + 10, ceil(textSize.width), ceil(textSize.height));
            messageLabel.text = messageText as String
            
           addSubview(messageLabel)
            
            // Draw button
            
            let okButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            
            okButton.setTitle("OK", forState: .Normal)
            okButton.titleLabel!.font = UIFont.systemFontOfSize(18)
            okButton.setTitleColor(UIColor(red: 206/255, green: 34/255, blue: 67/255, alpha: 1.0), forState: .Normal)
           okButton.layer.cornerRadius = 5
            okButton.layer.borderWidth = 0.5
            okButton.layer.borderColor = UIColor(red: 206/255, green: 34/255, blue: 67/255, alpha: 1.0).CGColor
            
            let buttonFrame  = CGRectMake(center.x - 25,
                messageLabel.frame.size.height + messageLabel.frame.origin.y + 10,
                50 , 30)
            okButton.frame = buttonFrame
            okButton.addTarget(self, action: "pressed", forControlEvents: .TouchUpInside)
            
            addSubview(okButton)
        }
    
    }




}
