//
//  LoginInitialFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/4/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginInitialFeature: Reducer {
    enum ActiveScreen {
        case login, emailLogin, signup, signupEmail, signupPassword, signupDone, verifyEmail, resetPassword, main
    }
    
    struct State: Equatable {
        var navigationPath: [ActiveScreen] = []
    }
    
    enum Action: Equatable {
        case signInButtonTapped
        case signUpButtonTapped
        case signUpEmailButtonTapped
        case signUpPasswordButtonTapped
        case signUpDoneButtonTapped
        case verifyEmailButtonTapped
        case resetPasswordButtonTapped
        case mainButtonTapped
        case onDismiss
        case setNavigationPath([ActiveScreen])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signInButtonTapped:
                state.navigationPath.append(.emailLogin)
                return .none
                
            case .signUpButtonTapped:
                state.navigationPath.append(.signup)
                return .none
                
            case .signUpEmailButtonTapped:
                state.navigationPath.append(.signupEmail)
                return .none
                
            case .signUpPasswordButtonTapped:
                state.navigationPath.append(.signupPassword)
                return .none
                
            case .signUpDoneButtonTapped:
                state.navigationPath.append(.signupDone)
                return .none
                
            case .verifyEmailButtonTapped:
                state.navigationPath.append(.verifyEmail)
                return .none
                
            case .resetPasswordButtonTapped:
                state.navigationPath.append(.resetPassword)
                return .none
                
            case .mainButtonTapped:
                // Only set to main if not already on the main screen
                if !state.navigationPath.contains(.main) {
                    state.navigationPath = [.main] // Set navigationPath to main
                }
                return .none
                
            case .onDismiss:
                if state.navigationPath.count > 1 {
                    state.navigationPath.removeLast()
                }
                return .none

            case let .setNavigationPath(path):
                state.navigationPath = path
                return .none
            }
        }
    }
}
