//
//  MainViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 7.01.2023.
//

import UIKit
import FirebaseFirestore

class MainViewController: UIViewController, petDetailProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vacScheduleBtn: UIButton!
    @IBOutlet weak var labResBtn: UIButton!
    @IBOutlet weak var pacResBtn: UIButton!
    @IBOutlet weak var examBtn: UIButton!
    
    let dataImg = ["cat1", "cat2", "cat3","cat1", "cat2", "cat3","cat1", "cat2", "cat3","cat1", "cat2", "cat3"]
    var userViewModel:UserViewModel?
    var petViewModel:[PetViewModel] = []
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        vacScheduleBtn.tag = 101
        labResBtn.tag = 102
        pacResBtn.tag = 103
        examBtn.tag = 104
        refreshControl.addTarget(self, action: #selector(scrollToUpdatePets), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.flashScrollIndicators()
    }
    
    @objc func scrollToUpdatePets(refreshControl: UIRefreshControl) {
        fetchPets()
    }

    @IBAction func onClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "result") as! ResultViewController
        switch sender.tag{
        case 101:
            vc.labelText = "Aşı Takvimi"
            vc.sender = 101
        case 102:
            vc.labelText = "Lab Sonuçları"
            vc.sender = 102
        case 103:
            vc.labelText = "Pacs Sonuçları"
            vc.sender = 103
        case 104:
            vc.labelText = "Muayene Geçmişi"
            vc.sender = 104
        default:
            break
        }
        vc.petViewModel = petViewModel
        vc.userId = userViewModel?.id ?? 0
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func prepareUI(){
        vacScheduleBtn.addCornerRadius()
        vacScheduleBtn.addDefaultDropShadow()
        labResBtn.addCornerRadius()
        labResBtn.addDefaultDropShadow()
        pacResBtn.addCornerRadius()
        pacResBtn.addDefaultDropShadow()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func fetchPets(){
        let id = userViewModel?.id ?? 0
        Service.shared.getPetData(id: id) { (result, err) in
            if err != nil{
                self.refreshControl.endRefreshing()
                return
            }
            self.petViewModel = result
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PetsTableViewCell
        cell.label.text = petViewModel[indexPath.row].name
        if let id = petViewModel[indexPath.row].id{
            let img = loadImageWithPath(path: "\(id)")
            if img != nil{
                cell.imgView.image = img
            }else{
                cell.imgView.image = UIImage(named: "default")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "petdetail") as! PetDetailViewController
        vc.petViewModel = self.petViewModel[indexPath.row]
        vc.image = dataImg[indexPath.row]
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
