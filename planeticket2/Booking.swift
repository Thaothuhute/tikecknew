        //
        //  Booking.swift
        //  planeticket2
        //
        //  Created by DoanThinh on 5/18/23.
        //

    import Firebase
    import SwiftUI
    import FirebaseFirestore
    import FirebaseFirestoreSwift

    class SeatSelection: ObservableObject {
    @Published var selectedSeat: String?
    }

    struct Seat: Identifiable, Codable {
    @DocumentID var id: String?
    let seatNumber: String
    var isBooked: Bool
    }
    struct FlightPrice: Codable, Hashable, Identifiable {
    let id = UUID()
    var giave: Int
    let iddiadiemden: Int
    let iddiadiemdi: Int
    let idloaive: Int
    }


    class SeatManager: ObservableObject {
    @Published var seats: [Seat] = []
    @Published var lastSelectedSeat: String?
    @Published var flightPrices: [FlightPrice] = []
    @Published var selectedDiaDiem1: DiaDiem? // Thêm biến selectedDiaDiem1
    @Published var selectedDiaDiem2: DiaDiem?
    @Published var ticketBookingStatus: String = ""
    @Published var selectedFlightPrice: FlightPrice? = nil
    @Published var lastUsedID: Int = 0
    var diadiem: [DiaDiem] = []
    private var db = Firestore.firestore()
    private var seatsCollection: CollectionReference {
        db.collection("seats")
    }

    init() {
        loadBookingStatusFromDatabase()
    }

    func bookSeat(_ seat: Seat) {
        if let seatIndex = seats.firstIndex(where: { $0.id == seat.id }) {
            seats[seatIndex].isBooked = true
            lastSelectedSeat = seat.seatNumber // Update the last selected seat
            updateBookingStatusInDatabase(seats[seatIndex])
        }
    }
        func saveVemaybayToFirestore(vemaybayData: vemaybay) {
            var thoigiandi = Date()
               var thoigianden = Date()
            do {
                       let db = Firestore.firestore()
                       var vemaybayData = vemaybayData
                        
                       vemaybayData.id = UUID().uuidString
                        vemaybayData.thoigiandi = thoigiandi
                       vemaybayData.thoigianden = thoigianden
                       let documentRef = db.collection("vemaybay").document(vemaybayData.id!)
                    
                       
                       try documentRef.setData(from: vemaybayData) { error in
                           if let error = error {
                               print("Error saving ticket: \(error)")
                           } else {
                               print("Ticket saved successfully!")
                               print("Thời gian đi: \(thoigiandi)")
                                             print("Thời gian đến: \(thoigianden)")
                           }
                       }
                   } catch {
                       print("Error encoding ticket data: \(error)")
                   }
        }
        



    func cancelSeatBooking(_ seat: Seat) {
        if let seatIndex = seats.firstIndex(where: { $0.id == seat.id }) {
            seats[seatIndex].isBooked = false
            updateBookingStatusInDatabase(seats[seatIndex])
        }
    }

    func updateBookingStatusInDatabase(_ seat: Seat) {
        do {
            try seatsCollection.document(seat.id!).setData(from: seat)
        } catch {
            print("Error updating booking status: \(error)")
        }
    }

    func loadBookingStatusFromDatabase() {
        let diadiemCollection = db.collection("diadiem")
        diadiemCollection.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.diadiem = documents.compactMap { document in
                try? document.data(as: DiaDiem.self)
            }
            self.selectedDiaDiem1 = self.diadiem.first
                    self.selectedDiaDiem2 = self.diadiem.last
        }
        seatsCollection.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.seats = documents.compactMap { document in
                try? document.data(as: Seat.self)
            }
        }
        let flightPriceCollection = db.collection("chitietgia")
        flightPriceCollection.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("loi")
                return
            }
            self.flightPrices = documents.compactMap { document in
                try? document.data(as: FlightPrice.self)
            }
           
            if let selectedFlightPrice = self.flightPrices.first,
               let selectedDiaDiemDi = self.diadiem.first(where: { $0.iddiadiem == selectedFlightPrice.iddiadiemdi }),
               let selectedDiaDiemDen = self.diadiem.first(where: { $0.iddiadiem == selectedFlightPrice.iddiadiemden }) {
                print("Giá vé máy bay: \(selectedFlightPrice.giave) VND")
                print("selectedFlightPrice: \(selectedFlightPrice)")
                self.selectedFlightPrice = selectedFlightPrice
              
            }
                
            
            
        }
        
    }
        internal func getSelectedFlightPrice() -> FlightPrice? {
            guard let selectedDiaDiem1 = selectedDiaDiem1,
                  let selectedDiaDiem2 = selectedDiaDiem2
            else {
                return nil
            }
            
            return self.flightPrices.first { price in
                price.iddiadiemdi == selectedDiaDiem1.iddiadiem && price.iddiadiemden == selectedDiaDiem2.iddiadiem
            }
        }
    }

    struct SeatSelectionView: View {
    @ObservedObject var seatManager = SeatManager()
     @EnvironmentObject var seatSelection: SeatSelection
        
     
     var body: some View {
         VStack {
             Text("Chọn chỗ")
                 .font(.title)
             
             // Hiển thị chỗ ngồi đã chọn
             Text("Chỗ ngồi đã chọn: \(seatSelection.selectedSeat ?? "")")
                 .foregroundColor(.blue)
                 .font(.headline)
             
             // Danh sách chỗ ngồi
             ScrollView {
                 LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                     ForEach(seatManager.seats) { seat in
                         Button(action: {
                             seatSelection.selectedSeat = seat.seatNumber
                         }) {
                             Text(seat.seatNumber)
                                 .font(.title)
                                 .padding()
                                 .background(seat.isBooked ? Color.gray : (seatSelection.selectedSeat == seat.seatNumber ? Color.blue : Color.gray))
                                 .foregroundColor(.white)
                                 .cornerRadius(8)
                         }
                     }
                 }
             }
         }
         .padding()
     }
    }

    struct Luggage {
    let weight: Int // Số kg hành lý
    var price: Int { // Giá tiền (computed property)
           calculatePrice(weight: weight)
       }
    private func calculatePrice(weight: Int) -> Int {
        let baseWeight = 19 // Số kg hành lý miễn phí
        let basePrice = 0 // Giá tiền cho số kg hành lý miễn phí
        let pricePerKg = 100000 // Giá tiền cho mỗi kg hành lý trên số kg hành lý miễn phí
        if weight <= baseWeight {
            return basePrice
        } else {
            let additionalWeight = max(weight - baseWeight, 0)
            let additionalPrice = (additionalWeight + 10) / 10 * pricePerKg
            return basePrice + additionalPrice
        }
    }
    }


    struct Booking: View {
        @State private var selectedVemaybay: vemaybay?
        @StateObject private var seatSelection = SeatSelection()
        @State private var luggageWeight: Int = 0
        @ObservedObject private var seatManager = SeatManager()
        @State private var vemaybayData = vemaybay()
        @State private var showPaymentView = false
        
        var selectedDiaDiem1: DiaDiem? {
            get { bookingEnvironment.selectedDiaDiem1 }
            set { bookingEnvironment.selectedDiaDiem1 = newValue }
        }
        
        var selectedDiaDiem2: DiaDiem? {
            get { bookingEnvironment.selectedDiaDiem2 }
            set { bookingEnvironment.selectedDiaDiem2 = newValue }
        }
        @EnvironmentObject private var bookingEnvironment: BookingEnvironment
        
        @FirestoreQuery(collectionPath: "chitietgia",
                        predicates: [.order(by: "giave")]
        ) var ten1:[FlightPrice]
        private var totalPrice: Int {
            let luggage = Luggage(weight: luggageWeight)
            return luggage.price
        }
        private var selectedFlightPrice: FlightPrice? {
            seatManager.getSelectedFlightPrice()
        }
        
        var body: some View {
            VStack {
                Text("\(ten1.count)")
                
                SeatSelectionView()
                    .environmentObject(seatSelection)
                
                Text("Thông tin hành lý")
                    .font(.title)
                
                Stepper(" \(luggageWeight) kg hành lý mang theo", value: $luggageWeight, in: 0...70)
                
                if let selectedFlightPrice = self.seatManager.selectedFlightPrice {
                    let price = selectedFlightPrice.giave
                    Text("Giá vé máy bay: \(price != nil ? "\(price)" : "") VND")
                        .font(.headline)
                        .padding()
                }
                
                
                Text("giá tiền hành lý: \(totalPrice) VND")
                    .font(.headline)
                    .padding()
                Text(seatManager.ticketBookingStatus)
                    .font(.headline)
                    .padding()
                
                Button(action: {
                   
                        
                    if let selectedFlightPrice = selectedFlightPrice,
                          let selectedDiaDiem1 = selectedDiaDiem1,
                          let selectedDiaDiem2 = selectedDiaDiem2,
                       let selectedSeat = seatSelection.selectedSeat {
                        
                        let newGiave = Float(selectedFlightPrice.giave)
                        vemaybayData = vemaybay(
                            id: UUID().uuidString,
                            giave: newGiave,
                            iddiadiemdi: selectedDiaDiem1.iddiadiem,
                            iddiadiemden: selectedDiaDiem2.iddiadiem,
                            idUser: 1,
                            idvemaybay: 1,
                            thoigiandi: vemaybayData.thoigiandi!,
                            thoigianden: vemaybayData.thoigianden!
                        )
                        
                        print("Selected Flight Price: \(selectedFlightPrice)")
                        print("Selected Dia Diem 1: \(selectedDiaDiem1)")
                        print("Selected Dia Diem 2: \(selectedDiaDiem2)")
                        print("Selected Seat: \(selectedSeat)")
                        
                        seatManager.saveVemaybayToFirestore(vemaybayData: vemaybayData)
                        showPaymentView = true
                    }
                      
                    
                    
                }) {
                    Text("Đặt vé")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showPaymentView) {
                    Payment(selectedVemaybay: $selectedVemaybay)
                        }
                
            }
            .padding()
            
        }

        
    }



    struct Booking_Previews: PreviewProvider {
        @State static var selectedDiaDiem1: DiaDiem? = nil
        @State static var selectedDiaDiem2: DiaDiem? = nil

    static var previews: some View {
     
        Booking()
                  .environmentObject(SeatSelection())
                  .environmentObject(SeatManager())  }
    }
