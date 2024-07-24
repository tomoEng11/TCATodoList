//
//  AddContactFeature.swift
//  TCATodoList
//
//  Created by 井本智博 on 2024/07/21.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddContactFeature {

    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }

    enum Action: Equatable {
        case cancelButtonTapped
        case saveButttonTapped
        case setName(String)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
//子reducerでPresentationActionのdismissができる(@Presentsのstateもnilになる)
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss()}
            case .saveButttonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
            case let .setName(name):
                state.contact.name = name
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
