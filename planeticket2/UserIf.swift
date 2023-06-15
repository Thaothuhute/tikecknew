//
//  UserIf.swift
//  planeticket2
//
//  Created by DoanThinh on 5/18/23.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct UserIf: View {
    @State private var user: MyUser?
    @State private var signout = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showdoithongtin1 = false
    @State private var showvemaybay = false
       var body: some View {
           VStack {
               if let user = user {
                   Text(user.email)
               }
               
               Spacer()
               
               VStack {
                   Button(action: {
                       showdoithongtin1 = true
                      
                   }) {
                       Text("Thông tin người dùng")
                           .foregroundColor(.green)
                   }
                   .padding()
                   .cornerRadius(10)
                   
                   Button(action: {
                      UpdateIf()
                   }) {
                       Text("Đổi mật khẩu")
                           .foregroundColor(.green)
                   }
                   .padding()
                   .cornerRadius(10)
                   
                   Button(action: {
                       showvemaybay = true
                   }) {
                       Text("Vé đã mua")
                           .foregroundColor(.green)
                   }
                   .padding()
                   .cornerRadius(10)
               }
               .padding()
               
               Button(action: {
                   authViewModel.signOut()
               }) {
                   Text("Sign Out")
                       .foregroundColor(.white)
               }
               .padding()
               .background(Color.blue)
               .cornerRadius(10)
               
           }
           .sheet(isPresented: $showdoithongtin1) {
                           UserInformation()
                       }
           .sheet(isPresented: $showvemaybay) {
                           ShowTicket()
                       }
           .padding()
           .onAppear {
               if let userEmail = Auth.auth().currentUser?.email {
                   let db = Firestore.firestore()
                   let userRef = db.collection("user").whereField("email", isEqualTo: userEmail)
                   
                   userRef.getDocuments { querySnapshot, error in
                       if let error = error {
                           print("Error getting user document: \(error)")
                           return
                       }
                       
                       guard let documents = querySnapshot?.documents else {
                           print("No user document found")
                           return
                       }
                       
                       // Assuming email is unique, retrieve the first document
                       let user = documents[0].data()
                       let decoder = Firestore.Decoder()
                       do {
                           self.user = try decoder.decode(MyUser.self, from: user)
                       } catch {
                           print("Error decoding user data: \(error)")
                       }
                   }
               }
           }
       }
       
}

struct UserIf_Previews: PreviewProvider {
    static var previews: some View {
        UserIf().environmentObject(AuthViewModel())
    }
}


