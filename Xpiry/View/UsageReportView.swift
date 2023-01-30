//
//  ShoppingListView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 013/01/23.
//

import SwiftUI

struct UsageReportView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var consumes: FetchedResults<Consume>
    @FetchRequest(sortDescriptors: []) var wastes: FetchedResults<Waste>
    @State private var showModal = false
    @State private var tapped = false
    @State private var searchText = ""
    @State private var conCount = 0
    @State private var wasCount = 0
    @State private var barValue: Float = 0.0
    @State private var wastePercent: Float = 0.0
    @State private var consumePercent: Float = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 150)
                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                
                HStack {
                    Text("Product Usage Report")
                        .foregroundColor(.white)
                        .font(.system(size: 25, design: .rounded))
                        .bold()
                        .padding(.leading)
                    Spacer()
                    
                }
                .padding(.bottom)
                .padding(.trailing)
            }
            List {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .frame(height: 95)
                    HStack {
                        Text("Products Consumed")
                        Spacer()
                        Text(String(consumes.count))
                            .padding()
                    }.padding(.horizontal)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .frame(height: 95)
                    HStack {
                        Text("Products Wasted")
                        Spacer()
                        Text(String(wastes.count))
                            .padding()
                    }.padding(.horizontal)
                }.listRowSeparator(.hidden)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 150)
                        .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                    VStack {
                        ProgressView(value: barValue, total: 100/100)
                            .progressViewStyle(RoundedRectProgressViewStyle())
                        
                        
                        HStack {
                            let wasteFormat = String(format: "%.1f", wastePercent)
                            let consumeFormat = String(format: "%.1f", consumePercent)
                            
                            Text("Consumed")
                                .foregroundColor(.white)
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                            
                            if consumeFormat == "nan" {
                                Text("0%")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, design: .rounded))
                                    .bold()
                            } else {
                                Text("\(consumeFormat)%")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, design: .rounded))
                                    .bold()
                            }
                            
                            Spacer()
                            
                            Text("Wasted")
                                .foregroundColor(.white)
                                .font(.system(size: 17, design: .rounded))
                                .bold()
                            
                            if wasteFormat == "nan" {
                                Text("0%")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, design: .rounded))
                                    .bold()
                            } else {
                                Text("\(wasteFormat)%")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, design: .rounded))
                                    .bold()
                            }
                            
                        }.padding(.horizontal)
                    }
                } .listRowSeparator(.hidden)
                

                
                ZStack {
                    if wastes.count > consumes.count || wastes.count == consumes.count{
                        Text("Please waste less products!")
                            .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                            .font(.system(size: 25, design: .rounded))
                            .bold()
                        
                    } else {
                        Text("You're doing great!")
                            .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                            .font(.system(size: 25, design: .rounded))
                            .bold()
                        
                    }
                }
                .padding(.leading)
                .listRowSeparator(.hidden)
                //                PieChartView (
                //                    values: [Double(wastes.count), Double(consumes.count)],
                //                    names: ["Wasted", "Consumed"],
                //                    formatter: {value in String(format: "%.2f", value)},
                //                    widthFraction: 0.8
                //                )
                
            }
            .accentColor(.clear)
            .listStyle(.inset)
            
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 100)
                    .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
                    .padding(.top, 20)
                
            }
        }
        .preferredColorScheme(.light)
        .ignoresSafeArea()
        .onAppear {
            self.barValue = Float(consumes.count)/Float(wastes.count + consumes.count) * 100/100
            self.consumePercent =  Float(consumes.count)/Float(wastes.count + consumes.count) * 10000/100
            self.wastePercent =  Float(wastes.count)/Float(wastes.count + consumes.count) * 10000/100
        }
    }
}


