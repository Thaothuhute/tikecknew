
import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import AssetsLibrary
import FirebaseAuth

struct UserInformation: View {
    @State private var username = ""
    @StateObject var authViewModel = AuthViewModel()
    @State private var currentUser: User?
    @State private var showdoithongtin = false
    @State private var usercr :MyUser?
    @State private var showdoimatkhau = false

    var body: some View{
        VStack{
            HStack{
                VStack{
                    AvatarView(image: Image("useravt"), size: 100)
                    Text("ten:\(usercr?.ten ?? "Chua co")")
                }
                Spacer().frame(width: 30)

                VStack{
                    
                    Button(action: {
                               showdoimatkhau = true
                                            }) {
                                                Text("Doi mat khau")
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .background(Color.green)
                                                    .cornerRadius(10)
                                            }

                    
                    Spacer().frame(height:10)
                    Button("Doi thong tin") {
                        showdoithongtin = true
                                    }
                    .buttonStyle(.bordered)
                    Spacer().frame(height:10)
                }
                Spacer()
            }
            
            
            Spacer().frame(height: 40)
            HStack{
                Text("email:")
                Spacer().frame(width: 20)

                Text("\(usercr?.email ?? " chua co ")")
                Spacer()
            }
            .padding(5)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            
            Spacer().frame(height: 20)
            HStack{
                Text("SDT:")
                Spacer().frame(width: 5)

                Text("Số điện thoại")
                Text("\(usercr?.sodienthoai ?? "")")
                Spacer()
                Text("Ngay sinh:")
                Text("\(formatDate(usercr?.ngaysinh))")
            }
            .padding(5)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            Spacer().frame(height: 20)
            
            
            Spacer()
        }.padding(20)
        .onAppear{
            getcurretnUser()
            getUser()
        }
        .sheet(isPresented: $showdoithongtin) {
                        UpdateIf()
                    }
                    .sheet(isPresented: $showdoimatkhau) {
                        UserPage()
                    }
    }
    func formatDate(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Định dạng ngày tháng, ví dụ: "dd/MM/yyyy"
        
        return formatter.string(from: date)
    }





        func getUser(){
            let listdiadiem = Firestore.firestore().collection("user")
            listdiadiem.whereField("email", isEqualTo: Auth.auth().currentUser?.email ).getDocuments{ snapshot, error in
                if let error = error {
                    print("Error fetching book: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                    let usercurrent = documents.compactMap { document -> MyUser? in
                            let data = document.data()
                            let email = data["email"] as? String ?? ""
                            let password = data["password"] as? String ?? ""
                            let createdAtTimestamp = data["createdAt"] as? Timestamp
                            let sodienthoai = data["sodienthoai"] as? String ?? ""
                            let ngaysinhTimestamp = data["ngaysinh"] as? Timestamp
                            let ten = data["ten"] as? String ?? ""
                            
                            let createdAt = createdAtTimestamp?.dateValue() ?? Date()
                            let ngaysinh = ngaysinhTimestamp?.dateValue() ?? Date()
                            
                        return MyUser(email: email, password: password, createdAt: createdAt, sodienthoai: sodienthoai, ngaysinh: ngaysinh, ten: ten)
                }

                self.usercr = usercurrent.first
            }
        }
    func getcurretnUser(){
        
        
        if let userEmail = Auth.auth().currentUser?.email {
            self.username = userEmail
        } else {
            self.username = "Default"
        }
    }
    
    func convertTimestampToCalendar(_ timestamp: Timestamp) -> Calendar {
        let seconds = timestamp.seconds
        let nanoseconds = timestamp.nanoseconds
        
        let timeInterval = TimeInterval(seconds) + TimeInterval(nanoseconds) / 1_000_000_000
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let calendar = Calendar.current
        let calendarComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        return calendarComponents.calendar ?? Calendar.current
    }
    
}
    

struct AvatarView: View {
    let image: Image
    let size: CGFloat
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .cornerRadius(size / 2)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: size, height: size)
            )
            .shadow(radius: 10)
    }
}
struct UserInformation_Previews: PreviewProvider {
    static var previews: some View {
        UserInformation()
    }
}
struct another: PreviewProvider {
    
    static var previews: some View {
        fillInformation()
    }
}
