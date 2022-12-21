//
//  ContentView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 29/11/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @State private var searchText = ""
    @State private var isPresented = false
    @State private var itemPressed = false
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 150)
                    .foregroundColor(.gray)
                
                    SearchBarView(searchText: $searchText, containerText: "Find Items")
                        .offset(y:25)
                        .padding()
            }
        
            List {
                ForEach(items) { item in
                    let lowSearch = searchText.lowercased()
                    let lowProduct = item.name!.lowercased()
                    if lowProduct.contains(lowSearch){
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .frame(height: 95)
                            
                            HStack {
                                Circle()
                                    .strokeBorder(.black)
                                    .frame(width: 85, height: 85)
                                VStack {
                                    Text(item.name ?? "no name")
                                    Text(dateFormatter.string(from: item.expiry!))
                                }
                                Spacer()
                                Text(String(item.stock))
                                
                            }.padding()
                        }
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                                print("Tapped cell")
                            itemPressed.toggle()
                        }.fullScreenCover(isPresented: $itemPressed, content: EditItemModalView.init)
                    } else if searchText.isEmpty{
                             ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .frame(height: 95)
                        
                        HStack {
                            Circle()
                                .strokeBorder(.black)
                                .frame(width: 85, height: 85)
                            VStack {
                                Text(item.name ?? "no name")
                                Text(dateFormatter.string(from: item.expiry!))
                            }
                            Spacer()
                            Text(String(item.stock))
                            
                        }.padding()
                    }
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                            print("Tapped cell")
                        itemPressed.toggle()
                    }.fullScreenCover(isPresented: $itemPressed, content: EditItemModalView.init)
                    }
                }.onDelete(perform: deleteItems)
                 

                
                
            }.listStyle(.inset)
                .padding(.top, 25)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                    ZStack {
                        Circle()
                            .frame(width: 114, height: 114)
                            .foregroundColor(.gray)
                            .offset(y: -30)
                        
                        Button {
                            isPresented.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 95, height: 95)
                                    .offset(y: -30)
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 50)
                                    .offset(y: -30)
                            }
                        }   .fullScreenCover(isPresented: $isPresented, content: AddItemModalView.init)
                    }
                }
        }.ignoresSafeArea()
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
