//
//  myProfileModel.swift
//  Taco Tally
//
//  Created by Courtland Bluford on 11/28/20.
//

import Foundation
import SwiftUI
import Firebase

class myProfileModel : ObservableObject{
    
    @Published var userInfo = UserModel(uid: "", profileImage: "", username: "", firstName: "", lastName: "", bio: "", tacoCount: 0, hometown: "")
    @AppStorage("current_status") var status = false
    
    // Image Picker For Updating Image...
    @Published var picker = false
    @Published var img_data = Data(count: 0)
    
    // Loading View..
    @Published var isLoading = false
    
    let ref = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    init() {
        
        fetchUser(uid: uid) { (user) in
            self.userInfo = user
        }
    }
    
    
    func logOut(){
        
        // logging out..
        
        try! Auth.auth().signOut()
        status = false
    }
    
    func updateImage(){
        
        isLoading = true
        
        UploadImage(imageData: img_data, path: "pic") { (url) in
            
            self.ref.collection("users").document(self.uid).updateData([
            
                "pic": url,
            ]) { (err) in
                if err != nil{return}
                
                // Updating View..
                self.isLoading = false
                fetchUser(uid: self.uid) { (user) in
                    self.userInfo = user
                }
            }
        }
    }
    
    func updateDetails(field : String){
        
        alertViewB(msg: "Update \(field)") { (txt) in
            
            if txt != ""{
                
                self.updateBio(id: field == "Username" ? "Username" : "about", value: txt)
            }
        }
    }
    
    func updateBio(id: String,value: String){
        
        ref.collection("users").document(uid).updateData([
        
            id: value,
        ]) { (err) in
            
            if err != nil{return}
            
            // refreshing View...
            
            fetchUser(uid: self.uid) { (user) in
                self.userInfo = user
            }
        }
    }
}

