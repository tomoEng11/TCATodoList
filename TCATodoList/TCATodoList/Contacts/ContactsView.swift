//
//  ContactsView.swift
//  TCATodoList
//
//  Created by 井本智博 on 2024/07/21.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    HStack {
                        Text(contact.name)
                        Spacer()
                        Button {
                            store.send(.deleteButtonTapped(id: contact.id))
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        store.send(.addButtonTapped)
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            //　子storeを親storeから作成しviewをインスタンス化
        }.sheet(item: $store.scope(
            state: \.destination?.addContact,
            action: \.destination.addContact)
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert($store.scope(
            state: \.destination?.alert,
            action: \.destination.alert))
    }
}

#Preview {
    ContactsView(store: Store(initialState: ContactsFeature.State(
        contacts: [
            Contact(id: UUID(), name: "Bob"),
            Contact(id: UUID(), name: "Mike"),
            Contact(id: UUID(), name: "Reo"),
        ]
    ), reducer: {
        ContactsFeature()
    }))
}
