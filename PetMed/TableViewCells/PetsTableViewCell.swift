//
//  PetsTableViewCell.swift
//  PetMed
//
//  Created by Ege Girsen on 8.01.2023.
//

import UIKit

class PetsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        imgView.makeRounded()
    }
}
