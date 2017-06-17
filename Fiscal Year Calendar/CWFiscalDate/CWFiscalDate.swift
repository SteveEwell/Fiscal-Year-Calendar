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

    /// Fiscal year as a String value.
    var yearAsString: String {
        return "\(year)"
    }

    /// Fiscal quarter as a String value.
    var quarterAsString: String {
        return "\(quarter)"
    }

    /// Fiscal period as a String value.
    var periodAsString: String {
        return "\(period)"
    }

    /// Period week as a String value.
    var weekAsString: String {
        return "\(week)"
    }

    /// Day of week as a String value.
    var dayAsString: String {
        return "\(day)"
    }

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
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: calendarDate)
        let normalizedDate = cal.date(from: components)
        
        self.fiscalDate(from: normalizedDate!)
    }

    /**
    Sets all the properties for the fiscal date based on a Date object.

    - Parameter calendarDate: The Date object used to derive the fiscal date.
    */
    private mutating func fiscalDate(from calendarDate: Date) {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.day = 5
        components.month = 10
        components.year = 1970
        
        let baseDate = cal.date(from: components)
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
