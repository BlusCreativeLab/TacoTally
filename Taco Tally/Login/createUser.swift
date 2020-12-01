//
//  createUser.swift
//  OTP
//
//  Created by Kavsoft on 18/01/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import Foundation
import Firebase

func CreateUser(firstName: String,lastName: String,userName: String,hometown: String,about : String,imagedata : Data,completion : @escaping (Bool)-> Void){
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage().reference()
    
    let uid = Auth.auth().currentUser?.uid
    
    storage.child("profilepics").child(uid!).putData(imagedata, metadata: nil) { (_, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
        
        storage.child("profilepics").child(uid!).downloadURL { (url, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            db.collection("users").document(uid!).setData(
                ["First Name":firstName,
                 "Last Name":lastName,
                "about":about,
                "pic":"\(url!)",
                "username": userName,
                "hometown": hometown,
                "tacoCount": 0,
                "dateCreated": Date(),
                "uid":uid!]
            ) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                completion(true)
                
                UserDefaults.standard.set(true, forKey: "status")
                
                UserDefaults.standard.set(firstName, forKey: "First Name")
                
                UserDefaults.standard.set(uid, forKey: "UID")
                
                UserDefaults.standard.set("\(url!)", forKey: "pic")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                }
            }
        }
    }
}
