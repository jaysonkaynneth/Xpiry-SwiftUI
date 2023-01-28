//
//  ScannerModalView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 07/12/22.
//

import SwiftUI
import Combine
import AVFoundation
import CarBode

struct AddSLModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    @Binding var showModal: Bool
    @State private var itemName: String = ""
    @State private var itemStock: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Item Name")
                            .font(.system(size: 18, design: .rounded))
                            .bold()
                            .padding(.bottom, 10)
                    }
                    
                    TextField("", text: $itemName)
                        .tint(Color(red: 65/255, green: 146/255, blue: 255/255))
                        .padding(.leading, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(.black)
                                .foregroundColor(.clear)
                                .frame(height: 35)
                        ).padding(.bottom)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Quantity")
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                                .padding(.bottom, 10)
                            
                            TextField("", text: $itemStock)
                                .tint(Color(red: 65/255, green: 146/255, blue: 255/255))
                                .keyboardType(.numberPad)
                                .onReceive(Just(itemStock)) { input in
                                    let filtered = input.filter { "0123456789".contains($0) }
                                    if filtered != input {
                                        self.itemStock = filtered
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
                    }
                }.padding()
                
                Spacer()
                
                Button {
                    let sItem = ShoppingItem(context: moc)
                    sItem.name = (itemName)
                    sItem.stock = Int16(itemStock) ?? Int16("")!

                    presentationMode.wrappedValue.dismiss()
                    try? moc.save()
                    print(sItem.name!)
                    print(sItem.stock)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .frame(width: 200, height: 60)
                        
                        Text("Save")
                            .font(.system(size: 18, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                .disabled(itemName.isEmpty || itemStock.isEmpty)
            }.navigationTitle(Text("Add an Item"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
      
                }
            }
        }
    }
}

struct ScannerModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddSLModalView(showModal: .constant(true))
    }
}
