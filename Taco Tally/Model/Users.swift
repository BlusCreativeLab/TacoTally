//
//  Users.swift
//  Taco Tally
//
//  Created by Courtland Bluford on 11/27/20.
//

import Foundation
import SwiftUI
import Firebase

struct UserModel :Codable{
    
    var uid : String
    var pic : String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var about : String?
    var tacoCount: Int?
    var hometown: String?
    
}

// Global Refernce

let ref = Firestore.firestore()

func fetchUser(uid: String,completion: @escaping (UserModel) -> ()){
    
    ref.collection("users").document(uid).getDocument { (doc, err) in
        guard let user = doc else{return}
        
        let username = user.data()?["username"] as! String
        let lastName = user.data()?["Last Name"] as! String
        let firstName = user.data()?["First Name"] as! String
        let pic = user.data()?["pic"] as! String
        let bio = user.data()?["about"] as! String
        let hometown = user.data()?["hometown"] as! String
        let uid = user.documentID
        let tacoCount = user.data()?["tacoCount"] as! Int
        
        DispatchQueue.main.async {
            completion(UserModel(uid: uid, pic: pic, username: username, firstName: firstName, lastName: lastName, about: bio, tacoCount: tacoCount, hometown: hometown))
        }
    }
}
