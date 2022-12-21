//
//  EditItemModalView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 07/12/22.
//

import SwiftUI
import Combine

struct EditItemModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    @State private var name: String = ""
    @State private var expiryDate = Date.now
    @State private var stock: String = ""
    @State private var reminder: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Back")
                }
                
                    Spacer()
                
                Circle()
                    .strokeBorder(.black)
                    .frame(width: 130, height: 130)
                    .foregroundColor(.clear)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }.padding(.horizontal)
            
            Button {
                
            } label: {
                Text("Add an Image")
                    .underline()
                    .font(.system(size: 18, design: .rounded))
            }
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
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom)
        }
        .preferredColorScheme(.light)
        .padding(.top)
    }
}

struct EditItemModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemModalView()
    }
}
