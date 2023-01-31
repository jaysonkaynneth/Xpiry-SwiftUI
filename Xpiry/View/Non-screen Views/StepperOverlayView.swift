//
//  StepperOverlayView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 30/01/23.
//

import SwiftUI

struct StepperOverlayView: View {
    
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
                        .frame(width: 230, height: 60)
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
        
                    Text("Tap and hold on the + or -")
                }
                .offset(x: 65)
                .offset(y: 300)
                
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

struct StepperOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        StepperOverlayView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}



