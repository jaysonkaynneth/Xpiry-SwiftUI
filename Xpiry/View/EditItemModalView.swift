//
//  EditItemModalView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 07/12/22.
//

import SwiftUI
import Combine
import PhotosUI

struct EditItemModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var name: String = ""
    @State private var expiryDate = Date.now
    @State private var stock: String = ""
    @State private var reminder: String = ""
    @State private var scanPresented = false
    @State private var image: Data = .init(count: 0)
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var overlay = false
    @State private var refresh = UUID()
    @State private var showTabBar = false
    
    let item: Item
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        showTabBar.toggle()
                    } label: {
                        Text("Back")
                    }
                    Spacer()
            
                            Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .strokeBorder(.black)
                                )
                   
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.clear)
                        .padding(.leading)
                }.padding(.horizontal)
                
                    .onChange(of: selectedItems) { new in
                        guard let items = selectedItems.first else { return
                            
                        }
                        
                        items.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.image = data
                                } else {
                                    print("No data :(")
                                }
                            case .failure(let error):
                                fatalError("\(error)")
                            }
                        }
                        
                    }
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Product Name")
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                                .padding(.bottom, 10)
                        }
                        ZStack {
                            TextField("", text: $name)
                                .disabled(true)
                                .padding(.leading, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(.black)
                                        .foregroundColor(.clear)
                                        .frame(height: 35)
                                )
                            HStack {
                                Text(item.name!)
                                Spacer()
                            }.padding(.leading)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack {
                    ZStack {
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 120, height: 30)
                                .foregroundColor(Color(red: 230/255, green: 232/255, blue: 230/255))
                        }
                        DatePicker(selection: $expiryDate, displayedComponents: .date) {
                            Text("Expiry Date")
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                        }.disabled(true)
                    }
                    Spacer()
                }.padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Stock")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                            .padding(.bottom, 10)
                        ZStack {
                                TextField("", text: $stock)
                                    .disabled(true)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(stock)) { input in
                                        let filtered = input.filter { "0123456789".contains($0) }
                                        if filtered != input {
                                            self.stock = filtered
                                        }
                                    }
                                    .frame(width: 80)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(.black)
                                            .foregroundColor(.clear)
                                            .frame(height: 35)
                                    )
                            Text(String(item.stock))
                        }
                    }
                    Spacer()
                }.padding(.horizontal)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Reminder")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                            .padding(.bottom, 10)
                        
                        HStack {
                            ZStack {
                            TextField("", text: $reminder)
                                .disabled(true)
                                .keyboardType(.numberPad)
                                .onReceive(Just(reminder)) { input in
                                    let filtered = input.filter { "0123456789".contains($0) }
                                    if filtered != input {
                                        self.reminder = filtered
                                    }
                                }
                                .frame(width: 40)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(.black)
                                        .foregroundColor(.clear)
                                        .frame(height: 35)
                                )
                                Text(String(item.reminder))
                        }
                            Text("Day(s) before expiring")
                                .font(.system(size: 18, design: .rounded))
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                HStack {
                    Button {
                        let product = Item(context: moc)
                        
                        item.stock -= 1
                        
                        
                        presentationMode.wrappedValue.dismiss()
                        
                        try! moc.save()
                        
                        print(product.stock)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 35)
                                .foregroundColor(Color(red: 59/255, green: 178/255, blue: 115/255))
                                .frame(width: 150, height: 60)
                            
                            Text("Consumed")
                                .font(.system(size: 18, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    Button {
                        let product = Item(context: moc)

                     
                        product.expiry = item.expiry
                        product.image = item.image
                        product.stock = item.stock
                        product.reminder = item.reminder
                        
                        presentationMode.wrappedValue.dismiss()
                        
                        try! moc.save()
                        
                        print(product.name!)
                        print(product.expiry!)
                        print(product.stock)
                        print(product.reminder)
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 35)
                                .foregroundColor(Color(red: 225/255, green: 85/255, blue: 84/255))
                                .frame(width: 150, height: 60)
                            
                            Text("Wasted")
                                .font(.system(size: 18, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                }.padding(.horizontal)
                
            }.padding(.top)
        }
        .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .onTapGesture {
            self.endTextEditing()
        }
    }
}
