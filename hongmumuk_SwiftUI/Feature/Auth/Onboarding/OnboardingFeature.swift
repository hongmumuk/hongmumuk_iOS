//
//  OnboardingFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/16/25.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingFeature: Reducer {
    struct State: Equatable {
        var currentPage: Int = 0
    }
    
    enum Action: Equatable {
        case currentPageChanged(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .currentPageChanged(currentPage):
                state.currentPage = currentPage
                return .none
            }
        }
    }
}
