//
//  CWFiscalDate.swift
//  Fiscal Year Calculator
//
//  Created by Stephen Ewell on 12/19/15.
//  Copyright © 2015 Stephen Ewell. All rights reserved.
//

import Foundation

protocol FiscalDate {
    var date: Date {get}
    var year: Int {get}
    var quarter: Int {get}
    var period: Int {get}
    var week: Int {get}
    var day: Int {get}
}

public struct CWFiscalDate: FiscalDate {
    var date: Date
    var year: Int
    var quarter: Int
    var period: Int
    var week: Int
    var day: Int
    
    var yearAsString: String {
        return "\(year)"
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
        self.date = Date()
        self.year = 0
        self.quarter = 0
        self.period = 0
        self.week = 0
        self.day = 0
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: self.date)
        let now = cal.date(from: components)

        self.fiscalDateFromDate(now!)
    }
    
    init(from calendarDate: Date) {
        self.date = calendarDate
        self.year = 0
        self.quarter = 0
        self.period = 0
        self.week = 0
        self.day = 0
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: calendarDate)
        let normalizedDate = cal.date(from: components)
        
        self.fiscalDateFromDate(normalizedDate!)
    }
    
    private mutating func fiscalDateFromDate(_ calendarDate: Date) {

        let dateFormat = DateFormatter()
        dateFormat.setLocalizedDateFormatFromTemplate("MMddyy")
        
        let baseDate = dateFormat.date(from: "10/5/1970")
        let baseFiscalYear = 1971
        let daysInFiscalWeek = 7
        let daysInFiscalPeriod = 28
        let daysInFiscalYear = 364
        let baseExtraWeekFiscalYear = 1999
        let baseExtraWeekInterval = 6
        
        
        let daysDiff = calendarDate.timeIntervalSince(baseDate!) / Double(24 * 60 * 60)
        let years = Double(daysDiff) / Double(daysInFiscalYear)
        self.year = Int(years) + baseFiscalYear
        let yearsRemainder = years - Double(Int(years))
        let yearsRemainderAsDays = round(yearsRemainder * Double(daysInFiscalYear))
        
        let periods = Double(yearsRemainderAsDays) / Double(daysInFiscalPeriod)
        self.period = Int(periods) + 1
        let periodsRemainder = periods - Double(Int(periods))
        let periodsRemainderAsDays = round(periodsRemainder * Double(daysInFiscalPeriod))
        
        let weeks = Double(periodsRemainderAsDays) / Double(daysInFiscalWeek)
        self.week = Int(weeks) + 1
        let weeksRemainder = weeks - Double(Int(weeks))
        let weeksRemainderAsDays = (weeksRemainder * Double(daysInFiscalWeek))
        
        if (self.year > baseExtraWeekFiscalYear) {
            let baseYear = baseExtraWeekFiscalYear
            var yearsDiff = self.year - baseYear
            while (yearsDiff > 0) {
                self.week -= 1
                if (self.week <= 0 && self.period == 1 && yearsDiff == 1) {
                    self.year -= 1
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
                        self.year -= 1
                        self.period = 13
                        yearsDiff -= 1
                    }
                }
                yearsDiff -= baseExtraWeekInterval
            }
        }
        
        self.date = calendarDate
        self.day = Int(round(weeksRemainderAsDays)) + 1
        self.setQuarter()
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
}
