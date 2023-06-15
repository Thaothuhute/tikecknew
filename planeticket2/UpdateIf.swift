import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UpdateIf: View {
    @State private var sodienthoai: String = ""
    @State private var ngaysinh: Date = Date()

    var body: some View {
        Form {
            Section(header: Text("Thông tin cá nhân")) {
                TextField("Số điện thoại", text: $sodienthoai)
                    .keyboardType(.phonePad)
                DatePicker("Ngày sinh", selection: $ngaysinh, displayedComponents: .date)
            }

            Section {
                Button(action: {
                    // Thực hiện hành động khi nhấn nút Lưu
                    saveProfile()
                }) {
                    Text("Lưu")
                }
            }
        }
        .navigationBarTitle("Cập nhật thông tin")
    }

    func saveProfile() {
        // Lấy ID của người dùng từ authentication hoặc từ Firestore nếu đã lưu trước đó
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Không tìm thấy ID của người dùng.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("user").document(userID)

        userRef.setData(["sodienthoai": sodienthoai, "ngaysinh": ngaysinh], merge: true) { error in
            if let error = error {
                print("Lỗi khi cập nhật thông tin: \(error)")
            } else {
                print("Thông tin đã được cập nhật thành công.")
            }
        }
    }
}

struct UpdateIf_Previews: PreviewProvider {
    static var previews: some View {
        UpdateIf()
    }
}
