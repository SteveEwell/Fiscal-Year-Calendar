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
