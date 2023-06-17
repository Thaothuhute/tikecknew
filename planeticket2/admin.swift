//
//  admin.swift
//  planeticket2
//
//  Created by DoanThinh on 6/16/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
struct AdminView: View {
    @State private var idChuyenBay: Int = 0
    @State private var idDiaDiemDi: Int = 0
    @State private var idDiaDiemDen: Int = 0
    @State private var idMayBay: Int = 0
    let db = Firestore.firestore()
    
    @State private var thoigianden = Date()
    @State private var thoigiandi = Date()
    
    @State private var chuyenBayList = [chuyenbay]()
    
    var body: some View {
            VStack {
                        // Hiển thị danh sách chuyến bay
                        List(chuyenBayList, id: \.idchuyenbay) { chuyenbay in
                            Text("ID: \(chuyenbay.idchuyenbay), Điểm đi: \(chuyenbay.iddiadiemdi), Điểm đến: \(chuyenbay.iddiadiemden), Máy bay: \(chuyenbay.idmaybay)")
                        }
                        
                        // Giao diện thêm chuyến bay
                        VStack {
                            
                            TextField("ID Chuyến bay", value: $idChuyenBay, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            
                            TextField("ID Điểm đi", value: $idDiaDiemDi, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                    
                            TextField("ID Điểm đến", value: $idDiaDiemDen, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                           
                            TextField("ID Máy bay", value: $idMayBay, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                       
                            DatePicker("Thời gian đến", selection: $thoigianden, displayedComponents: .date)
                                .padding()

                           
                            DatePicker("Thời gian đi", selection: $thoigiandi, displayedComponents: .date)
                                .padding()

                            Button(action: {
                                // Tạo một tài liệu Firestore mới
                                let newChuyenBay = chuyenbay(idchuyenbay: idChuyenBay, iddiadiemdi: idDiaDiemDi, iddiadiemden: idDiaDiemDen, idmaybay: idMayBay, thoigianden: thoigianden, thoigiandi: thoigiandi)
                                
                                // Lưu tài liệu vào cơ sở dữ liệu Firestore
                                do {
                                    _ = try db.collection("chuyenbay").addDocument(from: newChuyenBay)
                                } catch {
                                    print("Lỗi khi lưu dữ liệu vào Firestore: \(error)")
                                }
                                
                                // Xóa giá trị trong text field và date picker
                                idChuyenBay = 0
                                idDiaDiemDi = 0
                                idDiaDiemDen = 0
                                idMayBay = 0
                                thoigianden = Date()
                                thoigiandi = Date()
                            }) {
                                Text("Thêm chuyến bay")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        // Lấy dữ liệu chuyến bay từ Firestore khi giao diện được hiển thị
                        fetchChuyenBayList()
                    }
                }
                
                func fetchChuyenBayList() {
                    db.collection("chuyenbay").getDocuments { (snapshot, error) in
                        guard let documents = snapshot?.documents else {
                            print("Lỗi khi lấy dữ liệu từ Firestore: \(error?.localizedDescription ?? "")")
                            return
                        }
                        chuyenBayList = documents.compactMap { document in
                            do {
                                let chuyenBay = try document.data(as: chuyenbay.self)
                                return chuyenBay
                            } catch {
                                print("Lỗi khi chuyển đổi dữ liệu Firestore: \(error)")
                                return nil
                            }
                        }
                        
                    }
                        }
                    
                
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
