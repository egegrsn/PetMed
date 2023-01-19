//
//  Appointment.swift
//  PetMed
//
//  Created by Ege Girsen on 16.01.2023.
//

import Foundation

struct Appointment: Codable {
    var id: String?
    var petid: Int?
    var userid: Int?
    var details: String?
    var date: String?
}
