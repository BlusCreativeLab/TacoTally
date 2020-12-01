//
//  LeaderboardTab.swift
//  Taco Tally
//
//  Created by Courtland Bluford on 11/27/20.
//

import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct Leaderboard : View {
    
    var body: some View{
        
        TopScrollView()
        
    }
}

struct TopScrollView: View {
    
    @StateObject var myProfileData = myProfileModel()
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .fontWeight(.heavy)
            HStack() {

                FirstPlaceView()

                SecondPlaceView()
                    .padding(.leading, 40)

                ThirdPlaceView()
                    .padding(.leading, 30)

            }.padding(10)
            
            FollowBackView(image: myProfileData.userInfo.profileImage, username: myProfileData.userInfo.username, time: myProfileData.userInfo.tacoCount, hometown: myProfileData.userInfo.hometown)
                .padding([.leading, .trailing], 10)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .opacity(0.7)
                .frame(width: 200, height: 8)
            
            LeaderboardBottomView()
            
            Spacer()
        }
        
    }
}

struct LeaderboardBottomView : View {
    
    @State var data : [Card] = []
    // for Tracking....
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    @State var lastDoc : QueryDocumentSnapshot!
    
    var body: some View{
        
        VStack(spacing: 0){
            
            if !self.data.isEmpty{
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 2){
                        
                        ForEach(self.data){i in
                            
                            ZStack{
                                
                                // Showing Only When Data Is Loading...
                                
                                // because show variable is animating...
                                
                                if i.firstName == ""{
                                    
                                    // Shimmer Card..
                                    
                                    HStack(spacing: 15){
                                        
                                        Circle()
                                            .fill(Color.black.opacity(0.09))
                                            .frame(width: 75, height: 75)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            
                                            Rectangle()
                                                .fill(Color.black.opacity(0.09))
                                                .frame(width: 250, height: 15)
                                            
                                            Rectangle()
                                                .fill(Color.black.opacity(0.09))
                                                .frame(width: 100, height: 15)
                                        }
                                        
                                        Spacer(minLength: 0)
                                    }
                                    
                                    // Shimmer Animation...
                                    
                                    HStack(spacing: 15){
                                        
                                        Circle()
                                            .fill(Color.white.opacity(0.6))
                                            .frame(width: 75, height: 75)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            
                                            Rectangle()
                                                .fill(Color.white.opacity(0.6))
                                                .frame(width: 250, height: 15)
                                            
                                            Rectangle()
                                                .fill(Color.white.opacity(0.6))
                                                .frame(width: 100, height: 15)
                                        }
                                        
                                        Spacer(minLength: 0)
                                    }
                                    // Masking View...
                                    .mask(
                                    
                                        Rectangle()
                                            .fill(Color.white.opacity(0.6))
                                            .rotationEffect(.init(degrees: 70))
                                        // Moving View....
                                            .offset(x: i.show ? 1000 : -350)
                                    )
                                }
                                else{
                                    
                                    // Show Original Data...
                                    
                                    // Going to track end of data...
                                    
                                    ZStack{
                                        
                                        if self.data.last!.id == i.id{
                                            
                                            GeometryReader{g in
  
                                                HStack(spacing: 15){
                                                    
                                                    FollowBackView(image: "\(i.profileImage)", username: "\(i.userName)", time: i.tacoCount, hometown: "\(i.hometown)")
                                                }
                                                .onAppear{
                                                    
                                                    self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                                }
                                                .onReceive(self.time) { (_) in
                                                    
                                                    if g.frame(in: .global).maxY < UIScreen.main.bounds.height - 80{
                                                        
                                                        self.UpdateData()
                                                        
                                                        print("Update Data...")
                                                        
                                                        self.time.upstream.connect().cancel()
                                                    }
                                                }
                                            }
                                            .frame(height: 65)
                                            
                                        }
                                        else{
                                            
//                                            HStack(spacing: 15){
//
//                                                WebImage(url: URL(string: i.profileImage)!)
//                                                .resizable()
//                                                .frame(width: 75, height: 75)
//                                                .clipShape(Circle())
//
//                                                VStack(alignment: .leading, spacing: 12) {
//
//                                                    Text(i.name)
//                                                }
//
//                                                Spacer(minLength: 0)
//                                            }
                                            FollowBackView(image: "\(i.profileImage)", username: i.userName, time: i.tacoCount, hometown: i.hometown)
                                        }
                                    }
                                }
                                
                            }
                            .padding(10)
                        }
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .background(Color.orange.opacity(0.05).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            
            self.loadTempData()
            
            // Loading Data...
            
            self.getData()
            
        }
    }
    
