//
//  LoginFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginFeature: Reducer {
    enum ActiveScreen {
        case none
        case signIn
        case signUp
        case main
    }
    
    struct State: Equatable {
        var activeScreen: ActiveScreen = .none
    }
    
    enum Action: Equatable {
        case signInButtonTapped
        case signUpButtonTapped
        case signInGuest
        case onDismiss
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signInButtonTapped:
                state.activeScreen = .signIn
                return .none
            case .signUpButtonTapped:
                state.activeScreen = .signUp
                return .none
            case .signInGuest:
                state.activeScreen = .main
                return .none
            case .onDismiss:
                state.activeScreen = .none
                return .none
            }
        }
    }
}
