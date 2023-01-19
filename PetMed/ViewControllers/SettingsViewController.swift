//
//  SettingsViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 8.01.2023.
//

import UIKit
import MessageUI
import FirebaseFirestore

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    var imagePicker = UIImagePickerController()
    
    var menuItems = ["Bildirimler","Veteriner Bilgileri","Veterinerini Ara","Veterinerine E-posta Gönder"]
    var secondaryMenuItems = ["Sıkça Sorulan Sorular", "Kullanım Şartları", "Gizlilik Politikası"]
    var sectionItems = ["Tercihlerim","İçerik"]
    var sectionImages = ["plus","phone","send"]
    
    var userViewModel:UserViewModel?
    var vet:Vet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePicture()
        profileImg.makeRounded()
        nameLabel.text = userViewModel?.name
        
    }
    
    func didSetProfilePicture(){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "PP")
    }
    
    @IBAction func setPicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImg.image = image
            didSetProfilePicture()
            let str = saveImageToDocumentDirectory(image,"profilepicture")
            print("imagePicker: ", str)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func setProfilePicture(){
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "PP"){
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first
            {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("profilepicture")
                let image    = UIImage(contentsOfFile: imageURL.path)
                // Do whatever you want with the image
                profileImg.image = image
            }
        }
    }
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuItems.count
        }else{
            return secondaryMenuItems.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "cell1") as! SettingsTableViewCell
        let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "cell2") as! SettingsTableViewCell
        let cell3 = self.tableView.dequeueReusableCell(withIdentifier: "cell3") as! SettingsTableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0{
                cell2.secondCellLabel.text = menuItems[indexPath.row]
                return cell2
            }else{
                cell1.firstCellLabel.text = menuItems[indexPath.row]
                cell1.imgView.image = UIImage(named: sectionImages[indexPath.row - 1])
                return cell1
            }
        }else{
            cell3.thirdCellLabel.text = secondaryMenuItems[indexPath.row]
            return cell3
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "content") as! ContentViewController
        switch indexPath{
        case [0,0]:
            break
        case [0,1]:
            if vet == nil{
                showAlert(title: "Hata!", message: "Veteriner bilgilerini alırken bir sorun yaşandı. Lütfen daha sonra tekrar deneyiniz.", actionTitle: "Geri Dön")
            }else{
                vc.labelText = "Veteriner Bilgileri"
                vc.vet = vet
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }

        case [0,2]:
            print("clicked call vet", indexPath.row)
#if targetEnvironment(simulator)
            showAlert(title: "Üzgünüm!", message: "Simülatör'de çağrı yapamazsınız.", actionTitle: "Geri Dön")
#else
            dialNumber(number: "555")
#endif
        case [0,3]:
            print("clicked send email to vet", indexPath.row)
#if targetEnvironment(simulator)
            showAlert(title: "Üzgünüm!", message: "Simülatör'de mail servisini kullanamazsınız.", actionTitle: "Geri Dön")
#else
            sendEmail()
#endif
        default:
            break
        }
        
        if indexPath.section == 1 {
            vc.labelText = secondaryMenuItems[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
