//
//  Service.swift
//  PetMed
//
//  Created by Ege Girsen on 14.01.2023.
//

import Foundation
import FirebaseFirestore

class Service{
    static let shared = Service()
    let db = Firestore.firestore()
    
    
    var petViewModel: [PetViewModel] = []
    var vacViewModel: [VaccinationViewModel] = []
    var resViewModel: [ResultViewModel] = []
    var examViewModel: [ExaminationViewModel] = []
    var appointmentViewModel: [AppointmentViewModel] = []
    
    func login(username: String,password: String,completion: @escaping (Bool) -> Void){
        db.collection("user").whereField("username", isEqualTo: username).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("login: Error getting documents: \(err)")
                completion(false)
            } else {
                for document in querySnapshot!.documents {
                        if document["password"] as? String == password{
                            completion(true)
                        }else{
                            completion(false)
                        }
                }
                completion(false)
            }
        }
    }
    
    func fetchUser(username: String,completion: @escaping (UserViewModel?, Error?) -> Void){
        db.collection("user").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("fetchUser: Error getting documents: \(err)")
                completion(nil,err)
            } else {
                for document in querySnapshot!.documents {
                    if document["username"] as? String == username {
                        let name = document["name"] as? String
                        let email = document["email"] as? String
                        let id = document["id"] as? Int
                        let phone = document["phone"] as? Int
                        let username = document["username"] as? String
                        let user = User(name: name, email: email, id: id, phone: phone, username: username)
                        let userViewModel = UserViewModel(results: user)
                        completion(userViewModel,nil)
                    }
                }
                completion(nil,nil)
            }
        }
    }
    
    func getPetData(id: Int,completion: @escaping ([PetViewModel], Error?) -> Void){
        petViewModel = []
        db.collection("pet").whereField("userid", isEqualTo: id).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("getPetData: Error getting documents: \(err)")
                completion([], err)
            } else {
                for document in querySnapshot!.documents {
                    let id = document["id"] as? Int
                    let userid = document["userid"] as? Int
                    let name = document["name"] as? String
                    let sex = document["sex"] as? String
                    let sterile = document["sterile"] as? Bool
                    var date = ""
                    if let birthdate = document["birthdate"] as? Timestamp {
                        let dateValue = birthdate.dateValue()
                        date = self.formatDate(date: dateValue)
                    }
                    let breed = document["breed"] as? String
                    let pet = Pet(id: id, userid: userid, name: name, sex: sex, sterile: sterile, birthdate: date, breed: breed)
                    let petViewModel = PetViewModel.init(results: pet)
                    self.petViewModel.append(petViewModel)
                }
                completion(self.petViewModel, nil)
            }
        }
    }
    
    func fetchVet(completion: @escaping (Vet?, Error?) -> Void){
        db.collection("vet").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("fetchVet: Error getting documents: \(err)")
                completion(nil,err)
            } else {
                for document in querySnapshot!.documents {
                        let name = document["name"] as? String
                        let email = document["email"] as? String
                        let address = document["address"] as? String
                        let phone = document["phone"] as? Int
                        let vet = Vet(name: name, email: email, address: address, phone: phone)
                        completion(vet,nil)
                    
                }
                completion(nil,nil)
            }
        }
    }
    
    func getVaccinationData(id: Int,completion: @escaping ([VaccinationViewModel], Error?) -> Void){
        vacViewModel = []
        db.collection("vaccination").whereField("userid", isEqualTo: id).order(by: "planneddate", descending: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("getVaccinationData: Error getting documents: \(err)")
                completion([], err)
            } else {
                for document in querySnapshot!.documents {
                    let id = document["id"] as? String
                    let userid = document["userid"] as? Int
                    let examid = document["examinationid"] as? String
                    let petid = document["petid"] as? Int
                    let period = document["period"] as? String
                    let status = document["status"] as? String
                    var plannedDate = ""
                    if let timestamp = document["planneddate"] as? Timestamp {
                        let date = timestamp.dateValue()
                        plannedDate = self.formatDate(date: date)
                    }
                    let type = document["type"] as? String
                
                    let vac = Vaccination(id: id, examinationid: examid, userid: userid, petid: petid, period: period, status: status, type: type, plannedDate: plannedDate)
                    let vacViewModel = VaccinationViewModel.init(results: vac)
                    self.vacViewModel.append(vacViewModel)
                    
                }
                completion(self.vacViewModel, nil)
            }
        }
    }
    
    func getResultData(id: Int,type: String,completion: @escaping ([ResultViewModel], Error?) -> Void){
        resViewModel = []
        db.collection(type).whereField("userid", isEqualTo: id).order(by: "date", descending: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([], err)
            } else {
                for document in querySnapshot!.documents {
                    let id = document["id"] as? Int
                    let userid = document["userid"] as? Int
                    let petid = document["petid"] as? Int
                    let result = document["result"] as? String
                    let status = document["status"] as? String
                    var resDate = ""
                    if let timestamp = document["date"] as? Timestamp {
                        let date = timestamp.dateValue()
                        resDate = self.formatDate(date: date)
                    }
                    let type = document["type"] as? String
                
                    let res = Result(id: id, petid: petid, userid: userid, result: result, status: status, type: type, date: resDate)
                    let resViewModel = ResultViewModel(results: res)
                    self.resViewModel.append(resViewModel)
                    
                }
                completion(self.resViewModel, nil)
            }
        }
    }
    
    func getExamData(id: Int,completion: @escaping ([ExaminationViewModel], Error?) -> Void){
        examViewModel = []
        db.collection("examination").whereField("userid", isEqualTo: id).order(by: "date", descending: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([], err)
            } else {
                for document in querySnapshot!.documents {
                    let id = document["id"] as? Int
                    let vacid = document["vaccinationid"] as? String
                    let userid = document["userid"] as? Int
                    let petid = document["petid"] as? Int
                    let medicine = document["medicine"] as? String
                    let info = document["info"] as? String
                    var resDate = ""
                    if let timestamp = document["date"] as? Timestamp {
                        let date = timestamp.dateValue()
                        resDate = self.formatDate(date: date)
                    }
                    var resDate2 = ""
                    if let timestamp = document["controldate"] as? Timestamp {
                        let date = timestamp.dateValue()
                        resDate2 = self.formatDate(date: date)
                    }
                
                    let exam = Examination(id: id, petid: petid, userid: userid, vacid: vacid, info: info, medicine: medicine, date: resDate, controldate: resDate2)
                    let examViewModel = ExaminationViewModel(results: exam)
                    self.examViewModel.append(examViewModel)
                    
                }
                completion(self.examViewModel, nil)
            }
        }
    }
    
    func getAppointment(id: Int, completion: @escaping ([AppointmentViewModel], Error?) -> Void){
        appointmentViewModel = []
        db.collection("appointment").whereField("userid", isEqualTo: id).order(by: "date").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([], err)
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let userid = document["userid"] as? Int
                    let petid = document["petid"] as? Int
                    let details = document["details"] as? String
                    var resDate = ""
                    if let timestamp = document["date"] as? Timestamp {
                        let date = timestamp.dateValue()
                        resDate = self.formatDate(date: date)
                    }
                    let res = Appointment(id: id, petid: petid, userid: userid, details: details, date: resDate)
                    let appointmentViewModel = AppointmentViewModel(results: res)
                    self.appointmentViewModel.append(appointmentViewModel)
                    
                }
                completion(self.appointmentViewModel, nil)
            }
        }
    }
    
    func addAppointment(userid: Int,petid: Int,date: Date,details: String, completion: @escaping (Error?) -> Void){
        let collectionReference = db.collection("appointment")
        let timestamp = Timestamp(date: date)

        let data: [String: Any] = ["date": timestamp,
                                   "details": details,
                                   "petid": petid,
                                   "userid": userid,
        ]

        collectionReference.addDocument(data: data) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                completion(error)
            } else {
                print("Document added successfully")
                completion(nil)
            }
        }
    }
    
    func deleteAppointment(id: String, completion: @escaping (Error?) -> Void){
        let collectionReference = db.collection("appointment")
        
        let documentRef = collectionReference.document(id)
        documentRef.delete { (error) in
            if let error = error {
                print("Error removing document: \(error)")
                completion(error)
            } else {
                print("Document successfully removed!")
                completion(nil)
            }
        }
    }
    
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func addExamination(){
        let date = Date()
        let collectionReference = db.collection("examination")
        let timestamp = Timestamp(date: date)

        let data: [String: Any] = ["date": timestamp,
                                   "controldate": timestamp,
                                   "petid": 1,
                                   "userid": 1,
                                   "id": 1,
                                   "medicine": "malt",
                                   "info": "kusma"
        ]

        collectionReference.addDocument(data: data) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    
    func addVaccination(){
        let date = Date()
        let collectionReference = db.collection("vaccination")
        let timestamp = Timestamp(date: date)

        let data: [String: Any] = ["examinationid": 2,
                                   "planneddate": timestamp,
                                   "petid": 1,
                                   "userid": 1,
                                   "id": 1,
                                   "status": "Yapıldı",
                                   "type": "Mide",
                                   "period": "Yok"
        ]

        collectionReference.addDocument(data: data) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    func addPet(){
        let date = Date()
        let collectionReference = db.collection("pet")
        let timestamp = Timestamp(date: date)

        let data: [String: Any] = ["breed": "Tekir",
                                   "birthdate": timestamp,
                                   "userid": 2,
                                   "id": 7,
                                   "sex": "Erkek",
                                   "sterile": true,
                                   "name": "Badem"
        ]

        collectionReference.addDocument(data: data) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }


    func addResult(type: String){ // lab or pacs
        let date = Date()
        let collectionReference = db.collection(type)
        let timestamp = Timestamp(date: date)

        let data: [String: Any] = [
                                   "date": timestamp,
                                   "petid": 3,
                                   "userid": 1,
                                   "id": 1,
                                   "status": "Sonuç çıktı",
                                   "type": "İdrar Tahlili",
                                   "result": "Tedavi Gerekli"
        ]

        collectionReference.addDocument(data: data) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }

}
