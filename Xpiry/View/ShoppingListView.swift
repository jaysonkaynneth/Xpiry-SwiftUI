//
//  ShoppingListView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 09/01/23.
//

import SwiftUI

struct ShoppingListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var shoppingItems: FetchedResults<ShoppingItem>
    @State private var showModal = false
    @State private var tapped = false
    @State private var searchText = ""
    @State private var completeType = "All"
    @State private var showAlert = false
    
    var body: some View {
        
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: 150)
                    .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
                
                HStack {
                    if completeType == "All" {
                        Text("Shopping List")
                            .font(Font.custom("DMSans-Bold", size: 30))
                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                            .bold()
                            .padding(.leading)
                    } else {
                        Text("Shopping List")
                            .font(Font.custom("DMSans-Bold", size: 30))
                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                            .bold()
                            .padding(.leading)
                            .padding(.top, 50)
                    }
                    Spacer()
                    
                    if completeType == "All" {
                        EditButton()
                            .padding()
                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                    } else {
                        EditButton()
                            .padding()
                            .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                            .padding(.top, 50)
                    }
                    Button {
                        showModal.toggle()
                    } label: {
                        ZStack {
                            if completeType == "All" {
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
                    }
                    .sheet(isPresented: $showModal) {
                        AddSLModalView(showModal: self.$showModal)
                    }
                }
                .padding(.bottom)
                .padding(.trailing)
                
                if completeType == "All" {
                    SearchBarView(searchText: $searchText, containerText: "Search")
                        .offset(y:40)
                        .padding()
                } else {
                    
                }
            }
            
            Picker(" ", selection: $completeType) {
                Text("All").tag("All")
                Text("Pending").tag("Pending")
                Text("Done").tag("Done")
            }
            .padding()
            .pickerStyle(.segmented)
            
            if completeType == "All" {
                List {
                    ForEach(shoppingItems) { sItem in
                        let lowSearch = searchText.lowercased()
                        let lowProduct = sItem.name!.lowercased()
                        if lowProduct.contains(lowSearch) {
                            
                            HStack{
                                Text(sItem.name ?? "no item")
                                    .font(Font.custom("DMSans-Regular", size: 18))
                                Spacer()
                                Text(String(sItem.stock))
                                    .font(Font.custom("DMSans-Regular", size: 18))
                                Button {
                                    sItem.done.toggle()
                                    try? moc.save()
                                } label: {
                                    Image(systemName: sItem.done ? "checkmark" : "")
                                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))                                }
                                
                            }
                            
                        } else if searchText.isEmpty {
                            
                            HStack{
                                Text(sItem.name ?? "no item")
                                    .font(Font.custom("DMSans-Regular", size: 18))
                                Spacer()
                                Text(String(sItem.stock))
                                    .font(Font.custom("DMSans-Regular", size: 18))
                                Button {
                                    sItem.done.toggle()
                                    try? moc.save()
                                } label: {
                                    Image(systemName: sItem.done ? "checkmark" : "")
                                        .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                                }
                            }
                        }
                    }.onDelete(perform: deleteItems)
                        .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                    
                }
                .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                .scrollContentBackground(.hidden)
                .listStyle(.inset)
                
            } else if completeType == "Done" {
                List {
                    ForEach(shoppingItems.filter {
                        $0.done == true
                    }) { sItem in
                        HStack{
                            Text(sItem.name ?? "no item")
                                .font(Font.custom("DMSans-Regular", size: 18))
                            Spacer()
                            Text(String(sItem.stock))
                                .font(Font.custom("DMSans-Regular", size: 18))
                            Button {
                                sItem.done.toggle()
                                try? moc.save()
                            } label: {
                                Image(systemName: sItem.done ? "checkmark" : " ")
                                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                            }
                            
                        }
                        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                    
                        
                    }.onDelete(perform: deleteItems)
                        .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                     
                    
                }
                .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                .scrollContentBackground(.hidden)
                .listStyle(.inset)
                
            } else {
                List {
                    ForEach(shoppingItems.filter {
                        $0.done == false
                    }) { sItem in
                        HStack{
                            Text(sItem.name ?? "no item")
                                .font(Font.custom("DMSans-Regular", size: 18))
                            Spacer()
                            Text(String(sItem.stock))
                                .font(Font.custom("DMSans-Regular", size: 18))
                            Button {
                                sItem.done.toggle()
                                try? moc.save()
                            } label: {
                                Image(systemName: sItem.done ? "checkmark" : "")
                                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                            }
                            
                        }
                        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                        
                    }.onDelete(perform: deleteItems)
                        .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                    
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
        .preferredColorScheme(.light)
        .ignoresSafeArea()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { shoppingItems[$0] }.forEach(moc.delete)
            
            do {
                try moc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