    // Intial Shimmer Card data
    // Showing Until Data Is Loading...
    
    func loadTempData(){
        
        for i in 0...19{
            
            let temp = Card(id: "\(i)", firstName: "", show: false, profileImage: "", userName: "", tacoCount: 0, hometown: "")
                        
            self.data.append(temp)
            
            // Enabling Animation..
            
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
                
                self.data[i].show.toggle()
            }
        }
    }
    
    // Loading Data...
    
    func getData(){
        
        let db = Firestore.firestore()
        // First 20 data....
        db.collection("users").order(by: "tacoCount",descending: true).limit(to: 20).getDocuments { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            // removing shimmer data...
            
            self.data.removeAll()
            
            for i in snap!.documents{
                
                let data = Card(id: i.documentID, firstName: i.get("First Name") as! String, show: false, profileImage: i.get("pic") as! String, userName: i.get("username") as! String, tacoCount: i.get("tacoCount") as! Int, hometown: i.get("hometown") as! String)
                
                self.data.append(data)
            }
            
            // Saving Last Doc..
            
            self.lastDoc = snap!.documents.last
        }
    }
    
    // Updating Next 20 Data...
    
    func UpdateData(){
        
        // Adding Loading Shimmer Card...
        
        self.data.append(Card(id: "\(self.data.count)", firstName: "", show: false, profileImage: "", userName: "", tacoCount: 0, hometown: ""))
                
        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
            
            self.data[self.data.count - 1].show.toggle()
        }
        
        // Loading Data After One Second For Smooth Animation...
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let db = Firestore.firestore()
            
            db.collection("users").order(by: "tacoCount",descending: true).start(afterDocument: self.lastDoc).limit(to: 20).getDocuments { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                // removing loading animation....
                
                self.data.removeLast()
                
                if !snap!.documents.isEmpty{
                    
                    for i in snap!.documents{
                        
                        let data = Card(id: i.documentID, firstName: i.get("First Name") as! String, show: false, profileImage: i.get("pic") as! String, userName: i.get("username") as! String, tacoCount: i.get("tacoCount") as! Int, hometown: i.get("hometown") as! String)
                        
                        self.data.append(data)
                    }
                    
                    // Updating Last Doc...
                    
                    self.lastDoc = snap!.documents.last
                }
            }
        }
    }
}

// Data Model...

struct Card : Identifiable {
    
    var id : String
    var firstName : String
    var show : Bool
    var profileImage : String
    var userName: String
    var tacoCount: Int
    var hometown: String
}

struct CommentView: View {
    
    @StateObject var myProfileData = myProfileModel()
    
    var image: String
    var username: String
    var comment: String
    var post: String

    var body: some View {
        HStack(alignment: .top) {
            
            if image != ""{
                
                ZStack{
                    
                    WebImage(url: URL(string: image)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50, alignment: .top)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9868244529, green: 0.5855258107, blue: 0.09304409474, alpha: 1)), Color(#colorLiteral(red: 0.7633709311, green: 0.1634711623, blue: 0.7447224855, alpha: 1))]), startPoint: .bottom, endPoint: .top), lineWidth: 3)
                                .foregroundColor(Color(#colorLiteral(red: 0.9389725327, green: 0.9531454444, blue: 0.9702789187, alpha: 1)))
                        )
                    
                    if myProfileData.isLoading{
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("blue")))
                    }
                }
            }

