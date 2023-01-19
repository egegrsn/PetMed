//
//  Vaccination.swift
//  PetMed
//
//  Created by Ege Girsen on 15.01.2023.
//

import Foundation


struct Vaccination: Codable {
    var id: String?
    var examinationid: String?
    var userid: Int?
    var petid: Int?
    var period: String?
    var status: String?
    var type: String?
    var plannedDate: String?
}
