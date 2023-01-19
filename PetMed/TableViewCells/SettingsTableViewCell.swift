//
//  SettingsTableViewCell.swift
//  PetMed
//
//  Created by Ege Girsen on 8.01.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var firstCellLabel: UILabel!
    @IBOutlet weak var secondCellLabel: UILabel!
    @IBOutlet weak var thirdCellLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var notiSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notiSwitch?.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        notiSwitch?.isOn = UserDefaults.standard.bool(forKey: "Notification") ? true : false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = notiSwitch.isOn
        print("Notification Switch Value: ", value)
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "Notification") {
            defaults.set(false, forKey: "Notification")
        }else{
            defaults.set(true, forKey: "Notification")
        }
    }

}
