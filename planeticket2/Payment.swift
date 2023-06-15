//import SwiftUI
//import ZaloPaySDK
//let appID = "2554"
//let appKey = "sdngKKJmqEMzvh5QQcdD2A9XBSKUNaYn"
//
//func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    ZaloPaySDK.sharedInstance()?.initWithAppId(appID, appKey: appKey)
//    return true
//}
//
//struct PaymentView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                QRCodeImageView()
//                Spacer()
//
//                Button(action: {
//                    // Gọi hàm để thực hiện thanh toán bằng ZaloPay
//                    makePaymentWithZaloPay()
//                }) {
//                    Text("Thanh toán")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//            .navigationTitle("Thanh toán")
//            .edgesIgnoringSafeArea(.all)
//        }
//    }
//
//    func makePaymentWithZaloPay() {
//        // Thực hiện thanh toán bằng ZaloPay
//        // Gọi các hàm và xử lý logic liên quan đến thanh toán
//    }
//}
//
//struct QRCodeImageView: View {
//    var body: some View {
//        Image("4")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .padding()
//    }
//}
//
//struct Payment_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentView()
//    }
//}
