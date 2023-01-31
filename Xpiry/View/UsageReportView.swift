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
                Rectangle()
                    .frame(height: 150)
                    .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
                
                HStack {
                    Text("Product Usage Report")
                        .font(Font.custom("DMSans-Bold", size: 30))
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                        .bold()
                        .padding(.top, 35)
                        .padding(.leading)
                    Spacer()
                    
                }
               
              
            }
            List {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                        .shadow(radius: 5, x: 0, y: 4)
                        .frame(height: 95)
                        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                    HStack {
                        Text("Products Consumed")
                            .font(Font.custom("DMSans-Medium", size: 18))
                        Spacer()
                        Text(String(consumes.count))
                            .font(Font.custom("DMSans-Regular", size: 18))
                            .padding()
                    }.padding(.horizontal)
                }  .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                        .shadow(radius: 5, x: 0, y: 4)
                        .frame(height: 95)
                        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                    HStack {
                        Text("Products Wasted")
                            .font(Font.custom("DMSans-Medium", size: 18))
                        Spacer()
                        Text(String(wastes.count))
                            .font(Font.custom("DMSans-Regular", size: 18))
                            .padding()
                    }.padding(.horizontal)
                }.listRowSeparator(.hidden)
                    .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(height: 150)
                        .shadow(radius: 5, x: 0, y: 4)
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
                    VStack {
                        ProgressView(value: barValue, total: 100/100)
                            .progressViewStyle(RoundedRectProgressViewStyle())
                        
                        
                        HStack {
                            let wasteFormat = String(format: "%.1f", wastePercent)
                            let consumeFormat = String(format: "%.1f", consumePercent)
                            
                            Text("Consumed")
                                .foregroundColor(Color(red: 32/255, green: 32/255, blue: 48/255))
                                .font(Font.custom("DMSans-Medium", size: 18))
                                .bold()
                            
                            if consumeFormat == "nan" {
                                Text("0%")
                                    .foregroundColor(Color(red: 32/255, green: 32/255, blue: 48/255))
                                    .font(Font.custom("DMSans-Medium", size: 18))
                                    .bold()
                            } else {
                                Text("\(consumeFormat)%")
                                    .foregroundColor(Color(red: 32/255, green: 32/255, blue: 48/255))
                                    .font(Font.custom("DMSans-Medium", size: 18))
                                    .bold()
                            }
                            
                            Spacer()
                            
                            Text("Wasted")
                                .foregroundColor(Color(red: 32/255, green: 32/255, blue: 48/255))
                                .font(Font.custom("DMSans-Medium", size: 18))
                                .bold()
                            
                            if wasteFormat == "nan" {
                                Text("0%")
                                    .foregroundColor(Color(red: 32/255, green: 32/255, blue: 48/255))
                                    .font(Font.custom("DMSans-Medium", size: 18))
                                    .bold()
                            } else {
                                Text("\(wasteFormat)%")
                                    .foregroundColor(Color(red: 32/255, green: 32/255, blue: 48/255))
                                    .font(Font.custom("DMSans-Medium", size: 18))
                                    .bold()
                            }
                            
                        }.padding(.horizontal)
                    }
                } .listRowSeparator(.hidden)
                    .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                

                
                ZStack {
                    if wastes.count > consumes.count || wastes.count == consumes.count{
                        Text("Please waste less products!")
                            .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
                            .font(Font.custom("DMSans-Medium", size: 24))
                            .bold()
                            .padding(.leading)
                            .padding(.top, 5)
                        
                    } else {
                        Text("You're doing great!")
                            .foregroundColor(Color(red: 77/255, green: 108/255, blue: 250/255))
                            .font(Font.custom("DMSans-Medium", size: 24))
                            .bold()
                            .padding(.leading, 60)
                            .padding(.top, 5)
                        
                    }
                }
                .listRowBackground(Color(red: 252/255, green: 250/255, blue: 250/255))
                .listRowSeparator(.hidden)
                //                PieChartView (
                //                    values: [Double(wastes.count), Double(consumes.count)],
                //                    names: ["Wasted", "Consumed"],
                //                    formatter: {value in String(format: "%.2f", value)},
                //                    widthFraction: 0.8
                //                )
                
            }
            .background(Color(red: 252/255, green: 250/255, blue: 250/255))
            .scrollContentBackground(.hidden)
            .accentColor(.clear)
            .listStyle(.inset)
            
            
            
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
        .onAppear {
            self.barValue = Float(consumes.count)/Float(wastes.count + consumes.count) * 100/100
            self.consumePercent =  Float(consumes.count)/Float(wastes.count + consumes.count) * 10000/100
            self.wastePercent =  Float(wastes.count)/Float(wastes.count + consumes.count) * 10000/100
        }
    }
}

struct UsageReportView_Previews: PreviewProvider {
    static var previews: some View {
        UsageReportView()
    }
}



