//
//  ContentView.swift
//  iExpenseTracker
//
//  Created by Kamol Madaminov on 29/03/25.
//

import SwiftUI

struct ExpenseRow: View {
    let item: ExpenseItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(amountColor(item.amount).opacity(0.2))
        .foregroundColor(amountColor(item.amount))
        .fontWeight(amountWeight(item.amount))
        .cornerRadius(8)
    }

    func amountColor(_ amount: Double) -> Color {
        if amount < 10 {
            return .green
        } else if amount < 100 {
            return .orange
        } else {
            return .red
        }
    }

    func amountWeight(_ amount: Double) -> Font.Weight {
        if amount < 10 {
            return .light
        } else if amount < 100 {
            return .medium
        } else {
            return .bold
        }
    }
}

struct ExpenseSection: View {
    let title: String
    let items: [ExpenseItem]
    let removeAction: (IndexSet) -> Void

    var body: some View {
        Section(title) {
            ForEach(items, id: \.id) { item in
                ExpenseRow(item: item)
            }
            .onDelete(perform: removeAction)
        }
    }
}


struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses{
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedData) {
                items = decoded
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
        
    var body: some View {
        NavigationStack{
            List {
                ExpenseSection(title: "Personal expenses", items: expenses.items.filter { $0.type == "Personal" }, removeAction: removeItems)
                ExpenseSection(title: "Business expenses", items: expenses.items.filter { $0.type == "Business" }, removeAction: removeItems)
            }
            .navigationTitle("iExpenseTracker")
            .toolbar{
                Button("Add expense", systemImage: "plus"){
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
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
