//
//  AddItemView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 22/12/22.
//

import SwiftUI
import Combine
import PhotosUI

struct AddItemModalView: View {
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
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }
                    Spacer()
                    PhotosPicker(selection: $selectedItems,
                                 maxSelectionCount: 1,
                                 matching: .images) {
                        if selectedItems.count != 0 {
                            if let data = image, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .clipShape(Circle())
                                    .overlay(
                                      Circle()
                                          .strokeBorder(.black)
                                    )
                            }
                        } else {
                            Image(systemName: "photo.circle")
                                .resizable()
                                .frame(width: 130, height: 130)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                                .overlay(
                                  Circle()
                                      .strokeBorder(.black)
                                )
                            
                        }
                    }
                    
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
                        TextField("", text: $name)
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
                        
                        TextField("", text: $stock)
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
                            TextField("", text: $reminder)
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
                
                    Button {
                        let product = Item(context: moc)
                        let usage = UsageReport(context: moc)
                        product.name = (name)
                        product.expiry = (expiryDate)
                        product.image = (image)
                        product.stock = Int16(stock) ?? Int16("")!
                        product.reminder = Int16(reminder) ?? Int16("")!
                        if Date() >= expiryDate {
                            product.expired = true
                        } else {
                            product.expired = false
                        }
                        
                        try! moc.save()
                        presentationMode.wrappedValue.dismiss()
                        print(product.name!)
                        print(product.expiry!)
                        print(product.stock)
                        print(product.reminder)
                        print(product.expired)
                        
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
                    .disabled(name.isEmpty || stock.isEmpty || reminder.isEmpty || image.isEmpty)
            }.padding(.top)
        }  .overlay(secretOverlay)
            .onTapGesture {
                self.endTextEditing()
            }
    }
    
    
    @ViewBuilder private var secretOverlay: some View {
        ZStack{
            if overlay {
                OverlayView().onTapGesture {
                    overlay.toggle()
                }
            }
        }
    }
}

struct AddItemModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemModalView()
    }
}