            VStack(alignment: .leading) {
                Text("Hey \(username)!")
                    .font(.system(size: 17, weight: .bold))

                HStack(alignment: .bottom) {
                    Text(comment)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                }

//                HStack {
//                    Button(action: {}, label: {
//                        Image(systemName: "heart")
//                            .font(.system(size: 19, weight: .bold))
//                            .foregroundColor(.gray)
//                    })
//
//                    Button(action: {}, label: {
//                        Image(systemName: "ellipsis.bubble")
//                            .font(.system(size: 19, weight: .bold))
//                            .foregroundColor(.gray)
//                            .padding(.leading, 8)
//                    })
//                }
//                .padding(.top, 8)
            }

            Spacer()

            Image("tt_logo")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.top, 8)
    }
}

struct FollowBackView: View {
    
    @StateObject var myProfileData = myProfileModel()
    
    var image: String
    var username: String
    var time: Int
    var hometown: String

    var body: some View {
        
        ZStack(alignment: .topLeading) {
        
        HStack {
            Button(action: {}, label: {
                
                if image != ""{
                    
                    ZStack{
                        
                        WebImage(url: URL(string: image)!)
        //                Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50, alignment: .top)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .clipShape(RoundedRectangle(cornerRadius: 26))
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9868244529, green: 0.5855258107, blue: 0.09304409474, alpha: 1)), Color(#colorLiteral(red: 0.7633709311, green: 0.1634711623, blue: 0.7447224855, alpha: 1))]), startPoint: .bottom, endPoint: .top), lineWidth: 3)
                                    .foregroundColor(Color(#colorLiteral(red: 0.9389725327, green: 0.9531454444, blue: 0.9702789187, alpha: 1)))
                            )
                        
                        if myProfileData.isLoading{
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("blue")))
                        }
                    }
                }
            })

            VStack(alignment: .leading) {
                Text(username)
                    .font(.system(size: 17, weight: .bold))
                
                Text(hometown)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.gray)

//                HStack(alignment: .bottom) {
//                    Text(hometown)
//                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor(.gray)
//
//                    Text(time)
//                        .font(.system(size: 13))
//                        .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
//                }
            }

            Spacer()

            Text("\(time)")
                .padding(8)
                .font(.system(size: 15, weight: .bold))
                .frame(width: 115, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
            
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 30, height: 30)
            .foregroundColor(Color(#colorLiteral(red: 0.9311559796, green: 0.008160683326, blue: 0.3113113642, alpha: 1)))
            .overlay(
                Text("1st")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
            ).offset(x: 10, y: -10)
        }
    }
}

struct FirstPlaceView: View {
    var myProfileData = myProfileModel()

    @State var profileImage : String = ""
    var username: String = "cbluford"
    var firstName: String = ""
    var lastName: String = ""
    var bio : String = ""
    var tacoCount: Int = 0
    var hometown: String = ""
    var placeLevel: String = "1st"

    var body: some View {
        
        VStack {

            if profileImage != ""{

                ZStack(alignment: .topTrailing) {

                    WebImage(url: URL(string: profileImage)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55, alignment: .top)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .clipShape(Circle())
                        .padding(6)
                        .background(
                    Circle()
                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color("gold1"), Color("gold2")]), startPoint: .bottom, endPoint: .top), lineWidth: 3)
                        .foregroundColor(Color(#colorLiteral(red: 0.9389725327, green: 0.9531454444, blue: 0.9702789187, alpha: 1)))
                        )
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("gold1"))
                        .overlay(
                            Text("1st")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                        ).offset(x: 10, y: -10)
                if myProfileData.isLoading{

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("blue")))
                    }
                }
            }

            Text("Tumani")
                .font(.system(size: 16, weight: .bold))

            Text("\(5730.roundedWithAbbreviations)")
                .font(.system(size: 16, weight: .medium))
        }
        .padding([.top, .bottom],12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width / 4)
        )

        .onAppear {
            updateTacoCount()
        }
    }
    func updateTacoCount() {
        let ref = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        ref.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
                guard let data = document.data() else {
                print("Document data was empty.")
                    return
              }
            self.profileImage = data["pic"] as? String ?? ""
            return
            }
    }
}

