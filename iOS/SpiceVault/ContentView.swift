import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var editingEntry: SpiceEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    Button {
                        editingEntry = entry
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.name.isEmpty ? "Untitled" : entry.name)
                                .font(Theme.headingFont)
                                .foregroundStyle(.primary)
                            EmptyView()
                                .font(Theme.bodyFont)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("entryRow_\(entry.id)")
                }
                .onDelete { offsets in
                    store.delete(at: offsets)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Spice Vault")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEntrySheet(isPresented: $showingAdd)
            }
            .sheet(item: $editingEntry) { entry in
                AddEntrySheet(isPresented: .constant(true), editing: entry)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $store.showPaywall) {
                PaywallView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView("No spices yet", systemImage: "tray", description: Text("Tap + to add your first spice."))
                }
            }
        }
        .tint(Theme.primary)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    var editing: SpiceEntry?

    @State private var name: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var form: String = ""
    @State private var notes: String = ""

    init(isPresented: Binding<Bool>, editing: SpiceEntry? = nil) {
        self._isPresented = isPresented
        self.editing = editing
        if let e = editing { _name = State(initialValue: e.name) }
        if let e = editing { _purchaseDate = State(initialValue: e.purchaseDate) }
        if let e = editing { _form = State(initialValue: e.form) }
        if let e = editing { _notes = State(initialValue: e.notes) }
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("addNameField")
                DatePicker("Purchase date", selection: $purchaseDate, displayedComponents: .date)
                    .accessibilityIdentifier("addPurchaseDateField")
                TextField("Form", text: $form)
                    .accessibilityIdentifier("addFormField")
                TextField("Notes", text: $notes)
                    .accessibilityIdentifier("addNotesField")
            }
            .navigationTitle(editing == nil ? "Add Spice" : "Edit Spice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false; dismiss() }
                        .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if var e = editing {
                            e.name = name
                            e.purchaseDate = purchaseDate
                            e.form = form
                            e.notes = notes
                            store.update(e)
                        } else {
                            let entry = SpiceEntry(name: name, purchaseDate: purchaseDate, form: form, notes: notes)
                            let added = store.add(entry, isPro: purchases.isPro)
                            if !added { return }
                        }
                        isPresented = false
                        dismiss()
                    }
                    .accessibilityIdentifier("addSaveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
