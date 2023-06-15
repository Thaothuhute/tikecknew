//
//  user.swift
//  planeticket2
//
//  Created by DoanThinh on 6/14/23.
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MyUser: Identifiable, Decodable, Hashable {
    let id = UUID()
    let email: String
    let password: String
    let createdAt: Date // Thêm trường createdAt kiểu Date
    let sodienthoai: String
    let ngaysinh: Date
    let ten: String
}






