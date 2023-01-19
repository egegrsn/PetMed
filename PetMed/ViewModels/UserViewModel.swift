//
//  UserViewModel.swift
//  PetMed
//
//  Created by Ege Girsen on 14.01.2023.
//

import Foundation

struct UserViewModel{
    var name: String?
    var email: String?
    var id: Int?
    var phone: Int?
    var username: String?
    
    init(results: User){
        self.name = results.name ?? ""
        self.email = results.email ?? ""
        self.id = results.id ?? 0
        self.phone = results.phone ?? 0
        self.username = results.username ?? ""
    }
}
