//
//  OverlayView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 08/01/23.
//

import SwiftUI

struct OverlayView: View {
    
    @State private var isPresented = false
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.primary.opacity(0.2))
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 60)
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
        
                    Text("Tap on the textfield\n to scan text.")
                }
                .offset(x: 65)
                .offset(y: -90)
                
                ZStack {
                    Rectangle().fill(.clear)
                        .frame(width: 390, height: 144, alignment: .center).offset(y: 4)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.light)
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}


