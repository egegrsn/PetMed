//
//  AppointmentViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 16.01.2023.
//

import UIKit

protocol appointmentProtocol {
    func sendPetInfo(name: String)
}

class AppointmentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var petViewModel:[PetViewModel] = []
    @IBOutlet weak var upperView: UIView!
    var delegate: appointmentProtocol? = nil
    var selectedPet = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.addCornerRadius()
        btn.addDefaultDropShadow()
        upperView.addCornerRadius()
        upperView.addDefaultDropShadow()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.flashScrollIndicators()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onClickBtn(_ sender: Any) {
        if selectedPet == ""{
            showAlert(title: "Üzgünüm!", message: "Evcil hayvanınızı seçmelisiniz.", actionTitle: "Tamam")
        }else{
            self.delegate?.sendPetInfo(name: selectedPet)
            dismiss(animated: false, completion: nil)
        }
        
    }
}


extension AppointmentViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = petViewModel[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let name = petViewModel[indexPath.row].name{
            selectedPet = name
        }
    }

    
}
