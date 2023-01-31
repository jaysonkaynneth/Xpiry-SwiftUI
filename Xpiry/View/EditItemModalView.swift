//
//  EditItemModalView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 07/12/22.
//

import SwiftUI
import Combine
import PhotosUI
import CoreData

struct EditItemModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    let item: Item
    
    @State private var name: String = ""
    @State private var expiryDate = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var reminderDate = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State private var stock: String = ""
    @State private var reminder: String = ""
    @State private var note: String = ""
    @State private var scanPresented = false
    @State private var image: Data = .init(count: 0)
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var stepperOverlay = false
    @State private var refresh = UUID()
    @State private var showTabBar = false
    @State private var showConsumeAlert = false
    @State private var showWasteAlert = false
    @State private var stockAlert = false
    @State private var quantity = 0
    
    
    
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
                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                    Spacer()
                    
                    Image(uiImage: UIImage(data: item.image ?? self.image)!)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                
                    
                    
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
                                .bold()
                                .padding(.bottom, 10)
                        }
                        TextField(item.name ?? " ", text: $name)
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
                            .bold()
                    }
                    .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                    
                }.padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Stock")
                            .font(Font.custom("DMSans-Medium", size: 18))
                            .bold()
                            .padding(.bottom, 10)
                        
                        TextField(String(item.stock), text: $stock)
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
                            .bold()
                            .padding(.bottom, 10)
                        
                        HStack {
                            TextField(String(item.reminder), text: $reminder)
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
                                .font(Font.custom("DMSans-Medium", size: 18))
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
                                .bold()
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
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    VStack {
                        HStack {
                            Text("Product Usage")
                                .font(Font.custom("DMSans-Medium", size: 18))
                                .bold()
                                .padding(.bottom, 10)
                            Button {
                                stepperOverlay.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                                    .padding(.bottom, 10)
                            }
                            .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                            Spacer()
                        }
                        HStack {
                            Stepper("", value: $quantity, in: 0...Int(item.stock))
                            Text("\(quantity)")
                            
                            Button {
                                showTabBar.toggle()
                                
                                    for _ in 1...quantity {
                                        consume()
                                    }
                               
                                item.name = item.name
                                item.expiry = item.expiry
                                item.image = item.image
                                item.reminder = item.reminder
                                item.note = item.note
                                if Date() >= expiryDate {
                                    item.expired = true
                                } else {
                                    item.expired = false
                                }
                                item.stock -= Int16(quantity)
                                
                                presentationMode.wrappedValue.dismiss()
                                
                                try! moc.save()
                                
                                print(item.stock)
                                
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 35)
                                        .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
                                        .frame(width: 120, height: 40)
                                    
                                    Text("Consumed")
                                        .font(Font.custom("DMSans-Medium", size: 18))
                                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                }
                            }.disabled(item.stock == 0 || quantity == 0)
                            
                            Button {
                                showTabBar.toggle()
                                
                                    for _ in 1...quantity {
                                        waste()
                                    }
                               
                                item.name = item.name
                                item.expiry = item.expiry
                                item.image = item.image
                                item.reminder = item.reminder
                                item.note = item.note
                                if Date() >= expiryDate {
                                    item.expired = true
                                } else {
                                    item.expired = false
                                }
                                item.stock -= Int16(quantity)
                                
                                presentationMode.wrappedValue.dismiss()
                                
                                try! moc.save()
                                
                                print(item.stock)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 35)
                                        .foregroundColor((Color(red: 251/255, green: 51/255, blue: 52/255)))
                                        .frame(width: 120, height: 40)
                                    
                                    Text("Wasted")
                                        .font(Font.custom("DMSans-Medium", size: 18))
                                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                }
                            }.disabled(item.stock == 0 || quantity == 0)
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Button {
                    showTabBar.toggle()
                    
                    
                    if name.isEmpty {
                        item.name = item.name
                    } else if !name.isEmpty {
                        item.name = (name)
                    }
                    
                    if stock.isEmpty {
                        item.stock = item.stock
                    } else if !stock.isEmpty {
                        item.stock = Int16(stock) ?? 0
                    }
                    
                    if reminder.isEmpty {
                        item.reminder = item.reminder
                    } else if !reminder.isEmpty {
                        item.reminder = Int16(reminder) ?? 0
                    }
                    
                    if note.isEmpty {
                        item.note = item.note
                    } else if !note.isEmpty {
                        item.note = (note)
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
                    
                    let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
                    
                    do {
                        let user = try moc.fetch(userFetchRequest)
                        let users = user[0]
                        let content = UNMutableNotificationContent()
                        print(users.name ?? "")
                        content.title = "Item is about to expire!"
                        content.subtitle = "\(users.name ?? "")! your \(item.name ?? "") is gonna expire, better use it soon!"
                        content.sound = UNNotificationSound.default
                        
                        let dateComponent = Calendar.current.dateComponents([.month, .day, .hour], from: expiryDate)
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                        
                        print("REMINDER SET TO:\(dateComponent)")
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request)
                        
                        self.reminderDate = expiryDate
                        remindBefore(-Int(item.reminder))
                        
                        let remContent = UNMutableNotificationContent()
                        print(users.name ?? "")
                        remContent.title = "Item is about to expire!"
                        remContent.subtitle = "\(users.name ?? "")! your \(item.name ?? "") is gonna expire in \(item.reminder) day(s)!"
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
                //                .disabled(name.isEmpty || stock.isEmpty || reminder.isEmpty)
                
            }.padding(.top)
        }
        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
        .preferredColorScheme(.light)
        .overlay(secretOverlay)
        .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .onTapGesture {
            self.endTextEditing()
        }
        .onAppear {
            self.name = item.name ?? ""
            self.stock = String(item.stock)
            self.reminder = String(item.reminder)
            self.note = item.note ?? ""
            self.expiryDate = item.expiry ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        }
    }
    func consume() {
        let consume = Consume(context: moc)
        
        consume.consumed += 1
    }
    
    func waste() {
        let waste = Waste(context: moc)
        
        waste.wasted += 1
    }
    
    func remindBefore(_ days: Int) {
        if let date = Calendar.current.date(byAdding: .day, value: days, to: reminderDate) {
            self.reminderDate = date
        }
    }
    
    @ViewBuilder private var secretOverlay: some View {
        ZStack{
            if stepperOverlay {
                StepperOverlayView().onTapGesture {
                    stepperOverlay.toggle()
                }
            }
        }
    }
}
