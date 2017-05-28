//
//  CWFiscalDateUtilities.swift
//
//  Created by Stephen Ewell on 12/6/15.
//  Copyright © 2015 Stephen Ewell. All rights reserved.
//

import Foundation

public class CWFiscalDateUtilities {
    
    
    // MARK: Public methods
    public func getNormalizedDate(_ date: Date) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = cal.dateComponents([.day , .month, .year ], from: date)
        let normalizedDate = cal.date(from: components)
        
        return normalizedDate!
    }
    
    public func fiscalYearHasWeekFive(_ fiscalDate:CWFiscalDate) -> Bool {
        if (fiscalDate.fiscalYear > 2000 && Int(fiscalDate.fiscalYear % 6) == 1) {
            return true
        }
        return false
    }
    
    public func fiscalDayInWeekFive(_ fiscalDate:CWFiscalDate) -> Bool {
        if (fiscalDate.week == 5) {
            return true
        } else {
            return false
        }
    }
    
    public func dateForStartOfFiscalPeriod(_ fiscalDate:CWFiscalDate) -> Date {
        let fiscalDay:Int = (fiscalDate.week * 7) - (7 - fiscalDate.day) - 1
        let calendar:Calendar = Calendar.current
        var offset:DateComponents = DateComponents.init()
        offset.day = 0 - fiscalDay
        let date = calendar.date(byAdding: offset, to: fiscalDate.storedDate as Date)
        
        return date!
    }
    
    public func dateForStartOfFiscalYear(_ fiscalDate:CWFiscalDate) -> Date {
        var periodsAsDays:Int = 0
        var weeksAsDays:Int = 0
        if (fiscalDate.period > 1) {
            periodsAsDays = (fiscalDate.period - 1) * 28
        }
        if (fiscalDate.week > 1) {
            weeksAsDays = (fiscalDate.week - 1) * 7
        }
        let days = periodsAsDays + weeksAsDays + fiscalDate.day - 1
        let calendar:Calendar = Calendar.current
        var offset:DateComponents = DateComponents.init()
        offset.day = 0 - days
        let date = calendar.date(byAdding: offset, to: fiscalDate.storedDate as Date)
        
        return date!
    }
    
    public func getFiscalPeriodForDate(_ date:Date) -> CWFiscalPeriod {
        let fiscalDate = CWFiscalDate(fromDate: date)
        let period = getFiscalPeriodForFiscalDate(fiscalDate)
        
        return period
    }
    
    public func getFiscalPeriodForFiscalDate(_ fiscalDate:CWFiscalDate) -> CWFiscalPeriod {
        let hasWeekFive = self.fiscalYearHasWeekFive(fiscalDate)
        var numberOfDays: Int = 0
        let startDate: Date = self.dateForStartOfFiscalPeriod(fiscalDate)
        let startFiscalDate: CWFiscalDate = CWFiscalDate.init(fromDate: startDate)
        let calendar: Calendar = Calendar.current
        var offset: DateComponents = DateComponents.init()
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
            let nextFiscalDay:CWFiscalDate = CWFiscalDate.init(fromDate: nextDay!)
            
            datesArray.append(nextFiscalDay)
        }
        let fiscalPeriod = CWFiscalPeriod.init(period:startFiscalDate.period, fiscalYear:startFiscalDate.fiscalYear, dates: datesArray)
        return fiscalPeriod
    }
    
    public func getFiscalYearForDate(_ date:Date) -> CWFiscalYear {
        let fiscalDate = CWFiscalDate(fromDate: date)
        let year = getFiscalYearForFiscalDate(fiscalDate)
        
        return year
    }
    
    public func getFiscalYearForFiscalDate(_ fiscalDate:CWFiscalDate) -> CWFiscalYear {
        let startOfYearDate:Date = self.dateForStartOfFiscalYear(fiscalDate)
        var fiscalYear:Int = 0
        var periodsArray = [CWFiscalPeriod]()
        var lastDayInPeriod = CWFiscalDate()
        for i in 0..<13 {
            if (i == 0) {
                let start = CWFiscalDate(fromDate: startOfYearDate)
                let period = self.getFiscalPeriodForFiscalDate(start)
                let periodCount = period.dates.count
                lastDayInPeriod = period.dates[periodCount - 1]
                fiscalYear = period.fiscalYear
                periodsArray.insert(period, at: i)
            } else {
                let calendar:Calendar = Calendar.current
                var offset:DateComponents = DateComponents.init()
                offset.day = 1
                let startPeriod = calendar.date(byAdding: offset, to: lastDayInPeriod.storedDate as Date)
                let start = CWFiscalDate(fromDate: startPeriod!)
                let period = self.getFiscalPeriodForFiscalDate(start)
                let periodCount = period.dates.count
                lastDayInPeriod = period.dates[periodCount - 1]
                periodsArray.insert(period, at: i)
            }
        }
        
        return CWFiscalYear(fiscalYear:fiscalYear, periods: periodsArray)
    }
    
    public func getNextPeriodForFiscalPeriod(_ fiscalPeriod:CWFiscalPeriod) -> CWFiscalPeriod {
        let endDateIndex = fiscalPeriod.dates.count - 1
        let endDate = fiscalPeriod.dates[endDateIndex]
        let calendar:Calendar = Calendar.current
        var offset: DateComponents = DateComponents.init()
        offset.day = 1
        let date = calendar.date(byAdding: offset, to: endDate.storedDate as Date)
        let nextPeriod = getFiscalPeriodForDate(date!)
        
        return nextPeriod
    }
    
    public func getPreviousPeriodForFiscalPeriod(_ fiscalPeriod:CWFiscalPeriod) -> CWFiscalPeriod {
        let startDate = fiscalPeriod.dates[0]
        let calendar:Calendar = Calendar.current
        var offset = DateComponents()
        offset.day = 0 - 1
        let date = calendar.date(byAdding: offset, to: startDate.storedDate as Date)
        let previousPeriod = getFiscalPeriodForDate(date!)
        
        return previousPeriod
    }
    
    public func getNextYearForFiscalYear(_ fiscalYear:CWFiscalYear) -> CWFiscalYear {
        let endPeriodIndex = fiscalYear.periods.count - 1
        let endDateIndex = fiscalYear.periods[endPeriodIndex].dates.count - 1
        let endDate = fiscalYear.periods[endPeriodIndex].dates[endDateIndex]
        let nextStartDate = Date.init(timeInterval: 86400, since: endDate.storedDate as Date)
        let nextYear = getFiscalYearForDate(nextStartDate)
        
        return nextYear
    }
    
    public func getPreviousYearForFiscalYear(_ fiscalYear:CWFiscalYear) -> CWFiscalYear {
        let startDate = fiscalYear.periods[0].dates[0]
        let calendar:Calendar = Calendar.current
        var offset:DateComponents = DateComponents.init()
        offset.day = 0 - 1
        let date = calendar.date(byAdding: offset, to: startDate.storedDate as Date)
        let previousYear = getFiscalYearForDate(date!)
        
        return previousYear
    }
    
    // MARK: Private methods
    private func isFutureDate(_ date:Date) -> Bool {
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
