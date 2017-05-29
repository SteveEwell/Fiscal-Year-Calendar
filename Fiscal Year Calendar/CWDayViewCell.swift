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
    
    func setUpTopLineView(date: CWFiscalDate) {
        // http://uicolor.xyz/#/hex-to-ui
        // Helpful site for float values from a hex value.
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date.storedDate)
        let month = components.month
        let monthColor: [UIColor] = [
            UIColor.gray,
            UIColor(red: 0, green: 0.263, blue: 0.345, alpha: 1),
            UIColor(red: 0.122, green: 0.541, blue: 0.439, alpha: 1),
            UIColor(red: 0.745, green: 0.859, blue: 0.224, alpha: 1),
            UIColor(red: 1, green: 0.882, blue: 0.102, alpha: 1),
            UIColor(red: 0.992, green: 0.455, blue: 0, alpha: 1),
            UIColor(red: 0.18, green: 0.035, blue: 0.153, alpha: 1),
            UIColor(red: 1, green: 0.549, blue: 0, alpha: 1),
            UIColor(red: 0.851, green: 0, blue: 0, alpha: 1),
            UIColor(red: 1, green: 0.176, blue: 0, alpha: 1),
            UIColor(red: 0.016, green: 0.459, blue: 0.435, alpha: 1),
            UIColor(red: 0.812, green: 0.29, blue: 0.188, alpha: 1),
            UIColor(red: 0.569, green: 0.067, blue: 0.275, alpha: 1),
            ]
        
        self.topView.backgroundColor = monthColor[month!]
    }
    
    func drawCircle() {
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
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: width ,y: radius), radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 0
        self.holidayView.layer.addSublayer(shapeLayer)
    }
    
    func clearCircles() {
        self.holidayView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}
