//
//  CWFiscalDate.swift
//  Fiscal Year Calculator
//
//  Created by Stephen Ewell on 12/19/15.
//  Copyright © 2015 Stephen Ewell. All rights reserved.
//

import Foundation

protocol FiscalDate {
    var storedDate: Date {get}
    var fiscalYear: Int {get}
    var quarter: Int {get}
    var period: Int {get}
    var week: Int {get}
    var day: Int {get}
}

public struct CWFiscalDate: FiscalDate {
    var storedDate: Date
    var fiscalYear: Int
    var quarter: Int
    var period: Int
    var week: Int
    var day: Int
    var fraction: Float
    
    var yearAsString: String {
        return "\(fiscalYear)"
    }
    
    var quarterAsString: String {
        return "\(quarter)"
    }
    
    var periodAsString: String {
        return "\(period)"
    }
    
    var weekAsString: String {
        return "\(week)"
    }
    
    var dayAsString: String {
        return "\(day)"
    }
    
    init() {
        self.storedDate = Date()
        self.fiscalYear = 0
        self.quarter = 0
        self.period = 0
        self.week = 0
        self.day = 0
        self.fraction = Float(0.0)
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: self.storedDate)
        let now = cal.date(from: components)

        self.fiscalDateFromDate(now!)
    }
    
    init(fromDate date: Date) {
        self.storedDate = date
        self.fiscalYear = 0
        self.quarter = 0
        self.period = 0
        self.week = 0
        self.day = 0
        self.fraction = Float(0.0)
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: date)
        let normalizedDate = cal.date(from: components)
        
        self.fiscalDateFromDate(normalizedDate!)
    }
    
    private mutating func fiscalDateFromDate(_ date: Date) {

        let dateFormat = DateFormatter()
        dateFormat.setLocalizedDateFormatFromTemplate("MMddyy")
        
        let baseDate = dateFormat.date(from: "10/5/1970")
        let baseFiscalYear = 1971
        let daysInFiscalWeek = 7
        let daysInFiscalPeriod = 28
        let daysInFiscalYear = 364
        let baseExtraWeekFiscalYear = 1999
        let baseExtraWeekInterval = 6
        
        
        let daysDiff = date.timeIntervalSince(baseDate!) / Double(24 * 60 * 60)
        let years = Double(daysDiff) / Double(daysInFiscalYear)
        self.fiscalYear = Int(years) + baseFiscalYear
        let yearsRemander = years - Double(Int(years))
        let yearsRemanderAsDays = round(yearsRemander * Double(daysInFiscalYear))
        
        let periods = Double(yearsRemanderAsDays) / Double(daysInFiscalPeriod)
        self.period = Int(periods) + 1
        let periodsRemander = periods - Double(Int(periods))
        let periodsRemanderAsDays = round(periodsRemander * Double(daysInFiscalPeriod))
        
        let weeks = Double(periodsRemanderAsDays) / Double(daysInFiscalWeek)
        self.week = Int(weeks) + 1
        let weeksRemander = weeks - Double(Int(weeks))
        let weeksRemainderAsDays = (weeksRemander * Double(daysInFiscalWeek))
        
        if (self.fiscalYear > baseExtraWeekFiscalYear) {
            let baseYear = baseExtraWeekFiscalYear
            var yearsDiff = self.fiscalYear - baseYear
            while (yearsDiff > 0) {
                self.week -= 1
                if (self.week <= 0 && self.period == 1 && yearsDiff == 1) {
                    self.fiscalYear -= 1
                    yearsDiff -= 1
                    self.period = 13
                    self.week = 5
                    break
                } else {
                    if (self.week <= 0) {
                        self.period -= 1
                        self.week = 4
                    }
                    
                    if (self.period <= 0) {
                        self.fiscalYear -= 1
                        self.period = 13
                        yearsDiff -= 1
                    }
                }
                yearsDiff -= baseExtraWeekInterval
            }
        }
        
        self.storedDate = date
        self.day = Int(round(weeksRemainderAsDays)) + 1
        self.setQuarter()
        self.setWeekFraction()
    }
    
    private mutating func setQuarter() {
        switch self.period {
        case 1, 2, 3:
            self.quarter = 1
        case 4, 5, 6:
            self.quarter = 2
        case 7, 8, 9:
            self.quarter = 3
        case 10, 11, 12, 13:
            self.quarter = 4
        default:
            self.quarter = 0
        }
    }
    
    private mutating func setWeekFraction() {
        if (self.fiscalYear > 2000 && Int(self.fiscalYear % 6) == 1) && self.period == 13 {
            self.fraction = Float(self.week) / 5.0
        } else {
            self.fraction = Float(self.week) / 4.0
        }
    }
}
