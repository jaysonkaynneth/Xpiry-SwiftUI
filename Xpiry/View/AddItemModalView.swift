//
//  AddItemView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 22/12/22.
//

import SwiftUI
import Combine
import PhotosUI
import CoreData

struct AddItemModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var name: String = ""
    @State private var expiryDate = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var reminderDate = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var stock: String = ""
    @State private var reminder: String = ""
    @State private var note: String = ""
    @State private var scanPresented = false
    @State private var image: Data = .init(count: 0)
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var overlay = false
    @State private var notifAllowed = false
    @State private var placeHolderImage: Data = .init(count: 0)
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }
                    .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
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
                                   
                            }
                        } else {
                            Image("ImagePlaceHolder")
                                .resizable()
                                .frame(width: 130, height: 130)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                                .foregroundColor(.black)
                                .clipShape(Circle())
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
                                .font(Font.custom("DMSans-Medium", size: 18))
                                .padding(.bottom, 10)
                            Button {
                                overlay.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                                    .padding(.bottom, 10)
                            }.tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                            
                        }
                        TextField("", text: $name)
                            .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                            .padding(.leading, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
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
                            .font(Font.custom("DMSans-Medium", size: 18))
                    }
                    .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                    
                }.padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Stock")
                            .font(Font.custom("DMSans-Medium", size: 18))
                            .padding(.bottom, 10)
                        
                        TextField("", text: $stock)
                            .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
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
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                                    .frame(height: 35)
                            )
                    }
                    Spacer()
                }.padding(.horizontal)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Reminder")
                            .font(Font.custom("DMSans-Medium", size: 18))
                            .padding(.bottom, 10)
                        
                        HStack {
                            TextField("", text: $reminder)
                                .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
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
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                                        .frame(height: 35)
                                )
                            
                            Text("Day(s) before expiring")
                                .font(Font.custom("DMSans-Regular", size: 18))
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Note")
                                .font(Font.custom("DMSans-Medium", size: 18))
                                .padding(.bottom, 10)
                        }
                        TextField("", text: $note)
                            .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                            .padding(.leading, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                                    .frame(height: 35)
                            )
                    }
                    Spacer()
                }.padding()
                
                Spacer()
                
                Button {
                    let product = Item(context: moc)
                    
                    product.name = (name)
                    product.expiry = (expiryDate)
                    product.image = (image)
                    product.stock = Int16(stock) ?? 0
                    product.reminder = Int16(reminder) ?? 0
                    product.note = (note)
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
                    
                    self.reminderDate = expiryDate
                    self.name = ""
                    self.image.count = 0
                    
                    notifRequest()
                    
                    let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
                    
                 do {
                     let user = try moc.fetch(userFetchRequest)
                     let users = user[0]
                     let content = UNMutableNotificationContent()
                     print(users.name ?? "")
                     content.title = "Item Expired!"
                     content.subtitle = "\(users.name ?? "")! your \(product.name ?? "") has expired!"
                     content.sound = UNNotificationSound.default
                     
                     let dateComponent = Calendar.current.dateComponents([.month, .day, .hour], from: expiryDate)
                     
                     let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                     
                     print("REMINDER SET TO:\(dateComponent)")
                     
                     let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                     
                     UNUserNotificationCenter.current().add(request)
                     
                     self.reminderDate = expiryDate
                     remindBefore(-Int(product.reminder))
                     
                     let remContent = UNMutableNotificationContent()
                     print(users.name ?? "")
                     remContent.title = "Item is about to expire!"
                     remContent.subtitle = "\(users.name ?? "")! your \(product.name ?? "") is gonna expire in \(product.reminder) day(s)!"
                     remContent.sound = UNNotificationSound.default
                     
                     let remDateComp = Calendar.current.dateComponents([.month, .day, .hour], from: reminderDate)
                     
                     let remTrigger = UNCalendarNotificationTrigger(dateMatching: remDateComp, repeats: false)
                     
                     print("REMBEFORE SET TO:\(remDateComp)")
                     
                     let remRequest = UNNotificationRequest(identifier: UUID().uuidString, content: remContent, trigger: remTrigger)
                     
                     UNUserNotificationCenter.current().add(remRequest)
                 }
                    catch {
                        print(error.localizedDescription)
                    }
                    
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .frame(width: 200, height: 60)
                        
                        Text("Save")
                            .font(Font.custom("DMSans-Medium", size: 18))
                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                    }
                }
                .foregroundColor(Color(red: 33/255, green: 177/255, blue: 108/255))
                .padding()
                .disabled(name.isEmpty || stock.isEmpty || reminder.isEmpty || image.isEmpty)
            }.padding(.top)
        }
        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
        .preferredColorScheme(.light)
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
    
    func notifRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Success")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func remindBefore(_ days: Int) {
        if let date = Calendar.current.date(byAdding: .day, value: days, to: reminderDate) {
            self.reminderDate = date
        }
    }
}

struct AddItemModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemModalView()
    }
}
