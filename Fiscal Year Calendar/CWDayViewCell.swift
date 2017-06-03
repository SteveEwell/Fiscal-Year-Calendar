//
//  CWDayViewCell.swift
//  Fiscal Year Calculator
//
//  Created by Stephen Ewell on 2/14/16.
//  Copyright © 2016 Stephen Ewell. All rights reserved.
//

import UIKit

class CWDayViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var holidayView: UIView!
    var holiday: CWHoliday?
    
    func setUpTopLineView(date: CWFiscalDate) {
        // http://uicolor.xyz/#/hex-to-ui
        // Helpful site for float values from a hex value.
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date.storedDate)
        let month = components.month
        let monthColor: [UIColor] = [
            UIColor.gray,
            UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0),
            UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0),
            UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0),
            UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0),
            UIColor(red:0.91, green:0.12, blue:0.39, alpha:1.0),
            UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0),
            UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0),
            UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0),
            UIColor(red:0.55, green:0.76, blue:0.29, alpha:1.0),
            UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0),
            UIColor(red:1.00, green:0.34, blue:0.13, alpha:1.0),
            UIColor(red:0.01, green:0.66, blue:0.96, alpha:1.0),
            ]
        
        self.topView.backgroundColor = monthColor[month!]
    }
    
    func drawCircleHoliday() {
        var width: CGFloat = 0.0
        var radius: CGFloat = 0.0
        if (Display.displayType == .iphoneMed) {
            width = (self.holidayView.bounds.size.width / 2)
            radius = 2
        } else if (Display.displayType == .iphoneLarge) {
            width = (self.holidayView.bounds.size.width / 2)
            radius = 2
        } else if (Display.displayType == .iphoneLargePlus) {
            width = (self.holidayView.bounds.size.width / 2)
            radius = 2
        } else if (Display.displayType == .ipadMed) {
            width = (self.holidayView.bounds.size.width / 2)
            radius = 3
        } else {
            width = (self.holidayView.bounds.size.width / 2)
            radius = 2
        }
        
        var circleColor = UIColor.red.cgColor
        
        if let hol = self.holiday {
            if hol.open {
                circleColor = UIColor.black.cgColor
            } else {
                circleColor = UIColor.red.cgColor
            }
        }
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: width ,y: radius), radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = circleColor
        shapeLayer.strokeColor = circleColor
        shapeLayer.lineWidth = 0
        self.holidayView.layer.addSublayer(shapeLayer)
    }
    
    func clearCircles() {
        self.holidayView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}
