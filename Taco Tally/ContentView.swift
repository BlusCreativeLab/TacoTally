//
//  ContentView.swift
//  Taco Tally
//
//  Created by Courtland Bluford on 11/27/20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @AppStorage("current_status") var status = false
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                if status{

                    NavigationView{
                        
                        CustomTabView()
                            .navigationTitle("")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                    }
                    
                }
                else{

                    NavigationView{

                         Login()
                    }
                }
                
                
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                    
                   let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                       
                    self.status = status
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
