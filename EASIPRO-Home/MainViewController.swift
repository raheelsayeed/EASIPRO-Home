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
    
	var measures : [PROMeasure2]? {
		didSet {
			self.data = PROMeasure2.SortedPROMs(proms: measures)
		}
	}
	
	var data : [[String:Any]]? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	

    @IBOutlet weak var btnLogin: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.backgroundColor = UIColor.init(red: 0.976, green: 0.976, blue: 0.976, alpha: 1.0)
		weak var weakSelf = self
		SMARTManager.shared.onPatientSelected = {
			DispatchQueue.main.async {
				weakSelf?.loadMeasures()
			}
		}
    }
    class func Today()->String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: Date())
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
		return self.data?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let arr = self.data?[section]["data"] as! [PROMeasure2]
		return arr.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let status = (self.data![section]["status"] as! String)
		return (status == "due") ? MainViewController.Today() : status.uppercased()

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PROMCell", for: indexPath) as! PROMCell
		let prlist = self.data![indexPath.section]["data"] as! [PROMeasure2]
		let assessment = prlist[indexPath.item]
		cell.configure(for: assessment)
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
	
	func reloadOnMain() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	open func loadMeasures() {
		guard let p = SMARTManager.shared.patient else { return }
		markBusy()
		PROMeasure2.fetchPrescribingResources(for: p) { [weak self] (measures, error) in
            self?.measures = measures
            self?.measures?.forEach({ (measure) in
                measure.fetchMeasurementResources(callback: {  (success) in
					self?.data = PROMeasure2.SortedPROMs(proms: self?.measures)
                    if success {
						self?.reloadOnMain()
                    }
                })
            })
			if let error = error {
				print(error.asFHIRError.description as Any)
				
				
			}
			self?.markStandby()

			
		}
		
	}
	open func markBusy() {
		self.title = "Loading.."
	}
	
	
	
	
	open func markStandby() {
		DispatchQueue.main.async {
			let _title = SMARTManager.shared.patient?.humanName ?? "PRO-Measures"
			self.title = _title
			self.tableView.reloadData()
			if SMARTManager.shared.patient != nil {
				self.btnLogin.title = ""
			}
		}
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print(segue)
		if let detailVC = segue.destination as? PROMDetailViewController, segue.identifier == "showDetail" {
			if let ip = tableView.indexPathForSelectedRow {
			let prlist = self.data![ip.section]["data"] as! [PROMeasure2]
			let measure = prlist[ip.item]
			detailVC.measure = measure
			}
		}
	}
}
