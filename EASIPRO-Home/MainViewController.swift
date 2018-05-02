//
//  MainViewController.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/1/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import EASIPRO

class MainViewController: UITableViewController {
    
    
    let smartClient = SMARTManager.shared.client
    
//    var measures : [PROMeasure2]?
    
    var measures = ["PROM Pain Inference",
                    "PROM Pain Depression",
                    "PROMIS Anxiety"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .automatic
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PROMCell", for: indexPath) as! PROMCell
        
        let measure = measures[indexPath.row]
        cell.lblTitle.text = measure
        cell.lblSubtitle.text = "ORDER BY Dr. RAHEEL"
        cell.chartView.points = [50,70,60,85]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func showPatientProfile(_ sender: Any) {
        guard let patient = SMARTManager.shared.patient else {
            print("No patient")
            return
        }
        
        print("show profile")
    }
    
    @IBAction func refreshPage(_ sender: Any) {
        SMARTManager.shared.client.ready { [unowned self] (error) in
            DispatchQueue.main.async {
                SMARTManager.shared.showLoginController(over: self)
            }
        }
    }
}
