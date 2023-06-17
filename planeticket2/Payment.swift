import SwiftUI
import UserNotifications

struct PaymentView: View {
    var body: some View {
        NavigationView {
            VStack {
                QRCodeImageView()
                Spacer()

                Button(action: {
                    kiemtraThanhtoan()
                }) {
                    Text("Thanh toán")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Thanh toán")
            .edgesIgnoringSafeArea(.all)
        }
    }

    func kiemtraThanhtoan() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }

    func dispatchNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Thông báo"
        content.body = "Bạn đã đặt vé máy bay thành công!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}

struct QRCodeImageView: View {
    var body: some View {
        Image("4")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
