//
//  PetViewModel.swift
//  PetMed
//
//  Created by Ege Girsen on 14.01.2023.
//

import Foundation

struct PetViewModel{
    var id: Int?
    var userid: Int?
    var name: String?
    var sex: String?
    var sterile: Bool?
    var birthdate: String?
    var breed: String?
    
    init(results: Pet){
        self.id = results.id ?? 0
        self.userid = results.userid ?? 0
        self.name = results.name ?? ""
        self.sex = results.sex
        self.sterile = results.sterile
        self.birthdate = results.birthdate
        self.breed = results.breed ?? ""
    }
}
