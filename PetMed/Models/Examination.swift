//
//  Examination.swift
//  PetMed
//
//  Created by Ege Girsen on 16.01.2023.
//

import Foundation

struct Examination: Codable {
    var id: Int?
    var petid: Int?
    var userid: Int?
    var vacid: String?
    var info: String?
    var medicine: String?
    var date: String?
    var controldate: String?
}
