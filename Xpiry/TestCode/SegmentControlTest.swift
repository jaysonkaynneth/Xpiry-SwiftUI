//
//  SegmentControlTest.swift
//  Xpiry
//
//  Created by Jason Kenneth on 19/01/23.
//

import SwiftUI

struct TestPickerWithBinding: View {
    @State var incomeTypeFilter: Bool? = nil
    var transactionType: Binding<Int> { Binding<Int>(
        get: {
            if let flag = self.incomeTypeFilter {
                return flag ? 1 : 2
            } else {
                return 0
            }
        },
        set: {
            switch $0 {
            case 1:
                self.incomeTypeFilter = true
            case 2:
                self.incomeTypeFilter = false
            default:
                self.incomeTypeFilter = nil
            }
        })
    }

    var body: some View {
        VStack {
            Picker(selection: transactionType, label: Text("Picker")) {
                Text("All").tag(0)
                Text("Income").tag(1)
                Text("Expenses").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Filter: \(nil == incomeTypeFilter ? "All" : (incomeTypeFilter! ? "Income" : "Expences"))")
        }

    }
}

struct TestPickerWithBinding_Previews: PreviewProvider {
    static var previews: some View {
        TestPickerWithBinding()
    }
}
