//
//  ClassExtensions.swift
//  Fiscal Year Calendar
//
//  Created by Stephen Ewell on 5/20/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import Foundation

extension CWFiscalDate {
    var fraction: Float {
        if (self.year > 2000 && Int(self.year % 6) == 1) && self.period == 13 {
            return Float(self.week) / 5.0
        } else {
            return Float(self.week) / 4.0
        }
    }
}
