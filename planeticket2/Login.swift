//
//  Login.swift
//  planeticket2
//
//  Created by DoanThinh on 5/15/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift



class AuthViewModel: ObservableObject {
    struct User {
        
        var email: String
        var password: String
        
    }
    @Published var isLoggedIn = false
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var currentUser: User?
    @Published var loggedInUser: User?
    
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                
            } else {
                
                self?.isLoggedIn = true
                self?.loggedInUser = User(email: email, password: password)
                
            }
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.isLoggedIn = true
                guard let user = Auth.auth().currentUser else {
                               return
                           }
                let userData: [String: Any] = [
                                "email": user.email,
                                "password": self?.password ?? ""
                ]
                           
                           let db = Firestore.firestore()
                db.collection("user").document(user.uid).setData(userData) { error in
                    if let error = error {
                        print("Error adding user data to Firestore: \(error.localizedDescription)")
                    } else {
                        print("User data added to Firestore successfully")
                    }
                }
            }
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.errorMessage = "Reset password email sent."
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct Login: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var showSignUp = false
    @State private var showResetPassword = false
    
    var body: some View {
        VStack {
            if authViewModel.isLoggedIn {
                homePage()
                
                
                
            } else {
                VStack {
                    TextField("Email", text: $authViewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $authViewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        authViewModel.login(email: authViewModel.email, password: authViewModel.password)
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    Button(action: {
                        showSignUp = true
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    
                    Button(action: {
                        showResetPassword = true
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    
                    if !authViewModel.errorMessage.isEmpty {
                        Text(authViewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .sheet(isPresented: $showSignUp) {
            VStack {
                TextField("Email", text: $authViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $authViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    authViewModel.signUp()
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                if !authViewModel.errorMessage.isEmpty {
                                   Text(authViewModel.errorMessage)
                                       .foregroundColor(.red)
                               }
                           }
                       }
                       .sheet(isPresented: $showResetPassword) {
                           VStack {
                               TextField("Email", text: $authViewModel.email)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding()
                               
                               Button(action: {
                                   authViewModel.resetPassword()
                               }) {
                                   Text("Reset Password")
                                       .foregroundColor(.white)
                               }
                               .padding()
                               .background(Color.blue)
                               .cornerRadius(10)
                               
                               if !authViewModel.errorMessage.isEmpty {
                                   Text(authViewModel.errorMessage)
                                       .foregroundColor(.red)
                               }
                           }
                       }
                       .padding()
                   }
               }
        struct Login_Previews: PreviewProvider {
            static var previews: some View {
                Login().environmentObject(AuthViewModel())
            }
        }
    
//conasd
//contact
