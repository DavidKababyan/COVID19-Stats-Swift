//
//  ViewController.swift
//  COVID Data
//
//  Created by David Kababyan on 10/04/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit

class AllResultsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var recoveredPercentLabel: UILabel!
    @IBOutlet weak var deathPercentLabel: UILabel!
    @IBOutlet weak var criticalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var goButtonOutlet: UIButton!
    @IBOutlet weak var searchOptionsView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Vars
    var allCountries: [CountryData] = []
    var filteredCountries: [CountryData] = []

    var sortPopupView: SortPopUpMenuController!
    var isSortPopUpVisible = false
    var isSearching = false

    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCountryData()
        fetchTotalData()
        setupPopUpView()
        
        tableView.tableFooterView = UIView()
        
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        isSortPopUpVisible ? hideSortPopUpView() : showSortPopUpView()
        isSortPopUpVisible.toggle()
    }

    @IBAction func searchBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        showSearchField()
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        if searchTextField.text != "" {
            isSearching = true
            updateLeftBarButtonItem()
            filteredContentForSearchText(searchText: searchTextField.text!)
            emptyTextField()
            animateSearchOptionsIn()
            dismissKeyboard()
        }

    }
    
    @objc func stopSearchButtonPressed(_ sender: Any) {
        
        isSearching = false
        updateLeftBarButtonItem()
        tableView.reloadData()
    }
    
    //MARK: - FetchData
    
    private func fetchTotalData() {
        CovidFetchRequest().getCurrentTotal { (totalData) in
            
            self.updateTotalValues(totalData)
        }
    }
    
    private func fetchCountryData() {
        
        CovidFetchRequest().getAllCountries { (allCountries) in
            
            self.allCountries = allCountries
            self.updateData()
        }
    }
    
    //MARK: - Setup

    private func setupPopUpView() {
        
        sortPopupView = SortPopUpMenuController()
        sortPopupView.containerView.layer.cornerRadius = 20
        sortPopupView.delegate = self
        sortPopupView.frame = CGRect(x: 0, y: self.view.frame.height
            + 90, width: self.view.frame.width, height: 200)
                
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow!.addSubview(sortPopupView)
        
    }

    private func updateLeftBarButtonItem() {

        if isSearching {
             self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(stopSearchButtonPressed))
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    //MARK: - Update UI

    private func updateTotalValues(_ totalData: TotalData?) {
        
        if totalData != nil {
            confirmedLabel.text = totalData!.confirmed.formatNumber()
            criticalLabel.text = totalData!.critical.formatNumber()

            deathLabel.text = totalData!.deaths.formatNumber()
            deathPercentLabel.text = String(format: "%.2f", totalData!.fatalityRate)
            
            recoveredLabel.text = totalData!.recovered.formatNumber()
            recoveredPercentLabel.text = String(format: "%.2f", totalData!.recoveredRate) 
        }
    }
    
    private func updateData(sortBy: String = "") {
        
        switch sortBy {
        case "recovered":
            self.allCountries = allCountries.sorted(by: { $0.recovered > $1.recovered })

        case "death":
            self.allCountries = allCountries.sorted(by: { $0.deaths > $1.deaths })

        default:
            self.allCountries = allCountries.sorted(by: { $0.confirmed > $1.confirmed })
        }

        self.tableView.reloadData()

    }
    
    //MARK: - Helpers
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }

    private func emptyTextField() {
        searchTextField.text = ""
    }

    private func disableSearchButton() {
        goButtonOutlet.isEnabled = false
        goButtonOutlet.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    
    private func showSearchField() {
        disableSearchButton()
        emptyTextField()
        animateSearchOptionsIn()
    }

    @objc func textFieldDidChange (_ textField: UITextField) {
        
        goButtonOutlet.isEnabled = textField.text != ""
        
        if goButtonOutlet.isEnabled {
            goButtonOutlet.backgroundColor = UIColor.clear
        } else {
            disableSearchButton()
        }
        
    }

    
    //MARK: - Animations
    
    func showSortPopUpView() {
        UIView.animate(withDuration: 0.3) {
            self.sortPopupView.frame.origin.y = AnimationManager.screenBounds.maxY - (self.sortPopupView.frame.height - 20)
        }

    }
    
    func hideSortPopUpView() {
        UIView.animate(withDuration: 0.3) {
            self.sortPopupView.frame.origin.y = AnimationManager.screenBounds.maxY + 1
        }

    }
    
    private func animateSearchOptionsIn() {
        
        UIView.animate(withDuration: 0.5) {
            self.searchOptionsView.isHidden = !self.searchOptionsView.isHidden
        }
    }


    //MARK: Search
     
     func filteredContentForSearchText(searchText: String) {
         
         filteredCountries = allCountries.filter({ (country) -> Bool in
             
             return country.country.lowercased().contains(searchText.lowercased())
         })
         
         tableView.reloadData()
     }

}

extension AllResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCountries.count : allCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountryTableViewCell
        
        let countryData = isSearching ? filteredCountries[indexPath.row] : allCountries[indexPath.row]
        cell.setupCell(countryData)
        
        return cell
    }

    
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "countryDetailView") as! CountryDetailViewController
        
        vc.countryData = isSearching ? filteredCountries[indexPath.row] : allCountries[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }


}


extension AllResultsViewController : SortPopupMenuControllerDelegate {
    
    func recoveredButtonPressed() {
        updateData(sortBy: "recovered")
        hideSortPopUpView()
        isSortPopUpVisible.toggle()

    }
    
    func confirmedButtonPressed() {
        updateData()
        hideSortPopUpView()
        isSortPopUpVisible.toggle()

    }
    
    func deathButtonPressed() {
        updateData(sortBy: "death")
        hideSortPopUpView()
        isSortPopUpVisible.toggle()

    }
    
    func sortBackgroundTapped() {
        hideSortPopUpView()
        isSortPopUpVisible.toggle()
    }
    
    
}
