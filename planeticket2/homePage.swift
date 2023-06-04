//
//  homePage.swift
//  planeticket2
//
//  Created by DoanThinh on 5/16/23.
//

import SwiftUI
struct Boximage:Identifiable{
    var id: Int
    let title,imageText: String
}
struct homePage: View {
    @State private var search: String = ""
    @State private var showFind = false
    @State private var showdoithongtin = false

    let  boxes = [
        Boximage(id:0,title:"Hà Nội",imageText: "0"),
        Boximage(id:1,title:"Nha Trang",imageText: "1"),
        Boximage(id:2,title:"Phú Quốc",imageText: "2"),
        Boximage(id:3,title:"Sài Gòn",imageText: "3")
    ]
    var body: some View {
        NavigationView {
            
            
            
            VStack {
                Spacer().frame(height: 150)
                VStack{
                    HStack{
                        Spacer().frame(width: 10)
                        VStack(alignment: .leading){
                            Text("hello,")
                                .multilineTextAlignment(.center)
                            
                                .foregroundColor(Color.gray)
                            Text("Vung tau")
                                .multilineTextAlignment(.leading)
                               
                                .font(.title)
                            Spacer().frame(height: 20)
                        }
                        
                        Spacer()
                    }
                }
                .opacity(0.7)
                .padding( 40)
                .frame(width: 340, height: 100)
                .background(Color.white)
                .cornerRadius(30)
                
                Spacer().frame(height: 30)
                Text("Ban muon di dau")
                    .font(.system(size: 20))
                    .padding(20)
                    .multilineTextAlignment(.leading)
                
                ScrollView{
                    HStack{
                        ForEach(boxes){Boximage in boxview(boximagen:  Boximage)
                        }
                    }
                }
                .frame(width: 2000)
               
                Text("Tìm kiếm vé máy bay tốt nhất")
                    .font(.title)
                    .padding(20)
                
                Button(action: {
                    showFind = true
                }) {
                    Text("Tìm kiếm")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showFind) {
                    viewFindPlane()
                }
                
                Spacer()
                
                Text("Phổ biến")
                    .font(.title)
                    .padding(.horizontal)
                
                Button(action: {
                    showdoithongtin = true
                    let window = UIApplication
                                            .shared
                                            .connectedScenes
                                            .flatMap{($0 as? UIWindowScene)?.windows ?? [] }
                                            .first { $0.isKeyWindow}
                                        
                                        window?.rootViewController = UIHostingController(rootView: UserInformation())
                                        window?.makeKeyAndVisible()
                                    }
                                    ) {
                                        Text("Doi mat khau")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.green)
                                            .cornerRadius(10)
                                    }
                                    
                                  
                                }
                                .background(
                                    Image("background")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill )
                                )
                                
                               
                                .tabItem {
                                    Image(systemName: "house")
                                    Text("Trang chủ")
                                }
                                
                                Contact()
                                    .tabItem {
                                        Image(systemName: "phone")
                                        Text("Liên hệ")
                                    }
                              
                                UserIf()
                                                .tabItem {
                                        Image(systemName: "person")
                                        Text("Tài khoản")
                                    }
                               
                            }
                            
                        }
                    }

                    struct homePage_Previews: PreviewProvider {
                        static var previews: some View {
                            homePage()
                        }
                    }


                    struct boxview: View{
                        let boximagen : Boximage
                        var body:some View{
                            ZStack(alignment: .topLeading){
                                Image(boximagen.imageText)
                                    .resizable()
                                    .frame(width: 170,height: 220)
                                    .cornerRadius(20)
                                    .opacity(0.9)
                                    .aspectRatio(contentMode: .fit)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white,lineWidth: 10)
                                    )
                                Text(boximagen.title)
                                
                                    .foregroundColor(.black)
                                    .padding(15)
                                    .font(.system(size: 25))
                                    .fontWeight(.semibold)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                
                                
                            }
                            .padding(10)
                        }
                    }
