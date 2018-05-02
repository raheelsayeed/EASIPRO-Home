//
//  PROMCell.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/2/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import EASIPRO

class PROMCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(for measure: PROMeasure2) {
        lblTitle.text = measure.title
    }

}
