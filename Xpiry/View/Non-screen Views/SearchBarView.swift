//
//  SearchBarView.swift
//  Xpiry
//
//  Created by Jason Kenneth on 01/12/22.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText : String
    var containerText : String = "Search"
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .bold()
                .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(containerText)
                        .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                }
                TextField("", text: $searchText)
                    .tint(Color(red: 77/255, green: 108/255, blue: 250/255))
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
                .foregroundColor(Color(red: 252/255, green: 250/255, blue: 250/255))
                .opacity(0.5)
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
