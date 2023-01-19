//
//  Result.swift
//  PetMed
//
//  Created by Ege Girsen on 15.01.2023.
//

import Foundation

struct Result: Codable {
    var id: Int?
    var petid: Int?
    var userid: Int?
    var result: String?
    var status: String?
    var type: String?
    var date: String?
}
