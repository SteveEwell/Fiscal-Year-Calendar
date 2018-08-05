//
// Created by Stephen Ewell on 8/5/18.
// Copyright (c) 2018 Stephen Ewell. All rights reserved.
//

import UIKit

class CWSelectCountryTableViewController: UITableViewController {
    private let countries: [HolidayCountry] = [.US, .CA]
    private var selectedCountry: String = "United States"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let defaults = UserDefaults.standard
        self.selectedCountry = defaults.object(forKey: "Country") as? String ?? "United States"

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)

        let cellCountry = self.countries[indexPath.row].rawValue

        cell.textLabel?.text = cellCountry

        if (self.selectedCountry == cellCountry) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setSetting(country: self.countries[indexPath.row].rawValue)
        self.performSegue(withIdentifier: "toSettings", sender: self)

    }

    private func setSetting(country: String) {
        let defaults = UserDefaults.standard
        defaults.set(country, forKey: "Country")
    }
}
