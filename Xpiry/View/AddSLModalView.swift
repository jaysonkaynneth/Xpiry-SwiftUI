//
//  ScannerModalView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 07/12/22.
//

import SwiftUI
import CoreData
import Combine
import AVFoundation

struct AddSLModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @Binding var showModal: Bool
    
    @State private var itemName: String = ""
    @State private var itemStock: String = ""
    @State private var productName = [String]()
    @State private var productStock = [Int16]()
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Add Item")
                .font(Font.custom("DMSans-Bold", size: 18))
                .padding()
            VStack(alignment: .leading) {
                HStack {
                    Text("Item Name")
                        .font(Font.custom("DMSans-Medium", size: 18))
                        .padding(.bottom, 10)
                }
                
                TextField("", text: $itemName)
                    .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                    .padding(.leading, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                            .frame(height: 35)
                    ).padding(.bottom)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Quantity")
                            .font(Font.custom("DMSans-Medium", size: 18))
                            .padding(.bottom, 10)
                        
                        TextField("", text: $itemStock)
                            .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
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
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                                    .frame(height: 35)
                            )
                    }
                    Spacer()
                }
                
            }.padding()
            
            Spacer()
            
   
            Button {
                
                
                let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name LIKE [c] %@ AND stock > 5", itemName)
                
                do
                {
                    let items = try moc.fetch(fetchRequest)
                    
                    guard items.isEmpty
                    else {
                        showAlert = true
                        return
                    }
                    
                    let shoppingFetchRequest: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
                    shoppingFetchRequest.predicate = NSPredicate(format: "name LIKE [c] %@", itemName)
                    
                    let shoppingItem = try moc.fetch(shoppingFetchRequest)
                    
                    if shoppingItem.isEmpty {
                        let sItem = ShoppingItem(context: moc)
                        sItem.name = (itemName)
                        sItem.stock = Int16(itemStock) ?? 0
                    }
                    else {
                        let item = shoppingItem[0]
                        item.stock += Int16(itemStock) ?? 0
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                    
                    try? moc.save()
                }
                catch
                {
                    print(error.localizedDescription)
                }
                
                
            }label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .frame(width: 200, height: 60)
                    
                    Text("Save")
                        .font(Font.custom("DMSans-Medium", size: 18))
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("You already have that item!"),
                    message: Text("Are you sure you want to buy it again?"),
                    primaryButton: .destructive(Text("Yes"), action: {
                        let sItem = ShoppingItem(context: moc)
                        sItem.name = (itemName)
                        sItem.stock = Int16(itemStock) ?? Int16("")!
                        presentationMode.wrappedValue.dismiss()
                    }),
                    secondaryButton: .cancel(Text("No"), action: {
                        let sItem = ShoppingItem(context: moc)
                        let deleteObject = sItem
                        self.moc.delete(deleteObject)
                        showAlert = false
                    })
                )
            }
    //            .actionSheet(isPresented: $showAlert) {
    //                ActionSheet(title: Text("You already have that item!"),
    //                            message: Text("Are you sure you want to buy it again?"),
    //                            buttons: [
    //                                .cancel(),
    //                                .default(
    //                                    Text("Yes"),
    //                                    action: {
    //                                        let sItem = ShoppingItem(context: moc)
    //                                        sItem.name = (itemName)
    //                                        sItem.stock = Int16(itemStock) ?? Int16("")!
    //
    //                                        try? moc.save()
    //
    //                                        presentationMode.wrappedValue.dismiss()
    //                                        print(sItem.name!)
    //                                        print(sItem.stock)
    //                                    }),
    //                                .destructive(
    //                                    Text("No"),
    //                                    action: {
    //                                        showAlert = false
    //                                    }
    //                                )
    //                            ]
    //                )
    //            }
            .foregroundColor(Color(red: 33/255, green: 177/255, blue: 108/255))
            .disabled(itemName.isEmpty || itemStock.isEmpty || Int(itemStock) ?? 0 == 0)

        }
        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
        .preferredColorScheme(.light)
    }
}

struct AddSLModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddSLModalView(showModal: .constant(true))
    }
}
