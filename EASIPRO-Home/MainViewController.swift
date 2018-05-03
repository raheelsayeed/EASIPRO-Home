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
    
    var measures : [PROMeasure2]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .automatic
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
		loadMeasures()
    }
	
	
	// TODO: remove this, used for testing
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measures?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PROMCell", for: indexPath) as! PROMCell
        let measure = measures![indexPath.row]
		cell.configure(for: measure)
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
		loadMeasures()
    }
	
	@IBAction func loginAction(_ sender: Any) {
		SMARTManager.shared.client.ready { [unowned self] (error) in
			DispatchQueue.main.async {
				SMARTManager.shared.showLoginController(over: self)
			}
		}
	}
	open func loadMeasures() {
		if nil != measures { return }
		markBusy()
		PROMeasure2.fetchPrescribingResources { [weak self] (measures, error) in
            self?.measures = measures
            self?.measures?.forEach({ (measure) in
                measure.fetchMeasurementResources(callback: { (success) in
                    if success {
                        DispatchQueue.main.async
                            { self?.tableView.reloadData() }
                    }
                })
            })
			if let error = error {
				print(error as Any)
			}
			DispatchQueue.main.async {
				self?.markStandby()
			}
		}
		
	}
	open func markBusy() {
		self.title = "Loading.."
	}
	
	
	
	
	open func markStandby() {
		self.title = "PRO-Measures"
		self.tableView.reloadData()
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print(segue)
		if let detailVC = segue.destination as? PROMDetailViewController, segue.identifier == "showDetail" {
			let measure = measures![(tableView.indexPathForSelectedRow?.row)!]
			detailVC.measure = measure
		}
	}
}
