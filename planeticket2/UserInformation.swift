
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
    @State private var usercr :users?

    
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
                        showdoithongtin = true
                        let window = UIApplication
                            .shared
                            .connectedScenes
                            .flatMap{($0 as? UIWindowScene)?.windows ?? [] }
                            .first { $0.isKeyWindow}
                        
                        window?.rootViewController = UIHostingController(rootView: fillInformation())
                        window?.makeKeyAndVisible()
                    }
                    ) {
                        Text("Doi mat khau")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Spacer().frame(height:10)
                    Button("Doi thong tin") {

                    }.buttonStyle(.bordered)
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

                Text("09020203030")
                Spacer()
                Text("Ngay sinh:")
                Text("\(usercr?.ngaysinh ?? Calendar.current)")
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
    }
    func getUser(){
        let listdiadiem = Firestore.firestore().collection("user")
        listdiadiem.whereField("email", isEqualTo: Auth.auth().currentUser?.email ).getDocuments{ snapshot, error in
            if let error = error {
                print("Error fetching book: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            let usercurrent = documents.compactMap{document -> users? in
                let data = document.data()
                let  email = data["email"] as? String ?? ""
                let password = data["password"] as? String ?? ""
                let  Hotendem = data["hovatendem"] as? String ?? ""
                let  ten = data["ten"] as? String ?? ""
                let  danhxung = data["hovatendem"] as? String ?? "Chua co"
                let  tuoi = data["hovatendem"] as? Int
                let ngaysinhraw = data["ngaysinh"] as? Timestamp
                let sdt = data["sdt"] as? String ?? ""
                let quoctich = data["quoctich"] as? String ?? ""


                let ngaysinh = convertTimestampToCalendar(ngaysinhraw ?? Timestamp(date: Date()))
                return users(email: email, password: password, Hotendem: Hotendem, ten: ten, quoctinh: quoctich, danhxung: danhxung, tuoi: tuoi ?? 0, ngaysinh: ngaysinh, sdt: sdt  )
                
            }
            self.usercr  = usercurrent.first
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
