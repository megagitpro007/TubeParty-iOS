//
//  DateSectionView.swift
//  TubeParty
//
//  Created by iZE Appsynth on 10/8/2565 BE.
//

import UIKit

class DateSectionView: UITableViewHeaderFooterView {

    @IBOutlet private var date: UILabel!
    
    func setupUI() {
        self.backgroundView = UIView()
    }
    
    func configDate(date: String) {
        self.date.text = date
    }
    
}
