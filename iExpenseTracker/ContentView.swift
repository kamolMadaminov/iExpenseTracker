//
//  ContentView.swift
//  iExpenseTracker
//
//  Created by Kamol Madaminov on 29/03/25.
//

import SwiftUI

struct ExpenseItem {
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses{
    var items = [ExpenseItem]()
}

struct ContentView: View {
    @State private var expenses = Expenses()
    var body: some View {
        NavigationStack{
            List {
                ForEach(expenses.items, id: \.name){ item in
                    Text("\(item.name)")
                } .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpenseTracker")
            .toolbar{
                Button("Add expense", systemImage: "plus"){
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                }
            }
        }
    }
    
    func removeItems(at offset: IndexSet){
        expenses.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}
