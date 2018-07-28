//
//  ComplicationController.swift
//  Fiscal Year Calendar WatchKit Extension
//
//  Created by Stephen Ewell on 5/7/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
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
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
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
        let data = CWFiscalDate()
        handler(self.timelineEntryForData(data, complication: complication))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
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
