//
//  HomeTab.swift
//  Taco Tally
//
//  Created by Courtland Bluford on 11/27/20.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Firebase


struct Home : View {
    
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    @ObservedObject private var myProfileData = myProfileModel()
    @State var tacosCount: Int = 0
    let ref = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    var body: some View{
        
        ZStack{
            
            Text("\(self.tacosCount)")
                .font(.system(size: 200))
                .minimumScaleFactor(0.2)
                .lineLimit(1)
            VStack{
                
                HStack{
                    
                    CommentView(image: myProfileData.userInfo.pic ?? "", username: "\(myProfileData.userInfo.firstName ?? "")", comment: "Lets Count More Tacos. ", post: "tt_logo")
                    
                }.padding([.leading, .trailing], 15)
                
                Spacer()
                
                VStack{
                    
                    HStack{
                        
                        Spacer()
                        
                        VStack(spacing: 5){
                            
                            
                            Button(action: {
                                
                                ref.collection("users").document(self.uid).updateData([
                                    "tacoCount": FieldValue.increment(Int64(1))
                                ]) { err in
                                    if let err = err {
                                        
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                                self.tacosCount = tacosCount + 1
                                
                            }) {
                                
                                VStack(spacing: 8){
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .font(.title)
                                        .foregroundColor(.black)
                                }
                            }.padding(5)
                            
                            Button(action: {
                                
                                ref.collection("users").document(self.uid).updateData([
                                    "tacoCount": FieldValue.increment(Int64(-1))
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                                self.tacosCount = tacosCount - 1
                            }) {
                                
                                VStack(spacing: 8){
                                    
                                    Image(systemName: "minus.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .font(.title)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(5)
                            
                        }
                        .background(Capsule()
                                        .foregroundColor(.orange)
                                        .opacity(0.85)
                                        .shadow(color: .black, radius: 5, x: 5, y: 5)
                                        .overlay(
                                            Capsule()
                                                .stroke(lineWidth: 4.0)
                                                .foregroundColor(Color.yellow)
                                            
                                        )
                        )
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                        
                    }
                }
                .padding()
                .padding(.bottom,edge!.bottom + 70)
            }
        }
        .onAppear {
            
            self.updateTacoCount()
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
            self.tacosCount = data["tacoCount"] as? Int ?? 0
            print("Current data: \(tacosCount)")
        }
    }
}
