//
//  addData.swift
//  planeticket2
//
//  Created by DoanThinh on 5/18/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

let db = Firestore.firestore()


struct addData: View {
    var body: some View {
        
        Button(action: {
            saveVemaybayToFirestore1()}) {
                Text("Add")        }
        
        
    }
    func saveVemaybayToFirestore1() {
        let db = Firestore.firestore()
        
        let vemaybay = vemaybay(giave: 3, iddiadiemdi: 3)
        
        do {
            _ = try db.collection("vemaybay").addDocument(from: vemaybay)
            print("Saved vemaybay to Firestore")
        } catch let error {
            print("Error saving vemaybay to Firestore: \(error.localizedDescription)")
        }
    }
}

struct addData_Previews: PreviewProvider {
    static var previews: some View {
        addData()
    }
}
