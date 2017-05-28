//
//  CWFiscalDateFormatter.swift
//  Fiscal Year Calculator
//
//  Created by Stephen Ewell on 12/12/15.
//  Copyright © 2015 Stephen Ewell. All rights reserved.
//

import Foundation

class CWFiscalDateFormatter: DateFormatter {
    
    func fiscalDateFromString(_ string:String) -> CWFiscalDate {
        let fiscalDate = CWFiscalDate(fromDate: self.date(from: string)!)
        
        return fiscalDate
    }
    
    func stringFromFiscalDate(_ fiscalDate: CWFiscalDate) -> String {
        let year = fiscalDate.fiscalYear
        let period = fiscalDate.period
        let week = fiscalDate.week
        let string = "FY\(year)P\(period)W\(week)"
        
        return string
    }
}
