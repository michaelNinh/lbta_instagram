//
//  UserProfileController.swift
//  Instagram-FirebasePractice
//
//  Created by michael ninh on 1/16/19.
//  Copyright © 2019 michael ninh. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    
    navigationItem.title = FIRAuth.auth()?.currentUser?.uid
  
    fetchUser()
  }
  
  fileprivate func fetchUser(){
    
    guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
    
    
//    observeWithSingleEvent means that it will look at the database reference ONLY ONCE. You can modify the db entry, but this will not pick it up.
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//      snapshot.value holds all the data related to UID
      print(snapshot.value ?? "")
//      translate the database into swift format
      guard let dictionary = snapshot.value as? [String: Any] else {return}
//      extract the username using the index
      let username = dictionary["username"] as? String
      self.navigationItem.title = username
      
    }) { (err) in
      print("Failed to fetch user", err)
    }
    
  }
  
}

