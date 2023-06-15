//
//  ShowTicket.swift
//  planeticket2
//
//  Created by DoanThinh on 6/15/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class VemaybayViewModel: ObservableObject {
    @Published var veMaybays = [vemaybay]()
    private var db = Firestore.firestore()
    private var userEmail: String?
    
    func fetchVemaybays(withEmail email: String) {
        db.collection("vemaybay").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }
            
            
            self.veMaybays = documents.compactMap { document in
                try? document.data(as: vemaybay.self)
            }
        }
    }
}

struct ShowTicket: View {
    @ObservedObject var viewModel = VemaybayViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @State private var userEmail: String?
    let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0 // Số lượng chữ số thập phân tối đa
            return formatter
        }()
    func getDestinationName(for id: Int) -> String {
            switch id {
            case 1:
                return "Cảng hàng không Quốc tế Nội Bài (Hà Nội)"
            case 2:
                return "Cảng hàng không quốc tế Phú Quốc (Phú Quốc)"
            case 3:
                return "Sân bay Tân Sơn Nhất (TP.HCM)"
            case 4:
                return "Cảng hàng không quốc tế Hải Phòng (Hải Phòng)"
            case 5:
                return "Sân bay Liên Khương (Lâm Đồng)"
            default:
                return ""
            }
        }
    var body: some View {
        NavigationView {
            List(viewModel.veMaybays, id: \.id) { vemaybay in
                VStack(alignment: .leading) {
                    if let giaveString = priceFormatter.string(from: NSNumber(value: vemaybay.giave)) {
                                            Text("Giá vé: \(giaveString) VND")
                                        }
                    Text("Địa điểm đi: \(getDestinationName(for: vemaybay.iddiadiemdi))")
                    Text("Địa điểm đến: \(getDestinationName(for: vemaybay.iddiadiemden))")
                    Text("Ngày đi: \(vemaybay.thoigiandi ?? Date())")
                    Text("Ngày đến: \(vemaybay.thoigianden ?? Date())")
                }
            }
            .onAppear {
                if let email = Auth.auth().currentUser?.email {
                    userEmail = email
                    viewModel.fetchVemaybays(withEmail: email)
                } else {
                    print("User email not available.")
                }
            }
        }
    }
}

struct ShowTicket_Previews: PreviewProvider {
    static var previews: some View {
        ShowTicket()
    }
}
