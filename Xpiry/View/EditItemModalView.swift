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
    @State private var expiryDate = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var stock: String = ""
    @State private var reminder: String = ""
    @State private var scanPresented = false
    @State private var image: Data = .init(count: 0)
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var overlay = false
    @State private var refresh = UUID()
    @State private var showTabBar = false
    @State private var showConsumeAlert = false
    @State private var showWasteAlert = false
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
                            Button {
                                overlay.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                                    .padding(.bottom, 10)
                            }
                         
                        }
                        TextField(item.name ?? " ", text: $name)
                            .padding(.leading, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(.black)
                                    .foregroundColor(.clear)
                                    .frame(height: 35)
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack {
                        DatePicker(selection: $expiryDate, displayedComponents: .date) {
                            Text("Expiry Date")
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                        }
                       
                }.padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Stock")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                            .padding(.bottom, 10)
                        
                        TextField(String(item.stock), text: $stock)
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
                            TextField(String(item.reminder), text: $reminder)
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
                        showConsumeAlert = true
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
                    .confirmationDialog("Select a color", isPresented: $showConsumeAlert, titleVisibility: .visible) {
                        Button("Consume 1") {
                            
                            item.name = item.name
                            item.expiry = item.expiry
                            item.image = item.image
                            item.reminder = item.reminder
                            if Date() >= expiryDate {
                                item.expired = true
                            } else {
                                item.expired = false
                            }
                            item.stock -= 1
                            
                            presentationMode.wrappedValue.dismiss()
                            
                            try! moc.save()
                            
                            print(item.stock)
                        }
                        
                        Button("Consume 5") {
                            
                            item.name = item.name
                            item.expiry = item.expiry
                            item.image = item.image
                            item.reminder = item.reminder
                            if Date() >= expiryDate {
                                item.expired = true
                            } else {
                                item.expired = false
                            }
                            item.stock -= 5
                            
                            presentationMode.wrappedValue.dismiss()
                            
                            try! moc.save()
                            
                            print(item.stock)
                        }
                        
                        Button("Consume All") {
                            
                            item.name = item.name
                            item.expiry = item.expiry
                            item.image = item.image
                            item.reminder = item.reminder
                            if Date() >= expiryDate {
                                item.expired = true
                            } else {
                                item.expired = false
                            }
                            item.stock -= item.stock
                            
                            presentationMode.wrappedValue.dismiss()
                            
                            try! moc.save()
                            
                            print(item.stock)
                        }
                    }
                    Spacer()
                    Button {
                        showWasteAlert = true
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
                    .confirmationDialog("Select a color", isPresented: $showWasteAlert, titleVisibility: .visible) {
                        Button("Waste 1") {
                            
//                            let product = Item(context: moc)
                            
                            item.name = item.name
                            item.expiry = item.expiry
                            item.image = item.image
                            item.reminder = item.reminder
                            if Date() >= expiryDate {
                                item.expired = true
                            } else {
                                item.expired = false
                            }
                            
                            item.stock -= 1
                            
                            presentationMode.wrappedValue.dismiss()
                            
                            try! moc.save()
                            
                            print(item.stock)
                        }
                        
                        Button("Waste 5") {
                           
                            
                            item.name = item.name
                            item.expiry = item.expiry
                            item.image = item.image
                            item.reminder = item.reminder
                            if Date() >= expiryDate {
                                item.expired = true
                            } else {
                                item.expired = false
                            }
                            item.stock -= 5
                            
                            presentationMode.wrappedValue.dismiss()
                            
                            try! moc.save()
                            
                            print(item.stock)
                        }
                        
                        Button("Waste All") {
                           
                            
                            item.name = item.name
                            item.expiry = item.expiry
                            item.image = item.image
                            item.reminder = item.reminder
                            if Date() >= expiryDate {
                                item.expired = true
                            } else {
                                item.expired = false
                            }
                            item.stock -= item.stock
                            
                            presentationMode.wrappedValue.dismiss()
                            
                            try! moc.save()
                            
                            print(item.stock)
                        }
                    }
                }.padding(.horizontal)
                
                Button {
                    
          
                    
                    if name.isEmpty {
                        item.name = item.name
                    } else if !name.isEmpty {
                        item.name = (name)
                    }
                    
                    if stock.isEmpty {
                        item.stock = item.stock
                    } else if !stock.isEmpty {
                        item.stock = Int16(stock) ?? Int16("")!
                    }
                    
                    if reminder.isEmpty {
                        item.reminder = item.reminder
                    } else if !reminder.isEmpty {
                        item.reminder = Int16(reminder) ?? Int16("")!
                    }
      
                    item.image = item.image
                    item.expiry = (expiryDate)
                    if Date() >= expiryDate {
                        item.expired = true
                    } else {
                        item.expired = false
                    }
                    
                    try! moc.save()
                    
                    presentationMode.wrappedValue.dismiss()
                    
                    print(item.name!)
                    print(item.expiry!)
                    print(item.stock)
                    print(item.reminder)
                    print(item.expired)
                    
                    self.name = ""
                    self.image.count = 0
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .frame(width: 200, height: 60)
                        
                        Text("Save")
                            .font(.system(size: 18, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .padding()
//                .disabled(name.isEmpty || stock.isEmpty || reminder.isEmpty)
                
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
