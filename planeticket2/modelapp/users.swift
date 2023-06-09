//
//  users.swift
//  planeticket2
//
//  Created by Thu Thão on 26/05/2023.
//

import Foundation
struct users{
    var email:String
    var password: String
    var Hotendem :String
    var ten:String
    var quoctinh:String
    var danhxung :String
    var tuoi:Int
    var ngaysinh:Calendar
    var sdt:String
   
    

    init(email: String, password: String, Hotendem: String = "", ten: String = "", quoctinh: String = "", danhxung: String = "", tuoi: Int = 0, ngaysinh: Calendar , sdt: String = "") {
        self.email = email
        self.password = password
        self.Hotendem = Hotendem
        self.ten = ten
        self.quoctinh = quoctinh
        self.danhxung = danhxung
        self.tuoi = tuoi
        self.ngaysinh = ngaysinh
        self.sdt = sdt
    }
}
