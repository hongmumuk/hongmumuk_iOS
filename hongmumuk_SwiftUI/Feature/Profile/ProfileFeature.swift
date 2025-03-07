//
//  ProfileFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/6/25.
//

import ComposableArchitecture
import SwiftUI

struct ProfileFeature: Reducer {
    struct State: Equatable {
        var isUser = false
        var token: String = ""
        var currentVersion = ""
        var showLoginAlert = false
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case checkUser(String?)
        case loginButtonTapped
        case loginAlertDismissed
    }
    
    @Dependency(\.keychainClient) var keychainClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.currentVersion = "v" + Bundle.main.fullVersion
                
                return .run { send in
                    let token = await keychainClient.getString(.accessToken)
                    await send(.checkUser(token))
                }
                
            case .onDismiss:
                return .none
                
            case let .checkUser(token):
                if let token {
                    state.isUser = true
                    state.token = token
                }
                
                return .none
                
            case .loginButtonTapped:
                state.showLoginAlert = true
                return .none
                
            case .loginAlertDismissed:
                state.showLoginAlert = false
                return .none
            }
        }
    }
}
