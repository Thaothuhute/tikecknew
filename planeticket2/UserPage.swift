//
//  UserPage.swift
//  planeticket2
//
//  Created by DoanThinh on 5/17/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


struct UserPage: View {
    @State private var user: MyUser?
    @State private var currentUser: User?
    
    var body: some View {
        VStack {
            if let user = user {
                Text(user.email)
                
            }
            ChangePasswordView()
                .padding()
            
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
struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordMatch = true
    @State private var showAlert = false
    @State private var errorpass = false

    var body: some View {
        VStack {
            SecureField("Mật khẩu hiện tại", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Mật khẩu mới", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Xác nhận mật khẩu mới", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !passwordMatch {
                Text("Mật khẩu xác nhận không khớp!")
                    .foregroundColor(.red)
            }
           // if !errorpass{
             //   Text("Sai mật khẩu")
               //     .foregroundColor(.red)
            //}
            

            Button(action: {
                updatePassword()
            }) {
                Text("Đổi mật khẩu")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        
    }

    private func updatePassword() {
        if newPassword == confirmPassword {
            guard let currentUser = Auth.auth().currentUser else{
                print("mat khau khong dung")
                return
            }
           // guard let email = currentUser.email else {
                       
             //          return
               //    }
            //let password = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            //currentUser.reauthenticate(with: password){
              //  result, error in
               // if let error = error{
                 //   print("sai mat khau ")
                   // errorpass = true
                    
                //}
               // else {
                    let db = Firestore.firestore()
                    let userRef = db.collection("user").document(currentUser.uid)
                    userRef.updateData(["password": newPassword]) {
                        error in
                        if let error = error{
                            print("loi")
                        }
                        else{
                            print("cap nhat mat khau thanh cong")
                        }
                    }
                //}
            //}
        } else {
            passwordMatch = false
        }
    }
}


struct UserPage_Previews: PreviewProvider {
    static var previews: some View {
        UserPage()
    }
}
