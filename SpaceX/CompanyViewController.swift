//
//  CompanyViewController.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/3/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation
import UIKit

class CompanyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items = [Company]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetError()
        
        // Configure table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // Fetch company data
        startSpinner(spin: true)
        SpaceXApiClient.getCompanyInfo() { (company, error) in
            // Hide spinner
            self.startSpinner(spin: false)
            
            if (company == nil || !(error?.isEmpty)!)
            {
                // error message
                DispatchQueue.main.async{
                    self.showError(error: error!)
                }
            }
            else {
                // Show the info
                DispatchQueue.main.async{
                    self.items = [company!]
                    self.tableView.reloadData()
                }
            }
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func resetError(){
        tableView.isHidden = false
    }
    
    func showError(error: String){
        tableView.isHidden = true
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyViewCell", for: indexPath) as! CompanyViewCell
        
        let company = self.items[indexPath.row]
        cell.title.text = company.title
        cell.summary.text = company.description
        return cell
    }
    
    func startSpinner(spin: Bool){
        DispatchQueue.main.async{
            self.tableView.isHidden = spin
            self.activityIndicator.isHidden = !spin
            if (spin){
                self.activityIndicator.startAnimating()
            }
            else{
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
