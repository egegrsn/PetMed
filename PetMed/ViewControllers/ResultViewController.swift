//
//  ResultViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 14.01.2023.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var labelText: String = "label"
    var sender: Int = 101
    var vacViewModel:[VaccinationViewModel] = []
    var resViewModel:[ResultViewModel] = []
    var examViewModel:[ExaminationViewModel] = []
    var petViewModel:[PetViewModel] = []
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = labelText
        prepareUI()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.flashScrollIndicators()
    }
    
    func matchRes(){
        for pet in petViewModel{
            for index in resViewModel.indices{
                if pet.id == resViewModel[index].petid{
                    resViewModel[index].name = pet.name
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func matchVac(){
        for index in vacViewModel.indices{
            for pet in petViewModel{
                if pet.id == vacViewModel[index].petid{
                    vacViewModel[index].name = pet.name
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func matchVac2(){
        for index in vacViewModel.indices{
            for pet in petViewModel{
                if pet.id == vacViewModel[index].petid{
                    vacViewModel[index].name = pet.name
                }
            }
        }
        self.tableView.reloadData()
        self.getExamData()
    }
    
    func matchExam(){
        for index in examViewModel.indices{
            for vac in vacViewModel{
                if vac.petid == examViewModel[index].petid{
                    examViewModel[index].name = vac.name
                    examViewModel[index].vacName = vac.name
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func fetchData(){
        switch sender{
        case 101:
            getVaccinationData()
        case 102,103:
            getResultData()
        case 104:
            getVaccinationData2()
        default:
            break
        }
        tableView.reloadData()
    }
    
    func prepareUI(){
        tableView.addDefaultDropShadow()
        tableView.addCornerRadius()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func getVaccinationData(){
        let id = userId
        Service.shared.getVaccinationData(id: id) { (result, err) in
            if err != nil{
            return
            }
            self.vacViewModel = result
            self.matchVac()
        }
    }
    
    func getVaccinationData2(){
        let id = userId
        Service.shared.getVaccinationData(id: id) { (result, err) in
            if err != nil{
            return
            }
            self.vacViewModel = result
            self.matchVac2()
        }
    }
    
    func getResultData(){
        let id = userId
        let type = sender == 102 ? "lab" : "pacs"
        Service.shared.getResultData(id: id,type: type) { (result, err) in
            if err != nil{
            return
            }
            self.resViewModel = result
            self.matchRes()
        }
    }
    
    func getExamData(){
        let id = userId
        Service.shared.getExamData(id: id) { (result, err) in
            if err != nil{
            return
            }
            self.examViewModel = result
            self.matchExam()
        }
    }
    
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension ResultViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sender{
        case 101:
            return vacViewModel.count
        case 102,103:
            return resViewModel.count
        case 104:
            return examViewModel.count
        default:
            break
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultTableViewCell
        switch sender{
        case 101:
            cell.nameLabel.text = vacViewModel[indexPath.row].name
            
            if let type = vacViewModel[indexPath.row].type{
                cell.typeLabel.text = "Tip: " + type
            }
            if let pdate = vacViewModel[indexPath.row].plannedDate{
                cell.dateLabel.text = "Tarih: " + pdate
            }
            if let period = vacViewModel[indexPath.row].period{
                cell.resultLabel.text = "Periyot: " + period
            }
            if let status = vacViewModel[indexPath.row].status{
                cell.statusLabel.text = "Durum: " + status
            }
        case 102,103:
            cell.nameLabel.text = resViewModel[indexPath.row].name
            
            if let type  = resViewModel[indexPath.row].type{
                cell.typeLabel.text = "Tip: " + type
            }
            if let date  = resViewModel[indexPath.row].date{
                cell.dateLabel.text = "Tarih: " + date
            }
            if let result  = resViewModel[indexPath.row].result{
                cell.resultLabel.text = "Sonuç: " + result
            }
            if let status  = resViewModel[indexPath.row].status{
                cell.statusLabel.text = "Durum: " + status
            }
        case 104:
            cell.nameLabel.text = examViewModel[indexPath.row].name
            
            if let info  = examViewModel[indexPath.row].info{
                cell.typeLabel.text = "Durum: " + info
            }
            if let medicine  = examViewModel[indexPath.row].medicine{
                cell.dateLabel.text = "İlaç: " + medicine
            }
            if let controldate  = examViewModel[indexPath.row].controldate{
                cell.resultLabel.text = "Kontrol Tarihi: " + controldate
            }
            if let date  = examViewModel[indexPath.row].date{
                cell.statusLabel.text = "Muayene Tarihi: " + date
            }
        default:
            break
        }
        return cell
    }

    
}
