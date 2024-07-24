//
//  AddContactView.swift
//  TCATodoList
//
//  Created by 井本智博 on 2024/07/21.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    // storeをBindingする
    @Bindable var store: StoreOf<AddContactFeature>

    var body: some View {
        Form {
            TextField("Name", text: $store.contact.name.sending(\.setName))
            Button("Save") {
                store.send(.saveButttonTapped)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(store: Store(initialState: AddContactFeature.State(contact: Contact(id: UUID(), name: "")), reducer: {
            AddContactFeature()
        }))
    }
}
