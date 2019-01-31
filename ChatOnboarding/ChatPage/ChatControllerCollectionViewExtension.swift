//
//  ChatControllerCollectionViewExtension.swift
//  ChatOnboarding
//
//  Created by Manoj Kumar on 18/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Photos


let REGISTERED_EMAIL_KEY = "registeredEmail"
let REGISTERED_PASSWORD = "registeredPassword"
let REGISTERED_SIGNUP_EMAIL = "signupEmail"
let SIGNUP_PASSWORD = "passwordMatch"
let REGISTERED_SIGNUP_PASSWORD = "signupPassword"
let REGISTERED_SIGNUP_NAME = "signupName"
let REGISTERED_SIGNUP_GENDER = "gender"
let REGISTERED_SIGNUP_DOB = "dob"
let REGISTERED_MOBILE = "mobile"
let REGISTERED_IMAGE = "image"
let str = String()
let fullImageView = UIImageView()
let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))



extension ChatController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count =  dataSource.count
        if currentSuggestion.count > 0 {
            count += 1
        }
        if shouldShowTypingCell {
            count += 1
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if currentSuggestion.count > 0 && indexPath.row == dataSource.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllSuggestionsCell", for: indexPath) as! AllSuggestionsCell
            cell.delegate = self
            cell.populateWith(userSuggestions: currentSuggestion)
            return cell
        }
        else {
            
            if shouldShowTypingCell == true && indexPath.row == dataSource.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypingCell", for: indexPath) as! TypingCell
                cell.activityIndicatorView?.startAnimating()
                return cell
            }
            
            let chatType = dataSource[indexPath.row]
            if chatType.getOriginType() == .bot {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BotCell", for: indexPath) as!
                BotCell
                cell.populateWith(chatType: chatType)
                return cell
            }
            else {
                if chatType == .avatarUploaded {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
                    cell.img.image = chatType.getImage()
                    return cell
                    
                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as!
                UserCell
                cell.populateWith(chatType: chatType)
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is TypingCell {
            (cell as! TypingCell).activityIndicatorView?.stopAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if currentSuggestion.count > 0 && indexPath.row == dataSource.count {
            return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
        }
        else {
            
            if shouldShowTypingCell == true && indexPath.row == dataSource.count {
                return CGSize(width: UIScreen.main.bounds.width, height: 30)
            }
            
            let chatType = dataSource[indexPath.row]
            
            if chatType == .avatarUploaded {
                return CGSize (width: UIScreen.main.bounds.width, height: 270)
            }
            
            let str = chatType.getChatText()
            
            let lbl = UILabel()
            lbl.text = str
            lbl.numberOfLines = 0
            lbl.font = UIFont.systemFont(ofSize: 17)
            
            let size = lbl.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 130, height: CGFloat.infinity))
            
            var minHeight:CGFloat = 50
            
            if chatType == .signupRegisteredDob {
                minHeight = 100
            }
        
            let returnigSize = CGSize(width:UIScreen.main.bounds.width, height: max(size.height + 20, minHeight))
            return returnigSize
        }
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let chat = dataSource[indexPath.row]
        if chat == .avatarUploaded {
        fullImageView.contentMode = .scaleAspectFit
        fullImageView.backgroundColor = UIColor.lightGray
        fullImageView.isUserInteractionEnabled = true
        fullImageView.alpha = 0
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(fullImageView)
        fullImageView.addSubview(button)
        let cell = collectionView.cellForItem(at: indexPath) as! AvatarCell
        if let image = cell.img.image {
            self.showFullImage(of: image)
            }
            }
    }
    @objc func buttonClicked() {
        fullImageView.alpha = 0
        fullImageView.removeFromSuperview()
    }
    
    override func viewWillLayoutSubviews() {
        
            super.viewWillLayoutSubviews()
            fullImageView.frame = chatCollectionView.frame
        }
    func showFullImage(of image:UIImage) {
        fullImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        fullImageView.contentMode = .scaleAspectFit
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:{
            fullImageView.image = image
            fullImageView.alpha = 1
            fullImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    }




extension ChatController : AllSuggestionsCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didSelectSuggestion(suggestion: ChatType) {
        if suggestion == .male || suggestion == .female {
            UserDefaults.standard.set((suggestion.getChatText()), forKey: REGISTERED_SIGNUP_GENDER)
            dataSource.append(suggestion)
            processLastChat()
        }
        else if suggestion == .fromGallery {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                showPhotos(suggestion: suggestion)
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        self.showPhotos(suggestion: suggestion)
                    }
                    else {
                        //go to next step
                    }
                }
                break
            default:
                let alertController = UIAlertController.init(title: "Chat Bot App", message: "Looks like you have to give us permission from your device's settings", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
                alertController.addAction(settingsAction)
                
                present(alertController, animated: true, completion: nil)
                break
            }
            
        }
        else if suggestion == .useCamera {
            showPhotos(suggestion: suggestion)
        }
        else if suggestion == .viewTerms {
           setupWebView()
        }
        else {
        dataSource.append(suggestion)
        processLastChat()
        }
    }

    func showPhotos(suggestion : ChatType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        if suggestion == .fromGallery {
        imagePickerController.sourceType = .photoLibrary
        }
        else if suggestion == .useCamera {
        imagePickerController.sourceType = .camera
        imagePickerController.cameraCaptureMode = .photo
        }
        imagePickerController.modalPresentationStyle = .fullScreen
       
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let imageChosen = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if let resizedImage = imageChosen.resized(toWidth: 250) {
                let img = resizedImage.pngData()
                UserDefaults.standard.set(img, forKey: REGISTERED_IMAGE)
                dataSource.append(.avatarUploaded)
                processLastChat()
            }
        }
    }
}

