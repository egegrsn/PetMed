//
//  ExaminationViewModel.swift
//  PetMed
//
//  Created by Ege Girsen on 16.01.2023.
//

import Foundation

struct ExaminationViewModel{
    var id: Int?
    var userid: Int?
    var petid: Int?
    var vacid: String?
    var info: String?
    var medicine: String?
    var date: String?
    var controldate: String?
    var name: String?
    var vacName: String?
    
    init(results: Examination){
        self.id = results.id ?? 0
        self.petid = results.petid ?? 0
        self.userid = results.userid ?? 0
        self.vacid = results.vacid ?? ""
        self.medicine = results.medicine
        self.info = results.info
        self.date = results.date
        self.controldate = results.controldate
        self.name = ""
        self.vacName = ""
    }
}
