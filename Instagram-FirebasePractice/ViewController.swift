//
//  ViewController.swift
//  Instagram-FirebasePractice
//
//  Created by michael ninh on 1/12/19.
//  Copyright © 2019 michael ninh. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let plusPhotoButton:UIButton = {
//    this changes the color of the button
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handlePhotoPlus), for: .touchUpInside)
    return button
  }()
  
  @objc func handlePhotoPlus(){
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
//    determine whether or not to use edited or original image
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }

//    makes photo a circle
    plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
    plusPhotoButton.layer.masksToBounds = true
    plusPhotoButton.layer.borderColor = UIColor.black.cgColor
    plusPhotoButton.layer.borderWidth = 3
    
    dismiss(animated: true, completion: nil)
  }
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
//    this is a listener. It pipes data into handleTextInputChange()
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    
    return tf
  }()
  
  @objc func handleTextInputChange(){
    let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
    
    if isFormValid {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    }else{
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
  }
  
  let usernameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Username"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let signUpButton: UIButton =  {
    let button = UIButton(type:.system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = .blue
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  @objc func handleSignUp(){
    
    guard let email = emailTextField.text, email.count > 0 else{ return }
    guard let username = usernameTextField.text, username.count > 0 else{ return }
    guard let password = passwordTextField.text, password.count > 0 else { return }
  
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
      if let err = error {
        print ("There was an error", err)
      }
      
      guard let image = self.plusPhotoButton.imageView?.image else {return}
      
      guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
      
      FIRStorage.storage().reference().child("profile_image").put(uploadData, metadata: nil, completion: { (metadata, err) in
        
        if let err = err{
          print("Failed image upload", err)
          return
        }
        
        guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
        print("successfully uploaded profile image", metadata)
        
      })
      
      
//      let usernameValues = ["username":username]
//      guard let uid = user?.uid else { return }
//      let values = [uid: usernameValues]
//
//      FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
//          if let err = err {
//            print("print to save user info into db", err)
//          }
//          print("made it into db")
//      })
      
      
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(plusPhotoButton)
    
    plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
    plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    view.addSubview(emailTextField)
    
    setupInputFields()
  }
  
//  this is an easy way to set-up several buttons at once
  fileprivate func setupInputFields(){
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 10
    
    
    view.addSubview(stackView)
    
    stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width:0 , height:200)
    
  }

}

extension UIView{
  func anchor(top: NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?,bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
    
    translatesAutoresizingMaskIntoConstraints = false
    
    
    if let top = top{
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = left{
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if let bottom = bottom{
      self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
    }
    
    if let right = right{
      self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
  }
}
