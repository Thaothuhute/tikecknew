//
//  vemaybay.swift
//  planeticket2
//
//  Created by Thu Thão on 26/05/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct vemaybay: Codable {
    @DocumentID var id: String?
    
    var giave: Float
    let iddiadiemdi: Int
    let iddiadiemden: Int
    let idUser: Int
    let idvemaybay: Int
    var email: String
    
    var thoigiandi: Date?
    var thoigianden: Date?
    
    init(id: String = "", giave: Float = 0, iddiadiemdi: Int = 0, iddiadiemden: Int = 0, idUser: Int = 0, idvemaybay: Int = 0, email: String = "", thoigiandi: Date = Date(), thoigianden: Date = Date()) {
        self.id = id
        self.giave = giave
        self.iddiadiemdi = iddiadiemdi
        self.iddiadiemden = iddiadiemden
        self.idUser = idUser
        self.idvemaybay = idvemaybay
        self.email = email
        self.thoigiandi = thoigiandi
        self.thoigianden = thoigianden
    }
}
