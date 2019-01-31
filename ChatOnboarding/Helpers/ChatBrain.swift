//
//  ChatBrain.swift
//  ChatOnboarding
//
//  Created by Manoj Kumar on 18/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import Foundation
import UIKit

enum UserInputTypes {
    case suggestion
    case textField
    case picker
    case image
}

enum OriginType {
    case bot
    case user
}

enum ChatType {
    case hi
    case userHi
    case hello
    case intro
    case signin
    case signup
    case signinEmail
    case signinPassword
    case signinRegisteredEmail
    case wrongSignInEmail
    case signinEmojiPassword
    case signinInvalidPassword
    case signinRegisteredPassword
    case doneSignin
    case signupName
    case wrongSignupName
    case signupRegisteredName
    case signupEmail
    case signupRegisteredEmail
    case wrongSignupEmail
    case signupPassword
    case signupEmojiPassword
    case passwordToMatch
    case afterPassword
    case signupInvalidPassword
    case confirmPassword
    case wrongConfirmPassword
    case signupRegisteredPassword
    case signupGender
    case male
    case female
    case mobile
    case wrongMobile
    case registeredMobile
    case signupDob
    case signupRegisteredDob
    case signupWrongDob
    case uploadAvatar
    case skip
    case fromGallery
    case useCamera
    case avatarUploaded
    case acceptToTerms
    case accept
    case viewTerms
    case decline
    case declineSelected
    case okay
    case doneSignup
    case none
    
    func getSuggestions() -> [ChatType]{
        switch self {
        case .hi:
            return [.userHi, .hello]
        case .intro:
            return [.signin, .signup]
        case .signupGender:
            return [.male, .female]
        case .acceptToTerms:
            return [.viewTerms, .accept, .decline]
        case .declineSelected:
            return [.okay, .viewTerms]
        case .uploadAvatar:
            return [.skip, .fromGallery, .useCamera]
        default :
            return []
        }
    }
    
    func getBotResponse() -> ChatType {
        switch self {
        case .userHi, .hello:
            return .intro
        case .signin:
            return .signinEmail
        case .signinRegisteredEmail:
            return .signinPassword
        case .signinRegisteredPassword:
            return .doneSignin
        case .signup:
            return .signupName
        case .signupRegisteredName:
            return .signupEmail
        case .signupRegisteredEmail:
            return .signupPassword
        case .passwordToMatch:
            return .afterPassword
        case .signupRegisteredPassword:
            return .signupGender
        case .female, .male:
            return .mobile
        case .registeredMobile:
            return .signupDob
        case .signupRegisteredDob:
            return .uploadAvatar
        case .skip:
            return .acceptToTerms
        case .fromGallery:
            return .avatarUploaded
        case .useCamera:
            return .avatarUploaded
        case .avatarUploaded:
            return .acceptToTerms
        case .accept:
            return .doneSignup
        case .decline:
            return .declineSelected
        case .okay:
            return .doneSignup
        case .viewTerms:
            return .none
        default:
            return .none
        }
    }
    
    func getTimeDelay()->Double {
        switch self {
        case .intro:
            return 1.0
        case .doneSignin, .doneSignup:
            return 3.0
        case .signupDob,.signupGender:
            return 1.5
        case .avatarUploaded:
            return 1.3
        case .accept:
            return 2.5
        default:
            return 0.0
        }
    }
    
    func getOriginType() -> OriginType{
        switch self {
        case .hi, .intro, .signinEmail, .signinPassword, .wrongSignInEmail, .signinEmojiPassword, .signinInvalidPassword, .signupName,
             .wrongSignupName, .signupEmail, .wrongSignupEmail, .signupPassword, .signupEmojiPassword, .signupInvalidPassword, .signupGender,
             .mobile,.signupDob, .signupWrongDob, .acceptToTerms, .doneSignin, .doneSignup, .wrongMobile,.declineSelected,
             .confirmPassword, .wrongConfirmPassword, .afterPassword,.uploadAvatar:
            return .bot
        default:
            return .user
        }
    }
    
    func getPlaceholderText() -> String {
        switch self {
        case .signinEmail, .wrongSignInEmail, .signupEmail, .wrongSignupEmail:
            return "Enter your email"
        case .signinPassword, .signinEmojiPassword, .signinInvalidPassword,
             .signupPassword, .signupEmojiPassword, .signupInvalidPassword:
            return "Enter your Password"
        case .signupName, .wrongSignupName:
            return "Enter your name"
        default:
            return ""
        }
    }
    
