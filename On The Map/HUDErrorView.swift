//
//  HUDErrorView.swift
//  On The Map
//
//  Created by Shruti Pawar on 18/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import Foundation

/* This class creates custom Error view  using Core Drawing and View Animations, This view dismiss automatically after 5 seconds */
/* This Custom UI Control is used to show Activity Indicator with text */

class HUDErrorView: UIView {

    // Set padding for the UI Controls
    
    let HORRIZONTAL_PADDING : CGFloat = 18.0
    let VERTICAL_PADDING: CGFloat = 14.0
    let innerMargin: CGFloat = 25.0
    
    // Set title string
    var title: String? {
        didSet {
            titleLabel!.text = title
            setNeedsLayout()
        }
    }
    
    // Set message string
    var message: String? {
        didSet {
            messageLabel!.text = message
            setNeedsLayout()
        }
    }
    
    // Title label
    var titleLabel : UILabel?
    
    // Message label
    var messageLabel : UILabel?
    
    // Tap to dismiss view
    var tapGestureRecogniser : UITapGestureRecognizer?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Add subviews
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure the layout of the view
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.alpha = 0
        
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.1).CGColor
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 30.0
        
        // Set title label
        titleLabel = UILabel(frame: CGRect(x: HORRIZONTAL_PADDING, y: VERTICAL_PADDING, width: 0, height: 0))
        titleLabel!.backgroundColor = UIColor.clearColor()
        titleLabel!.textColor = UIColor.whiteColor()
        titleLabel!.textAlignment = NSTextAlignment.Center
        titleLabel!.font = UIFont.boldSystemFontOfSize(14)
        titleLabel!.numberOfLines = 0
        titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel!.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleWidth)
        
        addSubview(titleLabel!)
        
        // Set message label
        messageLabel = UILabel(frame: CGRect(x: HORRIZONTAL_PADDING, y: 0, width: 0, height: 0))
        messageLabel!.backgroundColor = UIColor.clearColor()
        messageLabel!.textColor = UIColor.whiteColor()
        messageLabel!.textAlignment = NSTextAlignment.Center
        messageLabel!.font = UIFont.systemFontOfSize(12)
        messageLabel!.numberOfLines = 0
        messageLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        messageLabel!.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleWidth)
        
        addSubview(messageLabel!)
        
        // add gesture
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: Selector("hide"))
        addGestureRecognizer(tapGestureRecogniser!)
    }


    // Set subviews based on paddings, margins and insets
    
    override func layoutSubviews() {
        var maxWidth: CGFloat = self.superview!.bounds.size.width - 40.0 - (HORRIZONTAL_PADDING * 2);
        var totalLabelWidth: CGFloat = 0
        var totaHeight: CGFloat = 0
        
        let screenRect = self.superview!.bounds
        
        var constrainedSize: CGSize = CGSizeZero
        constrainedSize.width = maxWidth
        constrainedSize.height = CGFloat(MAXFLOAT)
        
        var titleSize: CGSize = (self.title! as NSString).boundingRectWithSize(constrainedSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : self.titleLabel!.font], context: nil).size
        
        var messageSize: CGSize = (self.message! as NSString).boundingRectWithSize(constrainedSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : self.messageLabel!.font], context: nil).size
        
        totaHeight = titleSize.height + messageSize.height  + floor(VERTICAL_PADDING * 2.5)
        
        if (titleSize.width == maxWidth || messageSize.width == maxWidth) {
            totalLabelWidth = maxWidth;
            
        } else if (messageSize.width > titleSize.width) {
            totalLabelWidth = messageSize.width;
            
        } else {
            totalLabelWidth = titleSize.width;
        }
        
        var totalWidth: CGFloat = totalLabelWidth + (HORRIZONTAL_PADDING * 2);
        
        var xPosition: CGFloat = floor((screenRect.size.width / 2) - (totalWidth / 2));
        
        var yPosition: CGFloat = screenRect.size.height - ceil(totaHeight) - self.innerMargin - 10   // set bottom Margin

        // Set frame for each view
        
       self.frame = CGRectMake(xPosition, yPosition, ceil(totalWidth), ceil(totaHeight))
        
        self.titleLabel!.frame = CGRectMake(self.titleLabel!.frame.origin.x, ceil(self.titleLabel!.frame.origin.y), ceil(totalLabelWidth), ceil(titleSize.height))
                
            self.messageLabel!.frame = CGRectMake(self.messageLabel!.frame.origin.x, ceil(titleSize.height) + floor(VERTICAL_PADDING * 1.5), ceil(totalLabelWidth), ceil(messageSize.height));
    }
    
    // Show view with animations
    func showInView(view: UIView) {
        view.addSubview(self)
        
        UIView.animateWithDuration(2, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.alpha = 1.0
            }, completion: { finished in
                self.hide()
                
        })
        
    }
    
    //Hide view with animations (after 5 t)
    func hide() {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(4 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            
             NSObject.cancelPreviousPerformRequestsWithTarget(self)
            
            UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
                self.alpha = 0
                }, completion: { _ in
                    self.removeFromSuperview()
            })
        })
    }
   
}
