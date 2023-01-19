//
//  PetDetailViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 16.01.2023.
//

import UIKit
import CoreImage

protocol petDetailProtocol{
    func reloadTableView()
}

class PetDetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var sterileLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var image: String?
    var imagePicker = UIImagePickerController()
    var petViewModel: PetViewModel?
    var delegate: petDetailProtocol? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    @IBAction func onClickAddPicture(_ sender: Any) {
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
            let img = image.resized(target: CGSize(width: 300, height: 300))
            imgView.image = img
            if let id = petViewModel?.id {
            let str = saveImageToDocumentDirectory(image,"\(id)")
            self.delegate?.reloadTableView()
            print("deneme imagePicker:", str)
            }
            
        }
    }
    
    func prepareUI(){
        imgView.makeRounded()
        
        if let id = petViewModel?.id{
            let img = loadImageWithPath(path: "\(id)")
            if img != nil{
                imgView.image = img
            }
        }
        if let name = petViewModel?.name{
            nameLabel.text = name
        }
        if let breed = petViewModel?.breed{
            breedLabel.text = "Tür: " + breed
        }
        if let sex = petViewModel?.sex{
            sexLabel.text = "Cinsiyet: " + sex
        }
        if let sterile = petViewModel?.sterile{
            let text = sterile ? "Evet" : "Hayır"
            sterileLabel.text = "Kısır: " + text
        }
        if let date = petViewModel?.birthdate{
            dateLabel.text = "Tarih: " + date
        }
    }
    
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
