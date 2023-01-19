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
    @State private var itemType = 0
    
    var body: some View {
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 150)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("All Items")
                        .font(.system(size: 30, design: .rounded))
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
                
                SearchBarView(searchText: $searchText, containerText: "Find Items")
                    .offset(y:40)
                    .padding()
            }
            
            Picker("What is your favorite color?", selection: $itemType) {
                Text("All Items").tag(0)
                Text("Expired Items").tag(1)
            }
            .padding()
            .pickerStyle(.segmented)
            
            List {
                ForEach(items) { item in
                    let lowSearch = searchText.lowercased()
                    let lowProduct = item.name!.lowercased()
                    if lowProduct.contains(lowSearch) {
                        
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
                        .onTapGesture {
                            print("Tapped cell")
                            itemPressed = true
                        }
                        .fullScreenCover(isPresented: $itemPressed, content: EditItemModalView.init)
                        
                    } else if searchText.isEmpty {
                        
                        ZStack {
                            if Date() >= item.expiry!  {
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
                                
                            }.padding(.horizontal)
                        }
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            print("Tapped cell")
                            itemPressed = true
                        }
                        .fullScreenCover(isPresented: $itemPressed, content: EditItemModalView.init)
                    }
                }.onDelete(perform: deleteItems)
                
                
                
                
            }.listStyle(.inset)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 100)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
            }
        }.ignoresSafeArea()
            .preferredColorScheme(.light)
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
