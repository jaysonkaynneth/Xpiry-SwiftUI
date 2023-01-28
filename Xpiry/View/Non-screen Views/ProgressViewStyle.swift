//
//  ProgressViewStyle.swift
//  Xpiry
//
//  Created by Jason Kenneth on 26/01/23.
//

import SwiftUI

struct RoundedRectProgressViewStyle: ProgressViewStyle {
    
   func makeBody(configuration: Configuration) -> some View {
       ZStack(alignment: .leading) {
           RoundedRectangle(cornerRadius: 5)
               .frame(width: 300, height: 28)
               .foregroundColor((Color(red: 225/255, green: 85/255, blue: 84/255)))
               
           
           RoundedRectangle(cornerRadius: 5)
               .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 300, height: 28)
               .foregroundColor(Color(red: 59/255, green: 178/255, blue: 115/255))
       }
   }
}


