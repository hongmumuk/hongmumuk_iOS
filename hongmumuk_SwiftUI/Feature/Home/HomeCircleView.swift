//
//  HomeCircleView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeCircleView: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>

    var body: some View {
        ZStack {
            CircleSection(viewStore: viewStore)
            CenterButton(viewStore: viewStore)
        }
        .frame(width: viewStore.diameter, height: viewStore.diameter)
        .gesture(dragGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewStore.send(.dragChanged(value), animation: .default)
            }
            .onEnded { _ in
                viewStore.send(.dragEnded, animation: .default)
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
    }
}

private struct CircleSection: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    
    var body: some View {
        ZStack {
            ForEach(0 ..< viewStore.categories.count, id: \.self) { i in
                let startAngle = Double(i) * viewStore.sliceAngle
                let endAngle = startAngle + viewStore.effectiveAngle
                let midAngle = (startAngle + endAngle) / 2

                DonutWedgeShape(
                    startAngle: startAngle,
                    endAngle: endAngle,
                    innerRadius: viewStore.innerRadius,
                    outerRadius: viewStore.outerRadius
                )
                .fill(Colors.Primary.primary5)
                .stroke(Colors.Border.normal)

                MenuItemView(category: viewStore.categories[i])
                    .rotationEffect(.degrees(-viewStore.rotation))
                    .position(
                        x: viewStore.outerRadius
                            + viewStore.midRadius * cos(midAngle.toRadians),
                        y: viewStore.outerRadius
                            + viewStore.midRadius * sin(midAngle.toRadians)
                    )
                    .onTapGesture {
                        viewStore.send(.categoryItemTapped(viewStore.categories[i]))
                    }
            }
        }
        .rotationEffect(.degrees(viewStore.rotation))
    }
}

private struct CenterButton: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>

    var body: some View {
        Button(action: {}) {
            Image("homeLogo")
        }
    }
}

private struct DonutWedgeShape: Shape {
    let startAngle: Double
    let endAngle: Double
    let innerRadius: CGFloat
    let outerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)

        // 바깥쪽 호 시작점
        path.move(to: pointOnCircle(center, outerRadius, startAngle))

        // 바깥 호
        path.addArc(
            center: center,
            radius: outerRadius,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )

        // 바깥 -> 안쪽 연결 선
        path.addLine(to: pointOnCircle(center, innerRadius, endAngle))

        // 안쪽 호
        path.addArc(
            center: center,
            radius: innerRadius,
            startAngle: .degrees(endAngle),
            endAngle: .degrees(startAngle),
            clockwise: true
        )

        path.closeSubpath()
        return path
    }

    private func pointOnCircle(_ center: CGPoint, _ radius: CGFloat, _ angleDeg: Double) -> CGPoint {
        let rad = angleDeg.toRadians
        return CGPoint(
            x: center.x + radius * CGFloat(cos(rad)),
            y: center.y + radius * CGFloat(sin(rad))
        )
    }
}

private struct MenuItemView: View {
    let category: Category

    var body: some View {
        VStack(spacing: 4) {
            Image(category.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 36)

            Text(category.displayName)
                .foregroundColor(.black)
        }
    }
}
