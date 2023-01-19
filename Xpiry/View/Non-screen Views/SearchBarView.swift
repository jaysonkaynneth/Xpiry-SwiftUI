//
//  SearchBarView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 01/12/22.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText : String
    var containerText : String = "Find Item"
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .bold()
                .foregroundColor(.gray)
                
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(containerText)
                        .foregroundColor(.gray)
                }
                TextField("", text: $searchText)
                    .foregroundColor(.black)
                    .autocorrectionDisabled(true)
            }
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .foregroundColor(.gray)
                    .offset(x:10)
                    .opacity(searchText.isEmpty ? 0 : 1)
                    .onTapGesture {
                        endTextEditing()
                        searchText = ""
                    }
                ,alignment: .trailing
            )
            
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .opacity(1)
        )
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
