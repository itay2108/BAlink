//
//  AuthViewController.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//


import UIKit

class HiddenNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .white
        self.modalPresentationStyle = .fullScreen
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }

    
    
}

