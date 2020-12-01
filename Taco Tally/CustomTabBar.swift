//
//  CustomTabBar.swift
//  Taco Tally
//
//  Created by Courtland Bluford on 11/27/20.
//

import Foundation
import SwiftUI
import Firebase

struct CustomTabView : View {
    
    @State var selectedTab = "home"
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Image("bgs").resizable(resizingMode: .tile)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.50)
            // Using Tab View For Swipe Gestures...
            // if you dont need swipe gesture tab change means just use switch case....to switch views...
            
            TabView(selection: $selectedTab) {
                
                Home()
                    .tag("home")
                
                Leaderboard()
                    .tag("leaderboard")
                
//                Leaderboard()
//                    .tag("history")
                
                ProfileView()
                    .tag("myprofile")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)
            // for bottom overflow...
            
            HStack(spacing: 0){
                
                ForEach(tabs,id: \.self){image in
                    
                    TabButton(image: image, selectedTab: $selectedTab)
                    
                    // equal spacing...
                    
                    if image != tabs.last{
                        
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal,25)
            .padding(.vertical,5)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            // for smaller iphones....
            // elevations...
            .padding(.bottom,edge!.bottom == 0 ? 20 : 0)
            
            // ignoring tabview elevation....
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.orange.ignoresSafeArea(.all, edges: .all))
    }
}

// tabs...
// Image Names...
var tabs = ["home","leaderboard","myprofile"]

struct TabButton : View {
    
    var image : String
    @Binding var selectedTab : String
    
    var body: some View{
        
        Button(action: {selectedTab = image}) {
            
            Image(image)
                .renderingMode(.template)
                .foregroundColor(selectedTab == image ? Color("tab") : Color.black.opacity(0.4))
                .padding()
        }
    }
}
