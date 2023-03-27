//
//  ContentView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 29/11/22.
//

import SwiftUI
import CoreData

struct AllItemsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @State private var searchText = ""
    @State private var isPresented = false
    @State private var itemPressed = false
    @State private var image: Data = .init(count: 0)
    @State private var itemCondition = 0
    @State private var refresh = UUID()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .frame(height: 150)
                        .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
                    
                    HStack {
                        if itemCondition == 0 {
                            Text("All Items")
                                .font(Font.custom("DMSans-Bold", size: 30))
                                .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                .bold()
                                .padding(.leading)
                        } else {
                            Text("All Items")
                                .font(Font.custom("DMSans-Bold", size: 30))
                                .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                .bold()
                                .padding(.leading)
                                .padding(.top, 50)
                        }
                        Spacer()
                        Button {
                            isPresented.toggle()
                        } label: {
                            ZStack {
                                if itemCondition == 0 {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                        .frame(width: 25, height: 25)
                                } else {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 50)
                                }
                            }
                        }   .fullScreenCover(isPresented: $isPresented, content: AddItemModalView.init)
                    }.padding(.bottom)
                        .padding(.trailing)
                    
                    if itemCondition == 0 {
                        SearchBarView(searchText: $searchText, containerText: "Search")
                            .offset(y:40)
                            .padding()
                    } else {
                        
                    }
                }
                
                Picker(" ", selection: $itemCondition) {
                    Text("All Items")
                        .tag(0)
                    Text("Expired Items")
                        .tag(1)
                }
                .padding()
                .pickerStyle(.segmented)
                
                if itemCondition == 0 {
                    List {
                        ForEach(items) { item in
                            let lowSearch = searchText.lowercased()
                            let lowProduct = item.name!.lowercased()
                            if lowProduct.contains(lowSearch) {
                                NavigationLink {
                                    EditItemModalView(item: item).onDisappear { refresh = UUID() }
                                } label: {
                                        ZStack {
                                            
                                            if Date() >= item.expiry! {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .foregroundColor(Color(red: 225/255, green: 51/255, blue: 52/255))
                                                    .shadow(radius: 5, x: 0, y: 4)
                                                    .frame(height: 95)
                                            } else {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                    .shadow(radius: 5, x: 0, y: 4)
                                                    .frame(height: 95)
                                            }
                                            
                                            HStack {
                                                if Date() >= item.expiry! {
                                                    Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .frame(width: 85, height: 85)
                                                        .clipShape(Circle())
                                                    
                                                    VStack {
                                                        Text(item.name ?? " ")
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                        Text(dateFormatter.string(from: item.expiry!))
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                    }
                                                    Spacer()
                                                    Text(String(item.stock))
                                                        .font(Font.custom("DMSans-Regular", size: 18))
                                                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                } else {
                                                    Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .frame(width: 85, height: 85)
                                                        .clipShape(Circle())
                                                    
                                                    VStack {
                                                        Text(item.name ?? " ")
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                        Text(dateFormatter.string(from: item.expiry!))
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                    }
                                                    Spacer()
                                                    Text(String(item.stock))
                                                        .font(Font.custom("DMSans-Regular", size: 18))
                                                }
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                        .listRowSeparator(.hidden)
                                   
                                }
                       
                            } else if searchText.isEmpty {
                                
                                NavigationLink {
                                    EditItemModalView(item: item)
                                } label: {
                              
                                        ZStack {
                                            
                                            if Date() >= item.expiry! {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .foregroundColor(Color(red: 251/255, green: 51/255, blue: 52/255))
                                                    .shadow(radius: 5, x: 0, y: 4)
                                                    .frame(height: 95)
                                                    .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                                            } else {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                    .shadow(radius: 5, x: 0, y: 4)
                                                    .frame(height: 95)
                                                    .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                                            }
                                            
                                            HStack {
                                                if Date() >= item.expiry! {
                                                    Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .frame(width: 85, height: 85)
                                                        .clipShape(Circle())
                                                    
                                                    VStack {
                                                        Text(item.name ?? " ")
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                        Text(dateFormatter.string(from: item.expiry!))
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                    }
                                                    Spacer()
                                                    Text(String(item.stock))
                                                        .font(Font.custom("DMSans-Regular", size: 18))
                                                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                } else {
                                                    Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .frame(width: 85, height: 85)
                                                        .clipShape(Circle())
                                                    
                                                    VStack {
                                                        Text(item.name ?? " ")
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                        Text(dateFormatter.string(from: item.expiry!))
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                    }
                                                    Spacer()
                                                    Text(String(item.stock))
                                                        .font(Font.custom("DMSans-Regular", size: 18))
                                                }
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                        .listRowSeparator(.hidden)
                                  
                                }
                           
                                
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                        .listRowSeparator(.hidden)
                            
                    }
                    .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                    .scrollContentBackground(.hidden)
                    .accentColor(.clear)
                    .listStyle(.inset)
                    
                } else {
                    List {
                        ForEach(items.filter {
                            $0.expired == true
                        }) { item in
                                NavigationLink {
                                    EditItemModalView(item: item)
                                } label: {
                               
                                        ZStack {
                                            
                                            if Date() >= item.expiry! {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .foregroundColor(Color(red: 251/255, green: 51/255, blue: 52/255))
                                                    .shadow(radius: 5, x: 0, y: 4)
                                                    .frame(height: 95)
                                                    .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                                            } else {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                    .shadow(radius: 5, x: 0, y: 4)
                                                    .frame(height: 95)
                                                    .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                                            }

                                            HStack {
                                                if Date() >= item.expiry! {
                                                    Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .frame(width: 85, height: 85)
                                                        .clipShape(Circle())
                                                    
                                                    VStack {
                                                        Text(item.name ?? " ")
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                        Text(dateFormatter.string(from: item.expiry!))
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                    }
                                                    Spacer()
                                                    Text(String(item.stock))
                                                        .font(Font.custom("DMSans-Regular", size: 18))
                                                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                                                } else {
                                                    Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .frame(width: 85, height: 85)
                                                        .clipShape(Circle())
                                                    
                                                    VStack {
                                                        Text(item.name ?? " ")
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                        Text(dateFormatter.string(from: item.expiry!))
                                                            .font(Font.custom("DMSans-Regular", size: 18))
                                                    }
                                                    Spacer()
                                                    Text(String(item.stock))
                                                        .font(Font.custom("DMSans-Regular", size: 18))
                                                }
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                        .listRowSeparator(.hidden)
                                   
                                    
                                }
                                .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                        }
                        .onDelete(perform: deleteItems)
                        .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                        .listRowSeparator(.hidden)
                        
                    }
                    .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                    .scrollContentBackground(.hidden)
                    .listStyle(.inset)
             
                }
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .frame(height: 100)
                        .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
                        .padding(.top, 20)
                }
            }
            .background(Color(red: 252/255, green: 250/255, blue: 250/255))
            .ignoresSafeArea()
            .preferredColorScheme(.light)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(moc.delete)
            
            do {
                try moc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
}
struct AllItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AllItemsView()
    }
}
