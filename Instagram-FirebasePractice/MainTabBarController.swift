//
//  MainTabBarController.swift
//  Instagram-FirebasePractice
//
//  Created by michael ninh on 1/16/19.
//  Copyright © 2019 michael ninh. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let layout = UICollectionViewFlowLayout()
    let userProfileController = UserProfileController(collectionViewLayout: layout)
    
    let navController = UINavigationController(rootViewController: userProfileController)
    
    navController.tabBarItem.image  = #imageLiteral(resourceName: "profile_selected")
    navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
    
    tabBar.tintColor = .black
    
    viewControllers = [navController, UIViewController()]
  }
}
