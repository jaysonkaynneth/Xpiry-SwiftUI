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
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 150)
                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                
                HStack {
                    Text("Shopping List")
                        .font(.system(size: 30, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.leading)
                    Spacer()
                    EditButton()
                        .padding()
                        .foregroundColor(.white)
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
                                Text(sItem.name ?? "no feedback")
                                Spacer()
                                Text(String(sItem.stock))
                                Button {
                                    sItem.done.toggle()
                                    try? moc.save()
                                } label: {
                                    Image(systemName: sItem.done ? "checkmark" : "")
                                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))                                }
                                
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
                                        .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                                }
                            }
                        }
                    }.onDelete(perform: deleteItems)
                    
                }.listStyle(.inset)
                
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
                                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                            }
                            
                        }
                        
                    }.onDelete(perform: deleteItems)
                    
                }.listStyle(.inset)
                
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
                                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                            }
                            
                        }
                        
                    }.onDelete(perform: deleteItems)
                    
                }.listStyle(.inset)
                    .padding(.top, 25)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 100)
                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                    .padding(.top, 20)
                
            }
            
        }
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
