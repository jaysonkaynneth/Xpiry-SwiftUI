//
//  StartUpView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 19/01/23.
//

import SwiftUI

struct StartUpView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Binding var showStartUp: Bool
    
    @State private var userName: String = ""
    @State private var showAlert = false
    var body: some View {
        VStack {
            HStack {
                Text("Hello!")
                    .font(Font.custom("DMSans-Bold", size: 50))
                Spacer()
            }
            .padding(.leading)
            .padding(.top)
            HStack {
                Text("Welcome to Xpiry,\nyour expiration tracker app.\n\nLet's get to know each other first!\nWhat should I call you?")
                    .font(Font.custom("DMSans-Medium", size: 18))
                Spacer()
            }.padding(.leading)
            ZStack {
                TextField("", text: $userName)
                    .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                            .frame(height: 35)
                    )
            }.padding(.horizontal)
            Spacer()
            
            Button {
                showAlert = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .frame(width: 200, height: 60)
                    
                    Text("Save")
                        .font(Font.custom("DMSans-Medium", size: 18))
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                }
            }
            .foregroundColor(Color(red: 33/255, green: 177/255, blue: 108/255))
            .disabled(userName.isEmpty)
            .actionSheet(isPresented: $showAlert) {
                ActionSheet(title: Text("Are you sure?"),
                            message: Text("Your name cannot be changed later on"),
                            buttons: [
                                .cancel(),
                                .default(
                                    Text("Yes i'm sure"),
                                    action: {
                                        let user = User(context: moc)
                                        user.name = (userName)
                                        
                                        showStartUp.toggle()
                                        
                                        print(user.name ?? "nothing")
                                        
                                        try! moc.save()
                                    }),
                                .destructive(
                                    Text("No"),
                                    action: {
                                        showAlert = false
                                    }
                                )
                            ]
                )
            }
        }
        .background(Color(red: 252/255, green: 250/255, blue: 250/255))
        .preferredColorScheme(.light)
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView(showStartUp: .constant(true))
    }
}
