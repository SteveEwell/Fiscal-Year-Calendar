//
//  InterfaceController.swift
//  Fiscal Year Calendar WatchKit Extension
//
//  Created by Stephen Ewell on 5/7/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var fiscalYear: WKInterfaceLabel!
    @IBOutlet var fiscalPeriod: WKInterfaceLabel!
    @IBOutlet var fiscalWeek: WKInterfaceLabel!
    var dateNow: CWFiscalDate!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.dateNow = CWFiscalDate()
    }
    
    override func willActivate() {
        super.willActivate()
        self.dateNow = CWFiscalDate()
        self.fiscalYear.setText(String(self.dateNow.year))
        self.fiscalPeriod.setText(String(self.dateNow.period))
        self.fiscalWeek.setText(String(self.dateNow.week))
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
