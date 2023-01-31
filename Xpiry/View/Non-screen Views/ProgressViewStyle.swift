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
               .foregroundColor(Color(red: 251/255, green: 51/255, blue: 52/255))
               
           
           RoundedRectangle(cornerRadius: 5)
               .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 300, height: 28)
               .foregroundColor(Color(red: 33/255, green: 177/255, blue: 108/255))
       }
   }
}


