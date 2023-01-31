//
//  AddItemModalView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 07/12/22.
//

import SwiftUI
import Combine

struct AddItemTestView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    @State private var image = UIImage()
    @State private var name: String = ""
    @State private var expiryDate = Date.now
    @State private var stock: String = ""
    @State private var reminder: String = ""
    @State private var scanPresented = false
    @State private var showImagePicker = false
    
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
                    
                    Image(uiImage: self.image)
                      .resizable()
                      .cornerRadius(50)
                      .frame(width: 130, height: 130)
                      .padding(.horizontal)
                      .aspectRatio(contentMode: .fill)
                      .clipShape(Circle())
                      .overlay(
                        Circle()
                            .strokeBorder(.black)
                      )
                    
                    Spacer()
                    
                    Button {
                        scanPresented.toggle()
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                 
                }.padding(.horizontal)
                
                Button {
                    showImagePicker = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 150, height: 30)
                        Text("Add an Image")
                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                            .font(.system(size: 18, design: .rounded))
                    }
                }.padding(.leading, 10)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Product Name")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                            .padding(.bottom, 10)
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
                    VStack(alignment: .leading) {
                        DatePicker(selection: $expiryDate, displayedComponents: .date) {
                            Text("Expiry Date")
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                        }
                    }
                    Spacer()
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
                    let item = Item(context: moc)
                    item.name = (name)
                    item.expiry = (expiryDate)
                    item.stock = Int16(stock) ?? Int16("")!
                    item.reminder = Int16(reminder) ?? Int16("")!
                    presentationMode.wrappedValue.dismiss()
                    try? moc.save()
                    print(item.name!)
                    print(item.expiry!)
                    print(item.stock)
                    print(item.reminder)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .frame(width: 200, height: 60)
                        
                        Text("Save")
                            .font(.system(size: 18, design: .rounded))
                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                    }
                }
                .disabled(name.isEmpty || stock.isEmpty || reminder.isEmpty)
                .padding(.bottom)
            }
            .preferredColorScheme(.light)
            .padding(.top)
        }
        .sheet(isPresented: $showImagePicker) {
                    // Pick an image from the photo library:
//                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)

                    //  If you wish to take a photo from camera instead:
                     ImagePicker(sourceType: .camera, selectedImage: self.$image)
            }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}

struct AddItemTestView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemTestView()
    }
}
