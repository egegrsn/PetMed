//
//  AppointmentViewModel.swift
//  PetMed
//
//  Created by Ege Girsen on 16.01.2023.
//

import Foundation

struct AppointmentViewModel{
    var id: String?
    var userid: Int?
    var petid: Int?
    var details: String?
    var date: String?
    var name: String?
    
    init(results: Appointment){
        self.id = results.id ?? "0"
        self.petid = results.petid ?? 0
        self.userid = results.userid ?? 0
        self.details = results.details ?? ""
        self.date = results.date
        self.name = ""
    }
}
