//
//  VaccinationViewModel.swift
//  PetMed
//
//  Created by Ege Girsen on 15.01.2023.
//

import Foundation


struct VaccinationViewModel{
    var id: String?
    var examinationid: String?
    var userid: Int?
    var petid: Int?
    var period: String?
    var status: String?
    var type: String?
    var plannedDate: String?
    var name: String?
    
    init(results: Vaccination){
        self.id = results.id ?? ""
        self.petid = results.petid ?? 0
        self.examinationid = results.examinationid ?? ""
        self.userid = results.userid ?? 0
        self.period = results.period ?? ""
        self.status = results.status
        self.type = results.type
        self.plannedDate = results.plannedDate
        self.name = ""
        
    }
}
