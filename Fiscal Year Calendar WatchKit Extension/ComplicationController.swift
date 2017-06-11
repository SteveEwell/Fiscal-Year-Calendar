//
//  ComplicationController.swift
//  Fiscal Year Calendar WatchKit Extension
//
//  Created by Stephen Ewell on 5/7/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let dataProvider = DataProvider()
    
    // MARK: - Setup Template
    
    func templateCircularSmallRingForData(_ data: CWFiscalDate) -> CLKComplicationTemplateCircularSmallRingText {
        let template = CLKComplicationTemplateCircularSmallRingText()
        template.textProvider = CLKSimpleTextProvider(text: data.periodAsString)
        template.fillFraction = data.fraction
        template.ringStyle = .closed
        return template
    }
    
    func placeholderTemplateCircularSmallRing() -> CLKComplicationTemplateCircularSmallRingText {
        let template = CLKComplicationTemplateCircularSmallRingText()
        template.textProvider = CLKSimpleTextProvider(text: "--")
        template.fillFraction = 1.0
        template.ringStyle = .closed
        return template
    }
    
    func templateModularSmallForData(_ data: CWFiscalDate) -> CLKComplicationTemplateModularSmallColumnsText {
        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "PR")
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "WK")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: data.periodAsString)
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: data.weekAsString)
        return template
    }
    
    func placeholderTemplateModularSmall() -> CLKComplicationTemplateModularSmallColumnsText {
        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "PR")
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "WK")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
        return template
    }
    
    func templateModularLargeForData(_ data: CWFiscalDate) -> CLKComplicationTemplateModularLargeColumns {
        let template = CLKComplicationTemplateModularLargeColumns()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "YEAR")
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "PERIOD")
        template.row3Column1TextProvider = CLKSimpleTextProvider(text: "WEEK")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: data.yearAsString)
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: data.periodAsString)
        template.row3Column2TextProvider = CLKSimpleTextProvider(text: data.weekAsString)
        return template
    }
    
    func placeholderTemplateModularLarge() -> CLKComplicationTemplateModularLargeColumns {
        let template = CLKComplicationTemplateModularLargeColumns()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "YEAR")
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "PERIOD")
        template.row3Column1TextProvider = CLKSimpleTextProvider(text: "WEEK")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
        template.row3Column2TextProvider = CLKSimpleTextProvider(text: "--")
        return template
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        if let dt = self.dataProvider.thirtyDaysData().first {
            print(dt.date)
            handler(dt.date)
        } else {
            handler(Date())
        }
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        if let dt = self.dataProvider.thirtyDaysData().last {
            print(dt.date)
            handler(dt.date)
        } else {
            handler(Date())
        }
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func timelineEntryForData(_ data: CWFiscalDate, complication: CLKComplication) -> CLKComplicationTimelineEntry {
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = self.templateModularSmallForData(data)
        case .modularLarge:
            template = self.templateModularLargeForData(data)
        case .circularSmall:
            template = self.templateCircularSmallRingForData(data)
        default:
            template = nil
        }
        return CLKComplicationTimelineEntry(date: data.date, complicationTemplate: template!)
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let data = self.dataProvider.thirtyDaysData().dataForNow() {
            handler(self.timelineEntryForData(data, complication: complication))
        } else {
            let dt = Date()
            handler(CLKComplicationTimelineEntry(date: dt, complicationTemplate: self.getPlaceholder(for: complication)))
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let entries = self.dataProvider.thirtyDaysData().filter{
                date.compare($0.date as Date) == .orderedDescending
            }.map {
                self.timelineEntryForData($0, complication: complication)
            }
        handler(entries)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let entries = self.dataProvider.thirtyDaysData().filter{
                date.compare($0.date as Date) == .orderedAscending
            }.map {
                self.timelineEntryForData($0, complication: complication)
            }
        handler(entries)
    }
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        handler(Date.endOfToday());
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholder(for complication: CLKComplication) -> CLKComplicationTemplate {
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = self.placeholderTemplateModularSmall()
        case .modularLarge:
            template = self.placeholderTemplateModularLarge()
        case .circularSmall:
            template = self.placeholderTemplateCircularSmallRing()
        default:
            template = nil
        }
        return template!
    }
    
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = self.getPlaceholder(for: complication)
        handler(template)
    }
}