extension ChatController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let chatType = dataSource.last
        if chatType == .mobile || chatType == .wrongMobile {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if chatType == .signupName || chatType == .wrongSignupName {
            let maxLength = 50
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtField.resignFirstResponder()
        
        let chatType = dataSource.last
        if chatType == .signinEmail || chatType == .wrongSignInEmail {
            if (txtField.text ?? "").isEmail {
                UserDefaults.standard.set((txtField.text ?? ""), forKey: REGISTERED_EMAIL_KEY)
                dataSource.append(.signinRegisteredEmail)
                txtField.text = ""
                processLastChat()
            }
            else {
                dataSource.append(.wrongSignInEmail)
                processLastChat()
            }
        }
        if chatType == .signupEmail || chatType == .wrongSignupEmail {
            if (txtField.text ?? "").isEmail{
                UserDefaults.standard.set((txtField.text ?? ""), forKey: REGISTERED_SIGNUP_EMAIL)
                dataSource.append(.signupRegisteredEmail)
                txtField.text = ""
                processLastChat()
            }
            else {
                dataSource.append(.wrongSignupEmail)
                processLastChat()
            }
        }
        if chatType == .signinPassword || chatType == .signinEmojiPassword || chatType == .signinInvalidPassword {
            if (txtField.text ?? "").count < 6 {
                dataSource.append(.signinInvalidPassword)
                processLastChat()
            }
            else if (txtField.text ?? "").containsEmoji {
                dataSource.append(.signinEmojiPassword)
                processLastChat()
            }
            else {
                UserDefaults.standard.set((txtField.text ?? ""), forKey: REGISTERED_PASSWORD)
                dataSource.append(.signinRegisteredPassword)
                txtField.text = ""
                processLastChat()
                
            }
        }
        if chatType == .signupPassword || chatType == .signupEmojiPassword || chatType == .signupInvalidPassword {
            let whitespace = NSCharacterSet.whitespaces
            let txt = (txtField.text ?? "")
            let range = txt.rangeOfCharacter(from: whitespace)
            if (txtField.text ?? "").count < 6 {
                dataSource.append(.signupInvalidPassword)
                processLastChat()
            }
            else  if (txtField.text ?? "").containsEmoji {
                dataSource.append(.signupEmojiPassword)
                processLastChat()
            }
            else if range != nil {
                dataSource.append(.signupInvalidPassword)
                processLastChat()
            }

            else {
                UserDefaults.standard.set((txtField.text ?? ""), forKey: SIGNUP_PASSWORD)
                dataSource.append(.passwordToMatch)
                txtField.text = ""
                processLastChat()
        }
      
    }
        if chatType == .confirmPassword || chatType == .wrongConfirmPassword || chatType == .afterPassword
        {
            let text = (txtField.text ?? "")
            let firstPassword = UserDefaults.standard.value(forKey: SIGNUP_PASSWORD) as! String
            if (str.checkIfBothAreSame(firstString: firstPassword, otherString: text)) {
                UserDefaults.standard.set((txtField.text ?? ""), forKey: REGISTERED_SIGNUP_PASSWORD)
                dataSource.append(.signupRegisteredPassword)
                txtField.text = ""
                processLastChat()
            }
            else {
                dataSource.append(.wrongConfirmPassword)
                processLastChat()
            }
            
        }
        if chatType == .signupName || chatType == .wrongSignupName {
            if (txtField.text ?? "").isName {
                UserDefaults.standard.set((txtField.text ?? ""), forKey: REGISTERED_SIGNUP_NAME)
                dataSource.append(.signupRegisteredName)
                txtField.text = ""
                processLastChat()
            }
            else if (txtField.text ?? "").count < 5 {
                dataSource.append(.wrongSignupName)
                processLastChat()
            }
            else  {
                dataSource.append(.wrongSignupName)
                processLastChat()
            }

        }

 return true
    }
    
}


