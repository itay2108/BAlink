//
//  AuthViewController.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//


import UIKit
import SnapKit

class MainTabBarController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = tabBarVCs()
        
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setTabBarPreferences()
        
    }
    

    func tabBarVCs() -> [UIViewController] {
        
        let categoryVC = MainNavigationController(rootViewController: CategoryViewController())
                 
        let categoryTabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "list.bullet"), tag: 0)
         categoryVC.tabBarItem = categoryTabBarItem
        
         let favoritesVC = MainNavigationController(rootViewController: FavoritesViewController())
        
        let favouritesTabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart"), tag: 1)
        favouritesTabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        
        favoritesVC.tabBarItem = favouritesTabBarItem

        let tabBarList = [categoryVC, favoritesVC]

        return tabBarList
    }
    
    private func setTabBarPreferences() {
        
        //set tab bar position and size
        increaseTabBarHeight(by: Int(12.0 * heightModifier))
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemWidth = screenWidth / 2.75
        
        //set tab bar corners
        self.tabBar.roundCorners(.topCorners, radius: self.tabBar.frameHeight.percentage(12))
        
        //set tab bar design and properties
        self.tabBar.tintColor = K.colors.accentColor

        self.tabBar.backgroundColor = K.colors.tabBarColor
        self.tabBar.isTranslucent = true
        
    }
    
    private func increaseTabBarHeight(by height: Int) {

        let newTabBarHeight = tabBar.frame.size.height + CGFloat(height)
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight

        tabBar.frame = newFrame
    }

}
