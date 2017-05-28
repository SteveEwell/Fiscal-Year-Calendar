//
//  CWDaysHeaderView.swift
//  Fiscal Year Calculator
//
//  Created by Stephen Ewell on 4/10/16.
//  Copyright © 2016 Stephen Ewell. All rights reserved.
//

import UIKit

class CWDaysHeaderView : UIView {
    
    var blurTintColor: UIColor! {
        set {
            toolbar.barTintColor = blurTintColor
        }
        get {
            return toolbar.barTintColor
        }
    }
    
    lazy var toolbar:UIToolbar = {
        self.clipsToBounds = false
        
        let toolbar = UIToolbar(frame: self.bounds)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(toolbar, at: 0)
        let views = ["toolbar": toolbar]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[toolbar]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[toolbar]|", options: [], metrics: nil, views: views))
        let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        let blah = toolbar.frame.size.width / 17
        if (UIScreen.main.traitCollection.horizontalSizeClass == .compact) {
            negativeSpace.width = 0 - (toolbar.frame.size.width / 17) + (toolbar.frame.size.width / 17) * 0.4
        } else {
            negativeSpace.width = 0 - (toolbar.frame.size.width / 17)
        }
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let monday = self.createBarButtonItemLabel("MON", labelWidth: 40)
        let tuesday = self.createBarButtonItemLabel("TUE", labelWidth: 40)
        let wednesday = self.createBarButtonItemLabel("WED", labelWidth: 40)
        let thursday = self.createBarButtonItemLabel("THU", labelWidth: 40)
        let friday = self.createBarButtonItemLabel("FRI", labelWidth: 40)
        let saturday = self.createBarButtonItemLabel("SAT", labelWidth: 40)
        let sunday = self.createBarButtonItemLabel("SUN", labelWidth: 40)
        
        toolbar.setItems([negativeSpace, flexSpace, monday, flexSpace, tuesday, flexSpace, wednesday, flexSpace, thursday, flexSpace, friday, flexSpace, saturday, flexSpace, sunday, flexSpace,negativeSpace ], animated: false)
        
        return toolbar
    }()
    
    private func createBarButtonItemLabel(_ labelText:String, labelWidth:CGFloat) -> UIBarButtonItem {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 44))
        let button = UIBarButtonItem(customView: label)
        label.text = labelText
        if (UIScreen.main.traitCollection.horizontalSizeClass == .compact) {
            label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        }
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        
        return button
    }
}
