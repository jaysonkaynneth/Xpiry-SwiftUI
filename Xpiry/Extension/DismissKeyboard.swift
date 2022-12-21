//
//  Keyboard.swift
//  Xpiry
//
//  Created by Jason Kenneth on 01/12/22.
//

import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

