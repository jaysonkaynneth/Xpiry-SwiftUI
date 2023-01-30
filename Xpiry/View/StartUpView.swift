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
                Text("Hello!")    .font(.system(size: 50, design: .rounded))
                    .bold()
                Spacer()
            }
            .padding(.leading)
            .padding(.top)
            HStack {
                Text("Welcome to Xpiry,\nyour expiration tracker app.\n\nLet's get to know each other first!\nWhat should I call you?")    .font(.system(size: 18, design: .rounded))
                    .bold()
                Spacer()
            }.padding(.leading)
            ZStack {
                TextField("", text: $userName)
                    .tint(Color(red: 65/255, green: 146/255, blue: 255/255))
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.black)
                            .foregroundColor(.clear)
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
                        .font(.system(size: 18, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .foregroundColor(Color(red: 12/255, green: 91/255, blue: 198/255))
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
        .preferredColorScheme(.light)
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView(showStartUp: .constant(true))
    }
}
