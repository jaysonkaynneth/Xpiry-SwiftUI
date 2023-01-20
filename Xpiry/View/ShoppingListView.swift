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
    
    var body: some View {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 150)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Shopping List")
                            .font(.system(size: 30, design: .rounded))
                            .bold()
                            .padding(.leading)
                        Spacer()
                        Button {
                            showModal.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                        }          .sheet(isPresented: $showModal) {
                            AddSLModalView(showModal: self.$showModal)
                        }
                    }.padding(.bottom)
                        .padding(.trailing)
                    
                    if completeType == "All" {
                        SearchBarView(searchText: $searchText, containerText: "Find Items")
                            .offset(y:40)
                            .padding()
                    } else {
                       
                    }
                }
                
                Picker("What is your favorite color?", selection: $completeType) {
                    Text("All").tag("All")
                    Text("Done").tag("Done")
                    Text("Pending").tag("Pending")
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
                                    Text(sItem.name ?? "no feedback")
                                    Spacer()
                                    Text(String(sItem.stock))
                                    Button {
                                        sItem.done.toggle()
                                        try? moc.save()
                                    } label: {
                                        Image(systemName: sItem.done ? "checkmark" : "")
                                            .foregroundColor(Color(red: 251/255, green: 80/255, blue: 18/255))
                                    }
                                    
                                }
                                
                            } else if searchText.isEmpty {
                                
                                HStack{
                                    Text(sItem.name ?? "no feedback")
                                    Spacer()
                                    Text(String(sItem.stock))
                                    Button {
                                        sItem.done.toggle()
                                        try? moc.save()
                                    } label: {
                                        Image(systemName: sItem.done ? "checkmark" : "")
                                            .foregroundColor(Color(red: 251/255, green: 80/255, blue: 18/255))
                                    }
                                }
                            }
                        }.onDelete(perform: deleteItems)
         
                    }.listStyle(.inset)
                        .padding(.top, 25)
                    
                } else if completeType == "Done" {
                    List {
                        ForEach(shoppingItems.filter {
                            $0.done == true
                        }) { sItem in
                            HStack{
                                Text(sItem.name ?? "no feedback")
                                Spacer()
                                Text(String(sItem.stock))
                                Button {
                                    sItem.done.toggle()
                                    try? moc.save()
                                } label: {
                                    Image(systemName: sItem.done ? "checkmark" : " ")
                                        .foregroundColor(Color(red: 251/255, green: 80/255, blue: 18/255))
                                }
                                
                            }
                            
                        }.onDelete(perform: deleteItems)
         
                    }.listStyle(.inset)
                        .padding(.top, 25)
                    
                } else {
                    List {
                        ForEach(shoppingItems.filter {
                            $0.done == false
                        }) { sItem in
                            HStack{
                                Text(sItem.name ?? "no feedback")
                                Spacer()
                                Text(String(sItem.stock))
                                Button {
                                    sItem.done.toggle()
                                    try? moc.save()
                                } label: {
                                    Image(systemName: sItem.done ? "checkmark" : "")
                                        .foregroundColor(Color(red: 251/255, green: 80/255, blue: 18/255))
                                }
                                
                            }
                            
                        }.onDelete(perform: deleteItems)
         
                    }.listStyle(.inset)
                        .padding(.top, 25)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
         
                }
                
            }.ignoresSafeArea()
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
