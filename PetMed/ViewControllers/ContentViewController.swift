//
//  ContentViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 8.01.2023.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var details: UITextView!
    var labelText: String = "label"
    var vet: Vet?
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelText
        if label.text == "Veteriner Bilgileri", let name = vet?.name, let address = vet?.address, let phone = vet?.phone, let email = vet?.email{
            details.text = "İsim: \(name) \nAdres: \(address) \nTelefon Numarası: \(phone) \nE-mail Adresi: \(email) \n"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
