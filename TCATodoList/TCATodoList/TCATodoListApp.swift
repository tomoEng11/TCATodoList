//
//  TCATodoListApp.swift
//  TCATodoList
//
//  Created by 井本智博 on 2024/07/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCATodoListApp: App {
    var body: some Scene {
        WindowGroup {
            ContactsView(store: Store(initialState: ContactsFeature.State(), reducer: {
                ContactsFeature()
            }))
        }
    }
}
