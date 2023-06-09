//
//  fillInformation.swift
//  planeticket2
//
//  Created by DoanThinh on 5/15/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

struct User: Identifiable, Decodable, Hashable{
    let id = UUID()
    let email: String
    let password: String
    let createdAt: Date // Thêm trường createdAt kiểu Date
       
       private enum CodingKeys: String, CodingKey {
           case email, password, createdAt
       }
}

struct ContactInfoView: View {
    
    
    @State private var user: User?
    @EnvironmentObject var bookingEnvironment: BookingEnvironment
    
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var showPassengerInfo = false
    @StateObject var authViewModel = AuthViewModel()
    @State private var currentUser: User?
    @State private var showBookingView = false
    
    
    

    var body: some View {
        VStack {
             
            Text("Thông tin liên hệ")
                .font(.title)
            if let user = user {
                Text(user.email)
    
            }
            

            PassengerInfoView()
            
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
                        self.user = try decoder.decode(User.self, from: user)
                    } catch {
                        print("Error decoding user data: \(error)")
                    }
                }
            }
        }
        .background(
                    NavigationLink(
                        destination: Booking(),
                        isActive: $showBookingView,
                        label: { EmptyView() }
                    )
                    .hidden()
                )
        .background(
                   EmptyView()
                       .sheet(isPresented: $showBookingView) {
                           Booking()
                       }
                   )
               
        

    }
    struct LuggageView: View {
        @State private var luggageWeight = 0
        
        var body: some View {
            VStack {
                Text("Tiện nghi hành lý")
                    .font(.title)
                
                Stepper("Số kg hành lý", value: $luggageWeight, in: 0...30)
                
               
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct PassengerInfoView: View {
    @State private var gioitinh = ""
    @State private var hovatendem = ""
    @State private var ten = ""
    @EnvironmentObject var bookingEnvironment: BookingEnvironment
    @State private var quoctich = ""
    @State private var selectedDate1 = Date()
    @State private var showBookingView = false
    
   
    
    
    var body: some View {
       
            VStack {
                Text("Thông tin hành khách")
                    .font(.title)
                
                Picker("Danh xưng", selection: $gioitinh) {
                    Text("Ông").tag("1")
                    Text("Bà").tag("2")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                TextField("Họ và tên đệm", text: $hovatendem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("tên", text: $ten)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Form {
                    Section {
                        DatePicker("Ngày sinh", selection: $selectedDate1, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                    }
                    
                   
                }
    
                TextField("Quốc tịch", text: $quoctich)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                    
            }
        
        Button(action: {
            // Xử lý khi bấm nút
            save()
            showBookingView = true
            
        }) {
            Text("Chọn ghế và hành lý")
        }
        .sheet(isPresented: $showBookingView) {
                   Booking()
               }
        
    }
    func save(){
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        let thongtinKH: [String: Any] = [
            "danhxung": gioitinh,
            "hovatendem": hovatendem,
            "ten": ten,
            "ngaysinh": Timestamp(date: selectedDate1),
            "quoctich": quoctich
        ]
        let userInfo: [String: Any] = [
            "email": currentUser.email ?? "",
            "password":   ""
        ]
        let batch = db.batch()
            let userRef = db.collection("user").document(currentUser.uid)
            batch.setData(thongtinKH, forDocument: userRef, merge: true)
            batch.setData(userInfo, forDocument: userRef, merge: true)
            
        batch.commit { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("Data saved successfully")
                showBookingView = true
            }
        }
    }
   
}
struct fillInformation: View {
    @EnvironmentObject private var bookingEnvironment: BookingEnvironment
    
   
    var body: some View {
        NavigationView {
            VStack {
                ContactInfoView().environmentObject(bookingEnvironment)
                
            }
            .navigationTitle("Đặt vé máy bay")
            
        }
    }
}

struct fillInformation_Previews: PreviewProvider {
    
    
    static var previews: some View {
        fillInformation()
    }
}
