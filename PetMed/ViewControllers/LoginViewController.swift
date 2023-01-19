//
//  ViewController.swift
//  PetMed
//
//  Created by Ege Girsen on 7.01.2023.
//

import UIKit
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        usernameTextfield.clearButtonMode = .whileEditing
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func prepareUI(){
        usernameTextfield.addDefaultDropShadow()
        usernameTextfield.addCornerRadius()
        passwordTextfield.addDefaultDropShadow()
        passwordTextfield.addCornerRadius()
        loginBtn.addDefaultDropShadow()
        loginBtn.addCornerRadius()
    }
    
    @IBAction func onClickLoginBtn(_ sender: Any) {
        let username = usernameTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        let defaults = UserDefaults.standard
        if username.count == 0 || password.count == 0 {
            self.showAlert(title: "Hata!", message: "Kullanıcı adı veya şifre boş bırakılamaz. Lütfen tekrar deneyiniz.", actionTitle: "Tamam")
        }else{
            Service.shared.login(username: username, password: password) { (isAuthenticated) in
                if isAuthenticated == true{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "loading") as! LoadingViewController
                    vc.modalPresentationStyle = .fullScreen
                    defaults.set(self.usernameTextfield.text ?? "", forKey: "username")
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.showAlert(title: "Hata!", message: "Kullanıcı adı veya şifreniz yanlış. Lütfen tekrar deneyiniz.", actionTitle: "Tamam")
                }
                
            }
        }
        
    }
    
}

