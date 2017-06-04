//
//  Fiscal_Year_CalendarTests.swift
//  Fiscal Year CalendarTests
//
//  Created by Stephen Ewell on 5/7/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import XCTest
@testable import Fiscal_Year_Calendar

class Fiscal_Year_CalendarTests: XCTestCase {
    
    let dateFormat = CWFiscalDateFormatter()
    let utilities = CWFiscalDateUtilities()
    
    override func setUp() {
        super.setUp()
        dateFormat.setLocalizedDateFormatFromTemplate("MMddyy")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPeriodStartDate() {
        let testDateOne = dateFormat.fiscalDateFromString("12/5/2015")
        let testDateTwo = dateFormat.fiscalDateFromString("9/2/2012")
        let testPStartDateOne = dateFormat.date(from: "11/23/2015")
        let testPStartDateTwo = dateFormat.date(from: "8/06/2012")
        XCTAssertEqual(utilities.dateForStartOfFiscalPeriod(testDateOne), testPStartDateOne!)
        XCTAssertEqual(utilities.dateForStartOfFiscalPeriod(testDateTwo), testPStartDateTwo!)
    }
    
    func testFiscalYearStartDate() {
        let testDateOne = dateFormat.fiscalDateFromString("12/5/2015")
        let testDateTwo = dateFormat.fiscalDateFromString("8/30/2015")
        let testYStartDate = dateFormat.date(from: "8/31/2015")
        let testYStartDateTwo = dateFormat.date(from: "9/1/2014")
        XCTAssertEqual(utilities.dateForStartOfFiscalYear(testDateOne), testYStartDate!)
        XCTAssertEqual(utilities.dateForStartOfFiscalYear(testDateTwo), testYStartDateTwo!)
    }
    
    func testFiscalDateAsString() {
        let testDateOne = dateFormat.fiscalDateFromString("12/5/2015")
        let testDateTwo = dateFormat.fiscalDateFromString("12/6/2015")
        XCTAssertEqual(dateFormat.stringFromFiscalDate(testDateOne), "FY2016P4W2")
        XCTAssertEqual(dateFormat.stringFromFiscalDate(testDateTwo), "FY2016P4W2")
    }
    
    func testHasWeekFive() {
        let testDateOne = dateFormat.fiscalDateFromString("9/4/2011")
        let testDateTwo = dateFormat.fiscalDateFromString("9/3/2017")
        let testDateThree = dateFormat.fiscalDateFromString("9/5/2011")
        let testDateFour = dateFormat.fiscalDateFromString("9/4/2017")
        XCTAssertEqual(utilities.fiscalYearHasWeekFive(testDateOne), true)
        XCTAssertEqual(utilities.fiscalYearHasWeekFive(testDateTwo), true)
        XCTAssertEqual(utilities.fiscalYearHasWeekFive(testDateThree), false)
        XCTAssertEqual(utilities.fiscalYearHasWeekFive(testDateFour), false)
        
    }
    
    func testFiscalSaturdayOne() {
        let testDate = dateFormat.fiscalDateFromString("12/5/2015")
        XCTAssertEqual(testDate.year, 2016)
        XCTAssertEqual(testDate.quarter, 2)
        XCTAssertEqual(testDate.period, 4)
        XCTAssertEqual(testDate.week, 2)
        XCTAssertEqual(testDate.day, 6)
    }
    
    func testFiscalSundayOne() {
        let testDate = dateFormat.fiscalDateFromString("12/6/2015")
        XCTAssertEqual(testDate.year, 2016)
        XCTAssertEqual(testDate.quarter, 2)
        XCTAssertEqual(testDate.period, 4)
        XCTAssertEqual(testDate.week, 2)
        XCTAssertEqual(testDate.day, 7)
    }
    
    func testFiscalMondayOne() {
        let testDate = dateFormat.fiscalDateFromString("12/7/2015")
        XCTAssertEqual(testDate.year, 2016)
        XCTAssertEqual(testDate.quarter, 2)
        XCTAssertEqual(testDate.period, 4)
        XCTAssertEqual(testDate.week, 3)
        XCTAssertEqual(testDate.day, 1)
    }
    
    func testFiscalSundayTwo() {
        let testDate = dateFormat.fiscalDateFromString("12/13/2015")
        XCTAssertEqual(testDate.year, 2016)
        XCTAssertEqual(testDate.quarter, 2)
        XCTAssertEqual(testDate.period, 4)
        XCTAssertEqual(testDate.week, 3)
        XCTAssertEqual(testDate.day, 7)
    }
    
    func testFiscalMondayTwo() {
        let testDate = dateFormat.fiscalDateFromString("12/14/2015")
        XCTAssertEqual(testDate.year, 2016)
        XCTAssertEqual(testDate.quarter, 2)
        XCTAssertEqual(testDate.period, 4)
        XCTAssertEqual(testDate.week, 4)
        XCTAssertEqual(testDate.day, 1)
    }
    
    func testFiscalSundayThree() {
        let testDate = dateFormat.fiscalDateFromString("12/20/2015")
        XCTAssertEqual(testDate.year, 2016)
        XCTAssertEqual(testDate.quarter, 2)
        XCTAssertEqual(testDate.period, 4)
        XCTAssertEqual(testDate.week, 4)
        XCTAssertEqual(testDate.day, 7)
    }
    
    func testFiscalMondayThree() {
        let testDate = dateFormat.fiscalDateFromString("12/21/2015")
        XCTAssertEqual(testDate.year, 2016)
        XCTAssertEqual(testDate.quarter, 2)
        XCTAssertEqual(testDate.period, 5)
        XCTAssertEqual(testDate.week, 1)
        XCTAssertEqual(testDate.day, 1)
    }
    
    func testFiscalWeekFiveFuture() {
        let testDate = dateFormat.fiscalDateFromString("9/3/2017")
        XCTAssertEqual(testDate.year, 2017)
        XCTAssertEqual(testDate.quarter, 4)
        XCTAssertEqual(testDate.period, 13)
        XCTAssertEqual(testDate.week, 5)
        XCTAssertEqual(testDate.day, 7)
    }
    
    func testFiscalWeekOneFuture() {
        let testDate = dateFormat.fiscalDateFromString("9/3/2018")
        XCTAssertEqual(testDate.year, 2019)
        XCTAssertEqual(testDate.quarter, 1)
        XCTAssertEqual(testDate.period, 1)
        XCTAssertEqual(testDate.week, 1)
        XCTAssertEqual(testDate.day, 1)
    }
    
    func testFiscalWeekFivePast() {
        let testDate = dateFormat.fiscalDateFromString("9/4/2011")
        XCTAssertEqual(testDate.year, 2011)
        XCTAssertEqual(testDate.quarter, 4)
        XCTAssertEqual(testDate.period, 13)
        XCTAssertEqual(testDate.week, 5)
        XCTAssertEqual(testDate.day, 7)
    }
    
    func testFiscalWeekOnePast() {
        let testDate = dateFormat.fiscalDateFromString("9/3/2012")
        XCTAssertEqual(testDate.year, 2013)
        XCTAssertEqual(testDate.quarter, 1)
        XCTAssertEqual(testDate.period, 1)
        XCTAssertEqual(testDate.week, 1)
        XCTAssertEqual(testDate.day, 1)
    }
    
}