struct SecondPlaceView: View {

    @ObservedObject private var myProfileData = myProfileModel()

    @State var profileImage : String = ""
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var bio : String = ""
    var tacoCount: Int = 0
    var hometown: String = ""
    var placeLevel: String = "2nd"

    var body: some View {

        VStack {

            if profileImage != ""{

                ZStack(alignment: .topTrailing) {

                    WebImage(url: URL(string: profileImage)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55, alignment: .top)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .clipShape(Circle())
                        .padding(6)
                        .background(
                    Circle()
                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color("silver1"), Color("silver2")]), startPoint: .bottom, endPoint: .top), lineWidth: 3)
                        .foregroundColor(Color(#colorLiteral(red: 0.9389725327, green: 0.9531454444, blue: 0.9702789187, alpha: 1)))
                        )
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("silver1"))
                        .overlay(
                            Text("2nd")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                        ).offset(x: 10, y: -10)
                if myProfileData.isLoading{

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("blue")))
                    }
                }
            }

            Text("Walter")
                .font(.system(size: 16, weight: .bold))

            Text("\(4830.roundedWithAbbreviations)")
                .font(.system(size: 16, weight: .medium))
        }
        .padding([.top, .bottom],12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width / 4)
        )

        .onAppear {
            updateTacoCount()
        }
    }
    func updateTacoCount() {
        let ref = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        ref.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
                guard let data = document.data() else {
                print("Document data was empty.")
                    return
              }
            self.profileImage = data["pic"] as? String ?? ""
            return
            }
    }
}

struct ThirdPlaceView: View {

    @ObservedObject private var myProfileData = myProfileModel()

    @State var profileImage : String = ""
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var bio : String = ""
    var tacoCount: Int = 0
    var hometown: String = ""
    var placeLevel: String = "3rd"

    var body: some View {

        VStack {

            if profileImage != ""{

                ZStack(alignment: .topTrailing) {

                    WebImage(url: URL(string: profileImage)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55, alignment: .top)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .clipShape(Circle())
                        .padding(6)
                        .background(
                    Circle()
                        .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color("bronze1"), Color("bronze2")]), startPoint: .bottom, endPoint: .top), lineWidth: 3)
                        .foregroundColor(Color(#colorLiteral(red: 0.9389725327, green: 0.9531454444, blue: 0.9702789187, alpha: 1)))
                        )
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("bronze1"))
                        .overlay(
                            Text("3rd")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                        ).offset(x: 10, y: -10)
                if myProfileData.isLoading{

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("blue")))
                    }
                }
            }

            Text("Username")
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)

            Text("\(4630.roundedWithAbbreviations)")
                .font(.system(size: 16, weight: .medium))
        }
        .padding([.top, .bottom],12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width / 4)
        )
        .onAppear {
            updateTacoCount()
        }
    }
    func updateTacoCount() {
        let ref = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        ref.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
                guard let data = document.data() else {
                print("Document data was empty.")
                    return
              }
            self.profileImage = data["pic"] as? String ?? ""
            return
            }
    }
}

//func fetchTopThree() {
//
//        ref.collection("users").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("Error fetching document: \(error!)")
//                return
//              }
//            self.top3 = documents.map { (queryDocumentSnapshot) -> PlaceView in
//                let data = queryDocumentSnapshot.data()
//
//                let uid = data["uid"] as? String ?? ""
//                let profileImage = data["pic"] as? String ?? ""
//                let username = data["username"] as? String ?? ""
//                let firstName = data["First Name"] as? String ?? ""
//                let lastName = data["Last Name"] as? String ?? ""
//                let bio = data["about"] as? String ?? ""
//                let hometown = data["hometown"] as? String ?? ""
//                let tacoCount = data["tacoCount"] as? Int ?? 0
//
//                return PlaceView(profileImage: profileImage, username: username, firstName: firstName, lastName: lastName, bio: bio, tacoCount: tacoCount, hometown: hometown)
//            }
//        }
//}
