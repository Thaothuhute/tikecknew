//
//  ticketplaneapp.swift
//  planeticket2
//
//  Created by DoanThinh on 5/12/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Firebase


@main
struct ticketplaneapp:App{
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene{
        
        WindowGroup{
            Login()
        }
    }
}
