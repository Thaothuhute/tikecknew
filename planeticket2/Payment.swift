////
////  Payment.swift
////  planeticket2
////
////  Created by DoanThinh on 5/16/23.
////


import Foundation
import SwiftUI
import UserNotifications
import FirebaseFirestore
import Firebase
struct Payment: View {
    @State private var phoneNumber = "9999999"
    @Binding var selectedVemaybay: vemaybay?
    @State private var iduser = 1
    @State private var vemaybays :[vemaybay] = []
    @State private var vemaybayuser : vemaybay?
    @State private var tendiadiemdi = "chua co"
    @State private var tendiadiemden = "chua co"
    let db = Firestore.firestore()
    var body: some View {


        let calender = Calendar.current
        let currentDate = Date()

        VStack(alignment: .center){
            Spacer().frame(height: 20)
            HStack{
                Spacer().frame(width: 20)
                VStack(alignment: .center){
                    Spacer()
                    Image("1")
                        .resizable()
                        .frame(width:80,height: 80 )
                        .cornerRadius(10)
                    Spacer()
                }.cornerRadius(10)

                VStack(alignment: .leading){


                    Text("Ten nguoi mua :\(vemaybayuser?.idUser ?? 1)")
                    Text("So ve:\(vemaybays.count)")
                    Text("So tien")
                }
                Spacer()
                VStack(alignment: .leading){
                    Text(":Huy")
                    Text(":2")
                    Text(":100000")
                }

                Spacer()
            }
            .background(Color.white)
            .frame( width: 350, height: 150)

            .cornerRadius(20)
            .shadow(radius: 5)
            Spacer().frame(height: 20)
            HStack{
                VStack{
                    Text("\(tendiadiemdi)")
                        .font(.system(size: 23))
                    Text("Gio :")
                        .foregroundColor(Color.gray)

                    Spacer().frame(width:150,height: 5)
                }.background(Color.white)


                    .cornerRadius(5)
                    .shadow(radius: 5)

                HStack{
                    Text("=>")
                }

                VStack{
                    Text("\(tendiadiemden)")
                        .font(.system(size: 23))
                    Text("Phut:")
                        .foregroundColor(Color.gray)
                    Spacer().frame(width:150,height: 5)
                }.background(Color.white)


                    .cornerRadius(5)
                    .shadow(radius: 5)
            }
            HStack{
                Spacer().frame(width: 20)
                ZStack(){

                    HStack{
                        VStack{
                            Spacer().frame(height: 20)
                            HStack{
                                Spacer().frame(width: 28)
                                VStack{
                                    Text("47")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 28))
                                    Text("kg")
                                        .foregroundColor(Color.white)
                                    Spacer().frame(width: 80, height: 10)

                                }
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)

                                Spacer().frame(width: 30)
                                VStack{
                                    Text("E")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 28))
                                    Text("20")
                                        .foregroundColor(Color.white)
                                    Spacer().frame(width: 80, height: 10)

                                }
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                Spacer()
                            }
                            Spacer().frame(height: 20)
                        }
                        .cornerRadius(10)
                        .background(Color.white)
                    }
                    .cornerRadius(10)
                    .offset( y: 60)
                    .shadow(radius: 5)
                    HStack{
                        Spacer().frame(width: 30)
                        ZStack{
                            Text("Hanh ly")
                                .foregroundColor(Color.white)

                                .multilineTextAlignment(.leading)
                                .padding(10)
                        }.background(Color.blue)
                            .cornerRadius(10)
                        Spacer().frame(width: 30)
                        ZStack{
                            Text("So ghe")
                                .foregroundColor(Color.white)

                                .multilineTextAlignment(.leading)
                                .padding(10)
                        }.background(Color.blue)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
                Spacer().frame(width: 20)
            }
            Spacer()
            Button(action: {
                kiemtraThanhtoan()
            }) {
                Text("Thanh toán")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            Spacer()

        }



        .onAppear {
            fetchVemaybay()
            getdiadiem(id: vemaybayuser?.iddiadiemdi ?? 1, choice: 1)
            getdiadiem(id: vemaybayuser?.iddiadiemden ?? 1, choice: 2)
        }

    }
    func searchaddTicket(){
        self.vemaybayuser = vemaybays.first(where: {$0.idUser == 1})

    }
    func fetchVemaybay(){
        let vemaybayCollection = db.collection("vemaybay")

        vemaybayCollection.getDocuments{snapshot,error in if let error = error{
            print("Error fetching documents: \(error)")
            return
        }
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }


            for document in documents{
                let  data = document.data()

                if let giave = data["giave"] as? Float,

                    let iddiadiemdi = data["iddiadiemdi"] as? Int,
                   let iddiadiemden = data["iddiadiemden"] as? Int,
                   let idvemaybay = data["idvemaybay"] as? Int,
                   let ngaydifb = data["thoigianden"] as? Timestamp,
                   let ngayinfb = data["thoigiandi"] as? Timestamp,
                   let iduser = data["iduser"] as? Int,
                   let thoigiandukiendenfb = data["thoigiandukienden"] as? Timestamp
                {
                    print("da nhan")
                    let ngaydi = convertTimestampToDate(ngaydifb)
                    let ngayin = convertTimestampToDate(ngayinfb)
                    let thoigiandukienden = convertTimestampToDate(thoigiandukiendenfb)

                    let vemaybayse = vemaybay(id: document.documentID, giave: giave, iddiadiemdi:iddiadiemdi, iddiadiemden: iddiadiemden, idUser: iduser, idvemaybay: idvemaybay, thoigiandi: ngaydi, thoigianden: thoigiandukienden)
                    self.vemaybays.append(vemaybayse)
                    print(document.data().count)
                    if vemaybayse.idUser == 1 {
                        self.vemaybayuser = vemaybayse
                        self.searchaddTicket()
                        print("id:\(self.vemaybayuser?.idUser)")
                    }
                } 
                else{
                    print("flase")
                }



            }

        }




    }

    func convertTimestampToDate(_ timestamp: Timestamp) -> Date {
        let seconds = timestamp.seconds
        let nanoseconds = timestamp.nanoseconds
        
        let timeInterval = TimeInterval(seconds) + TimeInterval(nanoseconds) / 1_000_000_000
        let date = Date(timeIntervalSince1970: timeInterval)
        
        return date
    }
    func searchticketuser(vemaybayraw: [vemaybay] )-> vemaybay{


        if let vemaybayse = vemaybayraw.first(where: {$0.idUser == self.iduser}){
            return vemaybayse
        }
        else{
            let vemayb = vemaybay()
            return vemayb
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
    func  getdiadiem(id : Int,choice : Int){
            let listdiadiem = Firestore.firestore().collection("diadiem")
            listdiadiem.whereField("iddiadiem", isEqualTo: id).getDocuments{ snapshot, error in
                if let error = error {
                    print("Error fetching book: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                let diadiem = documents.compactMap{document -> diaDiem? in
                    let data = document.data()
                    let id  = data["iddiadiem"] as? Int
                    let tendaidiemdi = data["tendiadiem"] as? String ?? ""
                    return diaDiem(tendiadiem: tendaidiemdi, iddiadiem: id ?? 1)

                }
                if  choice == 1{
                    self.tendiadiemdi = diadiem.first?.tendiadiem ?? "chua co ten"

                }
                else{
                    self.tendiadiemden = diadiem.first?.tendiadiem ?? "chua co ten"

                }
            }
        }


        func kiemtraThanhtoan(){
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings{ settings in switch settings.authorizationStatus{
            case .authorized:
                self.dispatchoNotification()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert,.sound] ){didAllow, error in if didAllow{
                        self.dispatchoNotification()
                    }
                }
            default:
                return
                }
            }
        }
  

        func dispatchoNotification(){
            let calender = Calendar.current
            let currentDate = Date()
            let identifier = "Plane ticket"
            let title = "Ban muon di chua"
            let body = "Hay don hanh y di nao, co chuyen bay dang cho ban"
            let hour = calender.component(.hour, from:currentDate )
            let minutes = calender.component(.minute, from:currentDate)+1
            let isDaily = true

            let notificationCenter = UNUserNotificationCenter.current()


            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            var dateComponent = DateComponents(calendar: calender,timeZone: TimeZone.current)
                    dateComponent.hour = hour
                    dateComponent.minute = minutes


                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: isDaily)

                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)


                    notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
                    notificationCenter.add(request)
                }

            }



            struct Payment_Previews: PreviewProvider {
                static var previews: some View {
                    Payment()
                }
            }

