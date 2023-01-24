//
//  ShoppingListView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 013/01/23.
//

import SwiftUI

struct UsageReportView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var reports: FetchedResults<UsageReport>
    @State private var showModal = false
    @State private var tapped = false
    @State private var searchText = ""
    @State private var conCount = 0
    @State private var wasCount = 0
    
//    let usage: UsageReport
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 150)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Product Usage Report")
                        .font(.system(size: 25, design: .rounded))
                        .bold()
                        .padding(.leading)
                    Spacer()
                    Button {
                        showModal.toggle()
                    } label: {
                        ZStack {
                            Image(systemName: "square.and.arrow.up")
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
            }
            
            //            ScrollView {
            //                ZStack {
            //                    RoundedRectangle(cornerRadius: 15)
            //                        .foregroundColor(.white)
            //                        .shadow(radius: 5)
            //                        .frame(height: 95)
            //                    HStack {
            //                        Text("Products Wasted")
            //                        Spacer()
            //                        Text(String(wastes.count))
            //                            .padding()
            //                    }.padding(.horizontal)
            //                }
            //                .padding(.top)
            //                .padding(.horizontal)
            //
            //                ZStack {
            //                    RoundedRectangle(cornerRadius: 15)
            //                        .foregroundColor(.white)
            //                        .shadow(radius: 5)
            //                        .frame(height: 95)
            //                    HStack {
            //                        Text("Products Consumed")
            //                        Spacer()
            //                        Text(String(consumes.count))
            //                            .padding()
            //                    }.padding(.horizontal)
            //                }.padding()
            //
            //
            //            }
            List {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .frame(height: 95)
                    HStack {
                        Text("Products Wasted")
                        Spacer()
                        Text(String(reports.count))
                            .padding()
                    }.padding(.horizontal)
                }
                
                ZStack {
                     RoundedRectangle(cornerRadius: 15)
                         .foregroundColor(.white)
                         .shadow(radius: 5)
                         .frame(height: 95)
                     HStack {
                         Text("Products Consumed")
                         Spacer()
                         Text(String(reports.count))
                             .padding()
                     }.padding(.horizontal)
                 }.listRowSeparator(.hidden)
                
                Image("UsagePlaceHolder")
                    .listRowSeparator(.hidden)
            }
            .accentColor(.clear)
            .listStyle(.inset)
            
         
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 100)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
            }
        }.ignoresSafeArea()
    }
}

struct UsageReportView_Previews: PreviewProvider {
    static var previews: some View {
        UsageReportView()
    }
}

