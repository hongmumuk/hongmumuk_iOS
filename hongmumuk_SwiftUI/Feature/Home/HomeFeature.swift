//
//  HomeFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/4/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeFeature: Reducer {
    enum ActiveScreen: Equatable {
        case none
        case search
        case random
        case cateogryList(Category)
    }

    struct State: Equatable {
        var categories: [Category] = []
        var activeScreen: ActiveScreen = .none
        var rotation: Double = 0
        var outerRadius: CGFloat = 0
        var innerRadius: CGFloat = 0
        var chordLength: CGFloat = 0
        var startAngle: Double? = nil

        var sliceAngle: Double {
            360.0 / Double(categories.count)
        }

        var gapAngleDeg: Double {
            let gapAngleRad = 2 * asin(chordLength / (2 * outerRadius))
            return Double(gapAngleRad) * 180 / .pi
        }

        var effectiveAngle: Double {
            sliceAngle - gapAngleDeg
        }

        var midRadius: CGFloat {
            (innerRadius + outerRadius) / 2
        }

        var diameter: CGFloat {
            outerRadius * 2
        }

        var centerPosition: CGPoint {
            CGPoint(x: outerRadius, y: outerRadius)
        }
    }

    enum Action: Equatable {
        case onAppear
        case onDismiss
        case categoryItemTapped(Category)
        case randomButtonTapped
        case searchButtonTapped
        case dragChanged(DragGesture.Value)
        case dragEnded
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.categories = Category.allCases.filter { $0 != .all }
            state.activeScreen = .none
            state.rotation = -state.sliceAngle * 3
            state.outerRadius = UIScreen.main.bounds.width / 2 - 24
            state.innerRadius = 65

            return .none
        case .onDismiss:
            state.activeScreen = .none
            return .none
        case let .categoryItemTapped(category):
            state.activeScreen = .cateogryList(category)

            return .none
        case .randomButtonTapped:
            state.activeScreen = .random

            return .none
        case .searchButtonTapped:
            state.activeScreen = .search

            return .none
        case let .dragChanged(value):
            let center = state.centerPosition
            let currentAngle = atan2(value.location.y - center.y, value.location.x - center.x) * 180 / .pi

            if let lastAngle = state.startAngle {
                var delta = currentAngle - lastAngle
                // 180° 이상 차이나면 보정
                if delta > 180 { delta -= 360 }
                if delta < -180 { delta += 360 }
                state.rotation += delta
            }
            
            state.startAngle = currentAngle
            return .none
        case .dragEnded:
            state.startAngle = nil
            let snappedRotation = round(state.rotation / state.sliceAngle) * state.sliceAngle
            state.rotation = snappedRotation
            return .none
        }
    }
}
