//
//  ScheduleViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 9.01.2023.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var data = ["Duman","Pamuk","Pamuk","Şaşkın","Duman"]
    var selectedRows: [IndexPath] = []
    var userViewModel:UserViewModel?
    var petViewModel:[PetViewModel] = []
    var appointmentViewModel:[AppointmentViewModel] = []
    var appointmentId = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        disableCancelBtn()
        getAppointments()
        datePicker.timeZone = NSTimeZone.local
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.flashScrollIndicators()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        disableCancelBtn()
    }
    
    @IBAction func onClickSchedule(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "appointment") as! AppointmentViewController
        vc.petViewModel = self.petViewModel
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func onClickCancelSchedule(_ sender: Any) {
        showQuestionAlert()
    }
    
    func matchResults(){
        for pet in petViewModel{
            for index in appointmentViewModel.indices{
                if pet.id == appointmentViewModel[index].petid{
                    appointmentViewModel[index].name = pet.name
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func getAppointments(){
        if let userId = userViewModel?.id{
            Service.shared.getAppointment(id: userId) { (result,err) in
                if let err = err {
                    print("An error has occurred.", err)
                }else{
                    self.appointmentViewModel = result
                    self.matchResults()
                }
            }
        }
    }
    
    func findPet(name: String) -> Int{
        for pet in petViewModel {
            if pet.name == name, let id = pet.id{
                return id
            }
        }
        return 0
    }
    
    func addAppointment(petId: Int){
        let userId = userViewModel?.id ?? 1
        let petId = petId
        let date = datePicker.date
        let details = "Kullanıcı Randevusu"
        Service.shared.addAppointment(userid: userId, petid: petId, date: date, details: details) { (err) in
            if err == nil{
                self.getAppointments()
            }else{
                self.showAlert(title: "Hata!", message: "Randevu eklerken bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.", actionTitle: "Geri Dön.")
            }
        }
    }
    
    func cancelAppointment(id: String){
        Service.shared.deleteAppointment(id: id) { (err) in
            if err == nil {
                self.getAppointments()
                self.disableCancelBtn()
            }else{
                self.showAlert(title: "Hata!", message: "Randevuyu iptal ederken bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.", actionTitle: "Geri Dön.")
            }
        }
    }
    
    func disableCancelBtn(){
        cancelBtn.alpha = 0.5
        cancelBtn.isEnabled = false
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func enableCancelBtn(){
        cancelBtn.alpha = 1
        cancelBtn.isEnabled = true
        cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize:15)
    }
    
    func prepareUI(){
        scheduleBtn.addCornerRadius()
        scheduleBtn.addDefaultDropShadow()
        
        cancelBtn.addCornerRadius()
        cancelBtn.addDefaultDropShadow()
        
        tableView.addDefaultDropShadow()
        tableView.addCornerRadius()
        
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())
    }
    
    func showQuestionAlert(){
        let refreshAlert = UIAlertController(title: "Emin misiniz?", message: "Bu eylem geri alınamaz.", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (action: UIAlertAction!) in
            self.cancelAppointment(id: self.appointmentId)
            print("cancel schedule")
        }))
        refreshAlert.addAction(UIAlertAction(title: "Hayır", style: .default, handler: { (action: UIAlertAction!) in
            print("don't cancel schedule")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcomingVisitsTableViewCell
        cell.nameLabel.text = appointmentViewModel[indexPath.row].name
        cell.typeLabel.text = appointmentViewModel[indexPath.row].details
        cell.dateLabel.text = appointmentViewModel[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = appointmentViewModel[indexPath.row].id{
            appointmentId = id
        }
        if tableView.indexPathsForSelectedRows != nil{
            enableCancelBtn()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false {
            tableView.deselectRow(at: indexPath, animated: true)
            disableCancelBtn()
            return nil
        }
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        enableCancelBtn()
        return indexPath
    }
    
}

extension ScheduleViewController: appointmentProtocol{
    func sendPetInfo(name: String) {
        let id = findPet(name: name)
        addAppointment(petId: id)
    }
    
}
