//
//  ProfileTab.swift
//  Taco Tally
//
//  Created by Courtland Bluford on 11/27/20.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct ProfileView: View {

    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @StateObject var myProfileData = myProfileModel()
    let images = ["pic1", "pic2", "header", "pic1", "pic2", "header"]
    @State var myTacos = 0
    let ref = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
        VStack{

            VStack {
                ZStack {
                    if myProfileData.userInfo.profileImage != ""{
                        
                        ZStack{
                            
                            WebImage(url: URL(string: myProfileData.userInfo.profileImage)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 350, alignment: .top)
//                                .clipShape(Circle())
                            
                            if myProfileData.isLoading{
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("blue")))
                            }
                        }
//                        .padding(.top,25)
                        .edgesIgnoringSafeArea(.top)
                        .onTapGesture {
                            myProfileData.picker.toggle()
                        }
                    }
                    VStack {
                        HStack {
//                            Button(action: {}, label: {
//                                Image(systemName: "arrow.turn.right.up")
//                                    .rotationEffect(Angle.degrees(-90))
//                                    .frame(width: 50, height: 50)
//                                    .background(Color.white)
//                                    .foregroundColor(Color(.blue))
//                                    .clipShape(Circle())
//                            })
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                
                            Button(action: {myProfileData.picker.toggle()}, label: {
                            
                                Image(systemName: "camera")
                                    .frame(width: 50, height: 50)
                                    .background(Color.orange)
                                    .foregroundColor(Color(.white))
                                    .padding(1)
                                
                                
                            }).background(Color.orange)
                            .clipShape(Circle())
                            
                                
                            Button(action: {myProfileData.updateDetails(field: "Username")}, label: {
                                
                                Image(systemName: "person")
                                    .frame(width: 50, height: 50)
                                    .background(Color.orange)
                                    .foregroundColor(Color(.white))
                                    .padding(1)
                                
                            }).background(Color.orange)
                            .clipShape(Circle())
                                
                            Button(action: {myProfileData.updateDetails(field: "Bio")}, label: {
                                
                                Image(systemName: "text.justify")
                                    .frame(width: 50, height: 50)
                                    .background(Color.orange)
                                    .foregroundColor(Color(.white))
                                    .padding(1)
                                
                            }).background(Color.orange)
                            .clipShape(Circle())
                                
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                }
                .frame(width: UIScreen.main.bounds.width, height: 350)
                
               
                VStack {
                    VStack(alignment: .leading) {
                        
                        Button(action: {myProfileData.updateDetails(field: "Username")}) {
                            Text(myProfileData.userInfo.username)
                                    .font(.system(size: 42, design: .serif))
                                    .foregroundColor(Color(.black))
                                    .padding(.top, 20)
                        }.padding(.top, 10)
                        
                        Divider()
                        
                        HStack(alignment: .top) {
                            Image(systemName: "paperplane")
                                .foregroundColor(Color(.black))
                            
                            VStack(alignment: .leading) {
                                Text(myProfileData.userInfo.hometown)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color(.black))
                                
                                Text("\(myProfileData.userInfo.firstName) " + "\(myProfileData.userInfo.lastName)")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color(.black))
                            }
                            .padding(.leading)
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Image(systemName: "rosette")
                                .foregroundColor(Color(.black))
                            
                            Text("Tacos:")
                                .font(.system(size: 17))
                                .foregroundColor(Color(.black))
                                .padding(.leading)
                            
                            Text("\(myTacos.roundedWithAbbreviations)")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(Color(.black))
                        }
                        .padding(.top, 20)
                        
                        Divider()
                            .padding(.top)
                        
                        Button(action: {myProfileData.updateDetails(field: "Bio")}) {
                            
                            Text(myProfileData.userInfo.bio)
                                .font(.system(size: 17))
                                .foregroundColor(Color(.black))
                                .padding(.top)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            ForEach(0 ..< images.count) { i in
//                                Image(images[i])
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 120, height: 120)
//                                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .padding(.top)
//                    .padding(.bottom, 20)
                    
                }
                .background(Color.white)
                .padding(.top, 40)
                .cornerRadius(25)
            }
            
            
            // LogOut Button...
            
            Button(action: myProfileData.logOut, label: {
                Text("Logout")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color(.black))
                    .clipShape(Capsule())
            })
            .padding()
            .padding(.top,10)
            
//            Button(action: {
//
//              UserDefaults.standard.set("", forKey: "UserName")
//              UserDefaults.standard.set("", forKey: "UID")
//              UserDefaults.standard.set("", forKey: "pic")
//
//              try! Auth.auth().signOut()
//
//              UserDefaults.standard.set(false, forKey: "status")
//
//              NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
//
//            }, label: {
//
//                Text("Sign Out")
//            })
            
            Spacer(minLength: 0)
        }
        .sheet(isPresented: $myProfileData.picker) {
         
            ImagePicker(picker: $myProfileData.picker, imagedata: $myProfileData.img_data)
        }
        .onChange(of: myProfileData.img_data) { (newData) in
            // whenever image is selected update image in Firebase...
            myProfileData.updateImage()
        }
        .padding(.bottom, 150)
        }.onAppear {
            updateTacoCount()
        }
        
    }
    
    func updateTacoCount() {
        
        ref.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
                guard let data = document.data() else {
                print("Document data was empty.")
                    return
              }
            self.myTacos = data["tacoCount"] as? Int ?? 0
                print("Current data: \(myTacos)")
            }
    }
}
