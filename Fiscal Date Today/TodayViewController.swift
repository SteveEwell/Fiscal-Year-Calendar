//
//  TodayViewController.swift
//  Fiscal Date Today
//
//  Created by Stephen Ewell on 7/22/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var quarterLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yearLabel.text = "20XX"
        self.quarterLabel.text = "0"
        self.periodLabel.text = "00"
        self.weekLabel.text = "0"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let dateNow = CWFiscalDate()
        self.yearLabel.text = String(dateNow.year)
        self.quarterLabel.text = String(dateNow.quarter)
        self.periodLabel.text = String(dateNow.period)
        self.weekLabel.text = String(dateNow.week)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
