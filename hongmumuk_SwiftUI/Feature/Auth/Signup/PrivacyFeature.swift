//
//  PrivacyFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct PrivacyFeature: Reducer {
    struct State: Equatable {
        var serviceAgree: Bool = false
        var privacyAgree: Bool = false
        var allAgree: Bool = false
        
        var isServiceModalPresented: Bool = false
        var isPrivacyModalPresented: Bool = false
        
        var isToastShown: Bool = false
        
        var isContinueButtonEnabled: Bool {
            allAgree
        }
    }
    
    enum Action: Equatable {
        case serviceAgreeToggled
        case privacyAgreeToggled
        case allAgreeToggled
        
        case serviceAgree
        case privacyAgree
        
        case serviceModalPresented
        case privacyModalPresented
        
        case serviceModalDismissed
        case privacyModalDismissed
        
        case toastPresented
        case toastDismissed
        
        case continueButtonTapped
        case backButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .serviceAgreeToggled:
                state.serviceAgree.toggle()
                state.allAgree = state.serviceAgree && state.privacyAgree
                return .none
                
            case .serviceAgree:
                state.serviceAgree = true
                state.allAgree = state.serviceAgree && state.privacyAgree
                return .none
                
            case .privacyAgreeToggled:
                state.privacyAgree.toggle()
                state.allAgree = state.serviceAgree && state.privacyAgree
                return .none
                
            case .privacyAgree:
                state.privacyAgree = true
                state.allAgree = state.serviceAgree && state.privacyAgree
                return .none
                
            case .allAgreeToggled:
                if state.allAgree {
                    state.allAgree = false
                    state.serviceAgree = false
                    state.privacyAgree = false
                } else {
                    state.allAgree = true
                    state.serviceAgree = true
                    state.privacyAgree = true
                }
                return .none
                
            case .serviceModalPresented:
                state.isServiceModalPresented = true
                return .none
                
            case .serviceModalDismissed:
                state.isServiceModalPresented = false
                return .none
                
            case .privacyModalPresented:
                state.isPrivacyModalPresented = true
                return .none
                
            case .privacyModalDismissed:
                state.isPrivacyModalPresented = false
                return .none
                
            case .toastPresented:
                state.isToastShown = true
                return .run { send in
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    await send(.toastDismissed)
                }
                
            case .toastDismissed:
                withAnimation(.easeOut(duration: 1.0)) {
                    state.isToastShown = false
                }
                return .none
                
            case .continueButtonTapped:
               
                return .none
                
            case .backButtonTapped:
                return .none
            }
        }
    }
}
