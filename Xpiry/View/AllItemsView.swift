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
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 150)
                        .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                    
                    HStack {
                        Text("All Items")
                            .font(.system(size: 30, design: .rounded))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.leading)
                        Spacer()
                        Button {
                            isPresented.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }   .fullScreenCover(isPresented: $isPresented, content: AddItemModalView.init)
                    }.padding(.bottom)
                        .padding(.trailing)
                    
                    if itemCondition == 0 {
                        SearchBarView(searchText: $searchText, containerText: "Find Items")
                            .offset(y:40)
                            .padding()
                    } else {
                        
                    }
                }
                
                Picker(" ", selection: $itemCondition) {
                    Text("All Items").tag(0)
                    Text("Expired Items").tag(1)
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
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(Color(red: 225/255, green: 85/255, blue: 84/255))
                                                    .shadow(radius: 5)
                                                    .frame(height: 95)
                                            } else {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 5)
                                                    .frame(height: 95)
                                            }
                                            
                                            HStack {
                                                Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 85, height: 85)
                                                    .clipShape(Circle())
                                                    .overlay(
                                                        Circle()
                                                            .strokeBorder(.black)
                                                    )
                                                VStack {
                                                    Text(item.name ?? " ")
                                                    Text(dateFormatter.string(from: item.expiry!))
                                                }
                                                Spacer()
                                                Text(String(item.stock))
                                                
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
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(Color(red: 225/255, green: 85/255, blue: 84/255))
                                                    .shadow(radius: 5)
                                                    .frame(height: 95)
                                            } else {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 5)
                                                    .frame(height: 95)
                                            }
                                            
                                            HStack {
                                                Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 85, height: 85)
                                                    .clipShape(Circle())
                                                    .overlay(
                                                        Circle()
                                                            .strokeBorder(.black)
                                                    )
                                                VStack {
                                                    Text(item.name ?? " ")
                                                    Text(dateFormatter.string(from: item.expiry!))
                                                }
                                                Spacer()
                                                Text(String(item.stock))
                                                
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                        .listRowSeparator(.hidden)
                                  
                                }
                                
                            }
                        }.onDelete(perform: deleteItems)
                            .listRowSeparator(.hidden)
                    }
                    .accentColor(.clear)
                    .listStyle(.inset)
                    
                } else {
                    List {
                        ForEach(items.filter {
                            $0.expired == true
                        }) { item in
//                            let lowSearch = searchText.lowercased()
//                            let lowProduct = item.name!.lowercased()
//                            if lowProduct.contains(lowSearch) {
                                NavigationLink {
                                    EditItemModalView(item: item)
                                } label: {
                               
                                        ZStack {
                                            
                                            if Date() >= item.expiry! {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(Color(red: 225/255, green: 85/255, blue: 84/255))
                                                    .shadow(radius: 5)
                                                    .frame(height: 95)
                                            } else {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 5)
                                                    .frame(height: 95)
                                            }
                                            
                                            HStack {
                                                Image(uiImage: UIImage(data: item.image ?? self.image)!)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 85, height: 85)
                                                    .clipShape(Circle())
                                                    .overlay(
                                                        Circle()
                                                            .strokeBorder(.black)
                                                    )
                                                VStack {
                                                    Text(item.name ?? " ")
                                                    Text(dateFormatter.string(from: item.expiry!))
                                                }
                                                Spacer()
                                                Text(String(item.stock))
                                                
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                        .listRowSeparator(.hidden)
                                   
                                    
                                }
                                
//                            } else if searchText.isEmpty {
//
//                                NavigationLink {
//                                    EditItemModalView(item: item)
//                                } label: {
//
//                                        ZStack {
//
//                                            if Date() >= item.expiry! {
//                                                RoundedRectangle(cornerRadius: 15)
//                                                    .foregroundColor(Color(red: 225/255, green: 85/255, blue: 84/255))
//                                                    .shadow(radius: 5)
//                                                    .frame(height: 95)
//                                            } else {
//                                                RoundedRectangle(cornerRadius: 15)
//                                                    .foregroundColor(.white)
//                                                    .shadow(radius: 5)
//                                                    .frame(height: 95)
//                                            }
//
//                                            HStack {
//                                                Image(uiImage: UIImage(data: item.image ?? self.image)!)
//                                                    .renderingMode(.original)
//                                                    .resizable()
//                                                    .frame(width: 85, height: 85)
//                                                    .clipShape(Circle())
//                                                    .overlay(
//                                                        Circle()
//                                                            .strokeBorder(.black)
//                                                    )
//                                                VStack {
//                                                    Text(item.name ?? " ")
//                                                    Text(dateFormatter.string(from: item.expiry!))
//                                                }
//                                                Spacer()
//                                                Text(String(item.stock))
//
//                                            }
//                                            .padding(.horizontal)
//
//                                        }
//                                        .listRowSeparator(.hidden)
//
//                                }
//
//                            }
                        }.onDelete(perform: deleteItems)
                            .listRowSeparator(.hidden)
                    }.listStyle(.inset)
                }
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .foregroundColor(Color(red:12/255, green: 91/255, blue: 198/255))
                        .padding(.top, 20)
                    
                }
            }
            .ignoresSafeArea()
            .preferredColorScheme(.light)
        }
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
