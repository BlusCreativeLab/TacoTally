//
//  AccountCreation.swift
//  OTP
//
//  Created by Kavsoft on 18/01/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI
import Firebase

struct AccountCreation : View {
    
    @Binding var show : Bool
    
    @State var about = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var hometown = ""
    @State var username = ""
    
    
    
    @State var picker = false
    @State var loading = false
    @State var imagedata : Data = .init(count: 0)
    @State var alert = false
    
    var body : some View{
        
        VStack(alignment: .leading, spacing: 15){
            
            Text("Awesome !!! Create An Account").font(.headline)
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    
                    self.picker.toggle()
                    
                }) {
                    
                    if self.imagedata.count == 0{
                        
                       Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
                    }
                    else{
                        
                        Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                    }
                    
                    
                }
                
                Spacer()
            }
            .padding(.vertical, 15)
            
            ScrollView(.vertical, showsIndicators: true) {
            
                HStack {
                 
                    Text("Enter Your First Name")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                    
                    Spacer()
                    
                }

            TextField("First Name", text: self.$firstName)
                .keyboardType(.alphabet)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
                
                HStack {
                 
                    Text("Enter Your Last Name")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                    
                    Spacer()
                    
                }

            TextField("Last Name", text: self.$lastName)
                .keyboardType(.alphabet)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
                
                HStack {
                 
                    Text("Create a Username")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                    
                    Spacer()
                    
                }

            TextField("Username", text: self.$username)
                .keyboardType(.alphabet)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
            
            
                HStack {
                 
                    Text("About You")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                    
                    Spacer()
                    
                }

            TextField("A Little About You", text: self.$about)
                    .keyboardType(.default)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
                
            HStack {
                 
                Text("Your Hometown")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                    
                    Spacer()
                    
            }
                
            TextField("Where Are You From", text: self.$hometown)
                    .keyboardType(.default)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 15)
                
        }
            if self.loading{
                
                HStack{
                    
                    Spacer()
                    
                    Indicator()
                    
                    Spacer()
                }
            }
                
            else{
                
                Button(action: {
                    
                    if self.username != "" && self.about != "" && self.imagedata.count != 0{
                        
                        self.loading.toggle()
                        CreateUser(firstName: self.firstName, lastName: self.lastName, userName: self.username, hometown: self.hometown, about: self.about, imagedata: self.imagedata){ (status) in
                            
                            if status{
                                
                                self.show.toggle()
                            }
                        }
                    }
                    else{
                        
                        self.alert.toggle()
                    }
                    
                    
                }) {
                    

                Text("Create").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                         
                }.foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(10)
                
            }
            
        }
        .padding()
        .sheet(isPresented: self.$picker, content: {
            
            ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
        })
        .alert(isPresented: self.$alert) {
            
            Alert(title: Text("Message"), message: Text("C'mon! You know you have fill your info in."), dismissButton: .default(Text("Ok")))
        }
    }
}
