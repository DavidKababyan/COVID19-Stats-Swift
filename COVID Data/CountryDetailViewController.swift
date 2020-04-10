//
//  CountryDetailViewController.swift
//  COVID Data
//
//  Created by David Kababyan on 10/04/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit

class CountryDetailViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Vars
    var countryData: CountryData?

    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        cardBackgroundView.layer.cornerRadius = 8
        if countryData != nil {
            presentCountryData()
        }
    }
    
    //MARK: - UpdateUI
    private func presentCountryData() {
        
        self.navigationItem.title = countryData!.country
        
        
    }

    

}


extension CountryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryData != nil ? 6 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.setupCell("Confirmed", _subTitle: countryData!.confirmed.formatNumber(), _color: .label)
        case 1:
            cell.setupCell("Critical", _subTitle: countryData!.critical.formatNumber(), _color: .systemOrange)
        case 2:
            cell.setupCell("Death", _subTitle: countryData!.deaths.formatNumber(), _color: .systemRed)
        case 3:
            cell.setupCell("Death %", _subTitle: String(format: "%.2f", countryData!.recoveredRate) + "%", _color: .systemRed)
        case 4:
            cell.setupCell("Recovered", _subTitle: countryData!.recovered.formatNumber(), _color: .systemGreen)
        default:
            cell.setupCell("Recovered %", _subTitle: String(format: "%.2f", countryData!.recoveredRate) + "%", _color: .systemGreen)
        }
        
        return cell
    }
    
    
    
}
