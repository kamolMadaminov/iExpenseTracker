//
//  AddView.swift
//  iExpenseTracker
//
//  Created by Kamol Madaminov on 29/03/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isFocused: Bool
    
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: Double = 0.0
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Name", text: $name)
                    .focused($isFocused)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    
            }
            .navigationTitle("Add new expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save"){
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        expenses.items.append(item)
                        
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done"){
                        isFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
