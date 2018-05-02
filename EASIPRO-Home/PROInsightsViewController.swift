//
//  PROInsightsViewController.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/2/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import EASIPRO

class PROInsightsViewController: InsightsController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Insights"
        navigationItem.rightBarButtonItem = nil
    }
}
