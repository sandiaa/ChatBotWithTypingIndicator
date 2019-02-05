//
//  UserManager.swift
//  ChatOnboarding
//
//  Created by Sandiaa on 04/02/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserDataManager {
    static let shared = UserDataManager()
    
    var user : [NSManagedObject] = []
    
    private init() {
    }
    //Saves the user's details.
    
    func saveData() {
       
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let registeredName = UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_NAME) as! String
        let registeredEmail = UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_EMAIL) as! String
        let registeredPassword = UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_PASSWORD) as! String
        let registeredGender = UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_GENDER) as! String
        let registeredDob = UserDefaults.standard.value(forKey: REGISTERED_SIGNUP_DOB) as! String
        let registeredPhone = UserDefaults.standard.value(forKey: REGISTERED_MOBILE) as! String
        let registeredPhoto = UserDefaults.standard.value(forKey: REGISTERED_IMAGE) as! Data
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)

        person.setValue(registeredName, forKey: "name")
        person.setValue(registeredEmail, forKey: "email")
        person.setValue(registeredPassword, forKey: "password")
        person.setValue(registeredGender, forKey: "gender")
        person.setValue(registeredDob, forKey: "dob")
        person.setValue(registeredPhone, forKey: "phone")
        person.setValue(registeredPhoto, forKey: "photo")
        do {
            try managedContext.save()
            user.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Checks for an email's existance.
    
    func checkEmail(email : String) -> Bool{
      let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
    
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 1 {
                return true
            }
            else {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
    
    //Checks if the password entered matches with the password saved.
    
    func checkPassword(password : String) -> Bool {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        let email = UserDefaults.standard.value(forKey: REGISTERED_EMAIL_KEY) as! String
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "email = %@ AND password == %@", email,password)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 1 {
                return true
            }
            else {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }

   }