    func getChatText() -> String {
        switch self {
        case .hi :
            return "Hi"
        case .userHi :
            return "Hi"
        case .hello :
            return "Hello"
        case .intro :
            return "I am here to assist you with onboarding. Would you like to signin or signup?"
        case .signin :
            return "Signin"
        case .signup :
            return "Signup"
        case .signinEmail :
            return "Enter your email"
        case .signinRegisteredEmail:
            return UserDefaults.standard.value(forKey: REGISTERED_EMAIL_KEY) as! String
        case .signinPassword:
            return "Enter your password"
        case .wrongSignInEmail:
            return "Please enter a valid Email"
        case .signinInvalidPassword:
            return "Please enter a valid Password with minimum 6 characters"
        case .signinEmojiPassword:
            return "Please enter a password without emoji"
        case .signinRegisteredPassword:
            let password = UserDefaults.standard.value(forKey: REGISTERED_PASSWORD) as! String
            let count = password.count
            var str1 = ""
            for _ in 0 ..<  count {
                str1 = str1 + "*"
            }
            return str1
        case .doneSignin:
            return "You are logged in"
        case .signupName:
            return "Enter your name"
        case .wrongSignupName:
            return "Enter a valid name without special characters, white spaces and must contain atleast 5 letters"
        case .signupRegisteredName:
            return UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_NAME) as! String
        case .signupEmail:
            return "Enter your email"
        case .signupRegisteredEmail:
            return UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_EMAIL) as! String
        case .wrongSignupEmail:
            return "Please enter a valid email"
        case .signupPassword:
            return "Enter your password"
        case .signupEmojiPassword:
            return "Please enter a password without emoji"
        case .signupInvalidPassword:
            return "Please enter a valid password and must contain atleast 6 characters"
        case .passwordToMatch:
            let password = UserDefaults.standard.value(forKey: SIGNUP_PASSWORD) as! String
            let count = password.count
            var str1 = ""
            for _ in 0 ..<  count {
                str1 = str1 + "*"
            }
            return str1
        case .confirmPassword, .afterPassword:
            return "Re enter your password for confirmation"
        case .wrongConfirmPassword:
            return "Password does not match"
        case .signupRegisteredPassword:
            let password = UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_PASSWORD) as! String
            let count = password.count
            var str1 = ""
            for _ in 0 ..<  count {
                str1 = str1 + "*"
            }
            return str1
        case .signupGender:
            return "Choose your gender"
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .mobile:
            return "Enter your mobile number"
        case .wrongMobile:
            return "Please enter a valid mobile number"
        case .registeredMobile:
            return UserDefaults.standard.value(forKey: REGISTERED_MOBILE) as! String
        case .signupDob:
            return "Enter your date of birth"
        case .signupRegisteredDob:
            return  UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_DOB) as! String
        case .signupWrongDob:
            return "Enter a valid date of birth"
        case .uploadAvatar:
            return "Upload Profile Photo"
        case .skip:
            return "Skip"
        case .fromGallery:
            return "From Gallery"
        case .useCamera:
            return "Use Camera"
        case .avatarUploaded:
            return "Done with avatar"
        case .acceptToTerms:
            return "Accept terms to signup"
        case .accept:
            return "Accept"
        case .viewTerms:
            return "View"
        case .okay:
            return "Accept"
        case .decline:
            return "Decline"
        case .declineSelected:
            return "You need to accept to signup"
        case .doneSignup:
            return "Thankyou for signing up"
            
        default :
            return ""
            
        }
    }
    
    func getUserInputType() -> UserInputTypes {
        switch self {
        case .signinEmail, .signinPassword, .wrongSignInEmail, .signinInvalidPassword, .signinEmojiPassword,.signupName, .wrongSignupName, .signupPassword, .signupEmojiPassword, .signupInvalidPassword, .signupEmail, .wrongSignupEmail, .confirmPassword
        , .mobile, .wrongMobile, .signupWrongDob, .wrongConfirmPassword, .afterPassword:
            return .textField
        case .fromGallery, .useCamera:
            return .image
        case .signupDob:
            return .picker
        default :
            return .suggestion
        }
    }
    
    func getKeyboardType() -> UIKeyboardType {
        switch self {
        case .signinEmail, .wrongSignInEmail, .signupEmail, .wrongSignupEmail:
            return .emailAddress
        case .signinPassword, .signinInvalidPassword, .signinEmojiPassword, .signupPassword, .signupInvalidPassword, .signupEmojiPassword, .confirmPassword, .wrongConfirmPassword, .afterPassword:
            return .asciiCapable
        case .mobile, .wrongMobile:
            return .numberPad
        default:
            return .default
        }
    }
    
    func isTextFieldSecure()->Bool {
        if self == .signinPassword || self == .signinInvalidPassword || self == .signinEmojiPassword ||
            self == .signupPassword || self == .signupEmojiPassword || self == .signupInvalidPassword || self == .wrongConfirmPassword ||
            self == .afterPassword{
            return true
        }
        return false
    }
    func modifyText(txt : String) -> NSMutableAttributedString {
        let yearAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let dateAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        let attributedSentence = NSMutableAttributedString(string: txt, attributes: yearAttributes)
        
        attributedSentence.setAttributes(dateAttributes, range: NSRange(location: 0, length: 6))
        return attributedSentence
    }
    func getImage() -> UIImage {
        let image = UserDefaults.standard.value(forKey: REGISTERED_IMAGE)
        let imageView = UIImage(data: image as! Data)
        return imageView!
        
    }
    
    
}
