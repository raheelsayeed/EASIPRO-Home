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
    
    let upcomingBgColor = UIColor.init(red: 0.976, green: 0.976, blue: 0.976, alpha: 1.0)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblStatus.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(for measure: PROMeasure2) {
        let status = measure.sessionStatus
        let isDue  = status == .due
        lblTitle.text = measure.title
		chartView.points = measure.scores
        lblSubtitle.text = (measure.prescriber != nil) ? "REQUESTED BY \(measure.prescriber!)" : measure.identifier
        lblStatus.text = (isDue) ? status.rawValue : (measure.schedule?.periodString() ?? status.rawValue)
        backgroundColor = (isDue || measure.sessionStatus == .upcoming) ? UIColor.white : upcomingBgColor
    }

}
