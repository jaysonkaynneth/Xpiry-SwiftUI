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
             
                let user = User(context: moc)
                user.name = (userName)
                
                showStartUp.toggle()
                
                print(user.name ?? "nothing")
                
                try! moc.save()
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .frame(width: 200, height: 60)
                    
                    Text("Save")
                        .font(.system(size: 18, design: .rounded))
                        .foregroundColor(.white)
                }
            } .disabled(userName.isEmpty)
        }
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView(showStartUp: .constant(true))
    }
}
