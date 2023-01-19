//
//  TabBarController.swift
//  PetMed
//
//  Created by Ege Girsen on 7.01.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabBar()
        tabBar.addShadow(opacity: 0.25, shadowRadius: 5)
    }
    
    func prepareTabBar(){
        let color = UIColor(rgb: 0xFF9500)
        tabBar.unselectedItemTintColor = color
        tabBar.tintColor = color
    }

}
