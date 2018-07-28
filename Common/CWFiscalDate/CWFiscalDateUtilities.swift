//
//  CWFiscalDateUtilities.swift
//
//  Created by Stephen Ewell on 12/6/15.
//  Copyright © 2015 Stephen Ewell. All rights reserved.
//

import Foundation

public class CWFiscalDateUtilities {


    public func getNormalizedDate(_ date: Date) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: date)
        let normalizedDate = cal.date(from: components)
        
        return normalizedDate!
    }
    
    public func fiscalYearHasWeekFive(_ fiscalDate: CWFiscalDate) -> Bool {
        if (fiscalDate.year > 2000 && Int(fiscalDate.year % 6) == 1) {
            return true
        }
        return false
    }
    
    public func fiscalDayInWeekFive(_ fiscalDate: CWFiscalDate) -> Bool {
        if (fiscalDate.week == 5) {
            return true
        } else {
            return false
        }
    }
    
    public func startOfFiscalPeriodDate(for fiscalDate: CWFiscalDate) -> Date {
        let fiscalDay = (fiscalDate.week * 7) - (7 - fiscalDate.day) - 1
        let calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 0 - fiscalDay
        let date = calendar.date(byAdding: offset, to: fiscalDate.date)
        
        return date!
    }
    
    public func startOfFiscalYearDate(for fiscalDate: CWFiscalDate) -> Date {
        var periodsAsDays = 0
        var weeksAsDays = 0
        if (fiscalDate.period > 1) {
            periodsAsDays = (fiscalDate.period - 1) * 28
        }
        if (fiscalDate.week > 1) {
            weeksAsDays = (fiscalDate.week - 1) * 7
        }
        let days = periodsAsDays + weeksAsDays + fiscalDate.day - 1
        let calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 0 - days
        let date = calendar.date(byAdding: offset, to: fiscalDate.date)
        
        return date!
    }
    
    public func fiscalPeriod(for date: Date) -> CWFiscalPeriod {
        let fiscalDate = CWFiscalDate(from: date)
        let period = fiscalPeriod(for: fiscalDate)
        
        return period
    }
    
    public func fiscalPeriod(for fiscalDate: CWFiscalDate) -> CWFiscalPeriod {
        let hasWeekFive = self.fiscalYearHasWeekFive(fiscalDate)
        var numberOfDays = 0
        let startDate = self.startOfFiscalPeriodDate(for: fiscalDate)
        let startFiscalDate = CWFiscalDate(from: startDate)
        let calendar = Calendar.current
        var offset = DateComponents()
        var datesArray = [CWFiscalDate]()
        datesArray.append(startFiscalDate)
        
        if (hasWeekFive && fiscalDate.period == 13) {
            numberOfDays = 35
        } else {
            numberOfDays = 28
        }
        
        for i in 1 ..< numberOfDays {
            offset.day = i
            let nextDay = calendar.date(byAdding: offset, to: startDate)
            let nextFiscalDay = CWFiscalDate(from: nextDay!)
            
            datesArray.append(nextFiscalDay)
        }
        let fiscalPeriod = CWFiscalPeriod(period: startFiscalDate.period, year: startFiscalDate.year, dates: datesArray)
        return fiscalPeriod
    }
    
    public func fiscalYear(for date: Date) -> CWFiscalYear {
        let fiscalDate = CWFiscalDate(from: date)
        let year = fiscalYear(for: fiscalDate)
        
        return year
    }
    
    public func fiscalYear(for fiscalDate: CWFiscalDate) -> CWFiscalYear {
        let startOfYearDate = self.startOfFiscalYearDate(for: fiscalDate)
        var fiscalYear = 0
        var periodsArray = [CWFiscalPeriod]()
        var lastDayInPeriod = CWFiscalDate()
        for i in 0..<13 {
            if (i == 0) {
                let start = CWFiscalDate(from: startOfYearDate)
                let period = self.fiscalPeriod(for: start)
                let periodCount = period.dates.count
                lastDayInPeriod = period.dates[periodCount - 1]
                fiscalYear = period.year
                periodsArray.insert(period, at: i)
            } else {
                let calendar = Calendar.current
                var offset = DateComponents()
                offset.day = 1
                let startPeriod = calendar.date(byAdding: offset, to: lastDayInPeriod.date)
                let start = CWFiscalDate(from: startPeriod!)
                let period = self.fiscalPeriod(for: start)
                let periodCount = period.dates.count
                lastDayInPeriod = period.dates[periodCount - 1]
                periodsArray.insert(period, at: i)
            }
        }
        
        return CWFiscalYear(fiscalYear: fiscalYear, periods: periodsArray)
    }
    
    public func nextPeriod(for fiscalPeriod: CWFiscalPeriod) -> CWFiscalPeriod {
        let endDateIndex = fiscalPeriod.dates.count - 1
        let endDate = fiscalPeriod.dates[endDateIndex]
        let calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 1
        let date = calendar.date(byAdding: offset, to: endDate.date)
        let nextPeriod = self.fiscalPeriod(for: date!)
        
        return nextPeriod
    }
    
    public func previousPeriod(for fiscalPeriod: CWFiscalPeriod) -> CWFiscalPeriod {
        let startDate = fiscalPeriod.dates[0]
        let calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 0 - 1
        let date = calendar.date(byAdding: offset, to: startDate.date)
        let previousPeriod = self.fiscalPeriod(for: date!)
        
        return previousPeriod
    }
    
    public func nextYear(for fiscalYear: CWFiscalYear) -> CWFiscalYear {
        let endPeriodIndex = fiscalYear.periods.count - 1
        let endDateIndex = fiscalYear.periods[endPeriodIndex].dates.count - 1
        let endDate = fiscalYear.periods[endPeriodIndex].dates[endDateIndex]
        let nextStartDate = Date(timeInterval: 86400, since: endDate.date)
        let nextYear = self.fiscalYear(for: nextStartDate)
        
        return nextYear
    }
    
    public func previousYear(for fiscalYear: CWFiscalYear) -> CWFiscalYear {
        let startDate = fiscalYear.periods[0].dates[0]
        let calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 0 - 1
        let date = calendar.date(byAdding: offset, to: startDate.date)
        let previousYear = self.fiscalYear(for: date!)
        
        return previousYear
    }

    @objc public func isFutureDate(_ date: Date) -> Bool {
        let now = Date()
        let futureDate = (now as NSDate).laterDate(date)
        let pastDate = (now as NSDate).earlierDate(date)
        
        if ((futureDate == date) && (pastDate != date)) {
            return false
        } else {
            return true
        }
    }
}
