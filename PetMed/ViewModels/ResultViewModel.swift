//
//  ResultViewModel.swift
//  PetMed
//
//  Created by Ege Girsen on 15.01.2023.
//

import Foundation


struct ResultViewModel{
    var id: Int?
    var userid: Int?
    var petid: Int?
    var result: String?
    var status: String?
    var type: String?
    var date: String?
    var name: String?
    
    init(results: Result){
        self.id = results.id ?? 0
        self.petid = results.petid ?? 0
        self.userid = results.userid ?? 0
        self.result = results.result ?? ""
        self.status = results.status
        self.type = results.type
        self.date = results.date
        self.name = ""
    }
}
