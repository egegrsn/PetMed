//
//  LoadingViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 13.01.2023.
//

import UIKit
import FirebaseFirestore

class LoadingViewController: UIViewController {
    
    var vet:Vet?
    var userViewModel:UserViewModel?
    var petViewModel:[PetViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchVet()
    }
    
    
    func fetchUser(){
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")
        Service.shared.fetchUser(username: username ?? "") { (result,err) in
            if err != nil{
                self.showAlert(title: "Hata!", message: "Kullanıcı bilgilerine ulaşırken bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.", actionTitle: "Tamam")
                return
            }else if let result = result{
                self.userViewModel = result
                self.fetchPets()
                
            }
        }
    }
    
    func fetchVet(){
        Service.shared.fetchVet { (result,err) in
            if err != nil{
                self.fetchUser()
                return
            }else if let result = result{
                self.vet = result
                self.fetchUser()
            }
        }
    }
    
    func fetchPets(){
        let id = userViewModel?.id ?? 0
        Service.shared.getPetData(id: id) { (result, err) in
            if err != nil{
            return
            }
            self.petViewModel = result
            self.redirectToTabBar()
        }
    }
    
    func redirectToTabBar() {
        let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
        tabbarVC.modalPresentationStyle = .fullScreen
        let mainVC = tabbarVC.viewControllers?[0] as! MainViewController
        mainVC.userViewModel = userViewModel
        mainVC.petViewModel = petViewModel
        let scheduleVC = tabbarVC.viewControllers?[1] as! ScheduleViewController
        scheduleVC.userViewModel = userViewModel
        scheduleVC.petViewModel = petViewModel
        let settingsVC = tabbarVC.viewControllers?[2] as! SettingsViewController
        settingsVC.userViewModel = userViewModel
        settingsVC.vet = self.vet
        self.present(tabbarVC, animated: true, completion: nil)
    }

}
