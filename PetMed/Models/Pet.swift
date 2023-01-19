//
//  Pet.swift
//  PetMed
//
//  Created by Ege Girsen on 14.01.2023.
//

import Foundation

struct Pet: Codable {
    var id: Int?
    var userid: Int?
    var name: String?
    var sex: String?
    var sterile: Bool?
    var birthdate: String?
    var breed: String?
}
