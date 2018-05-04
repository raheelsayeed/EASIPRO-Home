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
	
	var data : [[String:Any]]?
	
	

    @IBOutlet weak var btnLogin: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .automatic
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
		loadMeasures()
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
//        return 1
		return self.data?.count ?? 0

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let arr = self.data?[section]["data"] as! [PROMeasure2]
		
		return arr.count
//		return measures?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let status = (self.data![section]["status"] as! String)
		return (status == "due") ? MainViewController.Today() : status.uppercased()

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PROMCell", for: indexPath) as! PROMCell
//        let measure = measures![indexPath.row]
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
        if let p = SMARTManager.shared.patient {
            btnLogin.title = ""
        }
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
		let _title = SMARTManager.shared.patient?.humanName ?? "PRO-Measures"
		self.title = _title
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
