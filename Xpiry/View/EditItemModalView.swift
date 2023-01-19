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
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    
    @State private var name: String = ""
    @State private var expiryDate = Date.now
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
                            .disabled(true)
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
                    }.disabled(true)
                    
                    Spacer()
                }.padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Stock")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                            .padding(.bottom, 10)
                        
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
                        
                        product.stock = Int16(stock) ?? Int16("")!

                        
                        presentationMode.wrappedValue.dismiss()
                        
                        try! moc.save()
        
                        print(product.stock)
                
                        self.image.count = 0
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
                        
                        product.stock = Int16(stock) ?? Int16("")!

                        presentationMode.wrappedValue.dismiss()
                        
                        try! moc.save()
        
                        print(product.stock)
                     
                        self.image.count = 0
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
//        .onAppear {
//            let product = Item(context: moc)
//
//            name = product.name!
//        }
        
        .overlay(secretOverlay)
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

struct EditItemModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemModalView()
    }
}
