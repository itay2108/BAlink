//
//  MainNavigationController.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit


class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.tintColor = .label

        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
    }

}

