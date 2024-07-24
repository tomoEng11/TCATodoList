//
//  ContactsFeature.swift
//  TCATodoList
//
//  Created by 井本智博 on 2024/07/21.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContactsFeature {

    @ObservableState
    struct State: Equatable {
        var contacts: IdentifiedArrayOf<Contact> = []
        // optionalのstateにつけるwrapper
        @Presents var destination: Destination.State?
    }

    enum Action {
        case addButtonTapped
        //@PresentsのActionのジェネリクス
        case deleteButtonTapped(id: Contact.ID)
        case destination(PresentationAction<Destination.Action>)

        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: UUID(), name: "")
                    )
                )
                return .none

            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none

            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none

            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none

            case .destination:
                return .none
            }
        }
        // property wrapperにアクセスするからStateは$が必要
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ContactsFeature {
    // state parameter忘れない！
    @Reducer(state: .equatable)
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}
