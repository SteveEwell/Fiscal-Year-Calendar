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

private struct FiscalUnit {
    let current: Int
    let remainderAsDays: Double
}

/// The fiscal date for a given calendar date.
public struct CWFiscalDate: FiscalDate {
    /// Calendar date that the fiscal date is derived from.
    var date: Date

    /// The fiscal year.
    var year: Int

    /// The fiscal quarter.
    var quarter: Int

    /// The fiscal period.
    var period: Int

    /// Week in the fiscal period.
    var week: Int

    /// Day in the week starting on Monday (1 - 7).
    var day: Int

    /// The fiscal year as a String value.
    var yearAsString: String {
        return "\(year)"
    }

    /// The fiscal quarter as a String value.
    var quarterAsString: String {
        return "\(quarter)"
    }

    /// The fiscal period as a String value.
    var periodAsString: String {
        return "\(period)"
    }

    /// The fiscal week as a String value.
    var weekAsString: String {
        return "\(week)"
    }

    /// The fiscal day as a String value.
    var dayAsString: String {
        return "\(day)"
    }

    private var yearsDiff: Int

    /**
    Initializes a new fiscal date based on the current date.

    - Returns: A CWFiscalDate based on the current date.
    */
    init() {
        self.date = Date()
        self.year = 0
        self.quarter = 0
        self.period = 0
        self.week = 0
        self.day = 0
        self.yearsDiff = 0
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: self.date)
        let now = cal.date(from: components)

        self.fiscalDate(from: now!)
    }

    /**
    Initializes a new fiscal date based on a Date object.

    - Parameter calendarDate: The Date object used to derive the fiscal date.

    - Returns: A CWFiscalDate based on a Date object.
    */
    init(from calendarDate: Date) {
        self.date = calendarDate
        self.year = 0
        self.quarter = 0
        self.period = 0
        self.week = 0
        self.day = 0
        self.yearsDiff = 0
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: calendarDate)
        let normalizedDate = cal.date(from: components)
        
        self.fiscalDate(from: normalizedDate!)
    }
    
    private func getYearUnit(calendarDate: Date) -> FiscalUnit {
        let daysInFiscalYear = 364
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        
        components.day = 5
        components.month = 10
        components.year = 1970
        
        let baseDate = cal.date(from: components)
        let daysDiff = calendarDate.timeIntervalSince(baseDate!) / Double(24 * 60 * 60)
        let years = Double(daysDiff) / Double(daysInFiscalYear)
        let year = Int(years) + 1971 // 1971 is starting year.
        let yearsRemainder = years - Double(Int(years))
        let yearsRemainderAsDays = round(yearsRemainder * Double(daysInFiscalYear))
        
        return FiscalUnit(current: year, remainderAsDays: yearsRemainderAsDays)
        
    }
    
    private func getPeriodUnit(year: FiscalUnit) -> FiscalUnit {
        let daysInFiscalPeriod = 28
        
        let periods = Double(year.remainderAsDays) / Double(daysInFiscalPeriod)
        let period = Int(periods) + 1
        let periodsRemainder = periods - Double(Int(periods))
        let periodsRemainderAsDays = round(periodsRemainder * Double(daysInFiscalPeriod))
        
        return FiscalUnit(current: period, remainderAsDays: periodsRemainderAsDays)
    }
    
    private func getWeekUnit(period: FiscalUnit) -> FiscalUnit {
        let daysInFiscalWeek = 7
        
        let weeks = Double(period.remainderAsDays) / Double(daysInFiscalWeek)
        let week = Int(weeks) + 1
        let weeksRemainder = weeks - Double(Int(weeks))
        let weeksRemainderAsDays = (weeksRemainder * Double(daysInFiscalWeek))
        
        return FiscalUnit(current: week, remainderAsDays: weeksRemainderAsDays)
    }
    
    private func isInFifthWeek() -> Bool {
        if (self.week <= 0 && self.period == 1 && self.yearsDiff == 1) {
            return true
        }
        
        return false
    }
    
    private mutating func setFifthWeek() {
        self.year -= 1
        self.yearsDiff -= 1
        self.period = 13
        self.week = 5
    }
    
    private mutating func adjustDateOffset() {
        
        // Set to last week of the period
        if (self.week <= 0) {
            self.period -= 1
            self.week = 4
        }
        
        // set to the last period of the year
        if (self.period <= 0) {
            self.year -= 1
            self.period = 13
            self.yearsDiff -= 1
        }
    }
    
    private mutating func extraWeekAdjustment() {
        let baseYear = 1999
        self.yearsDiff = self.year - baseYear
        
        if (self.year > baseYear) {
            while (self.yearsDiff > 0) {
                self.week -= 1
                
                if (self.isInFifthWeek()) {
                    self.setFifthWeek()
                    break
                } else {
                    self.adjustDateOffset()
                }
                
                self.yearsDiff -= 6 //  base extra week interval
            }
        }

    }

    /**
    Sets all the properties for the fiscal date based on a Date object.

    - Parameter calendarDate: The Date object used to derive the fiscal date.
    */
    private mutating func fiscalDate(from calendarDate: Date) {
        let year = self.getYearUnit(calendarDate: calendarDate)
        let period = self.getPeriodUnit(year: year)
        let week = self.getWeekUnit(period: period)

        self.year = year.current
        self.period = period.current
        self.week = week.current

        self.extraWeekAdjustment()

        self.day = Int(round(week.remainderAsDays)) + 1
        self.date = calendarDate
        self.setQuarter()
    }

    /// Sets the quarter property based ont the period.
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
