//
//  chuyenbay.swift
//  planeticket2
//
//  Created by Thu Thão on 25/05/2023.
//

import Foundation
struct chuyenbay: Codable{
   
    var idchuyenbay:Int
    var iddiadiemdi:Int
    var iddiadiemden:Int
    var idmaybay:Int
    var thoigianden: Date
    var thoigiandi: Date
    
    init(idchuyenbay: Int, iddiadiemdi: Int, iddiadiemden: Int, idmaybay: Int, thoigianden: Date, thoigiandi: Date) {
        self.idchuyenbay = idchuyenbay
        self.iddiadiemdi = iddiadiemdi
        self.iddiadiemden = iddiadiemden
        self.idmaybay = idmaybay
        self.thoigianden = thoigianden
        self.thoigiandi = thoigiandi
    }
        
    
}
