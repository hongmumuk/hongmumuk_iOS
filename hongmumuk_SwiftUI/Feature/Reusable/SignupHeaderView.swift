//
//  SignupHeaderView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct SignupHeaderView: View {
    let activeStep: Int
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading) {
            activeStepView
                .padding(.leading, 24)
                .padding(.top, 40)
            
            titleView
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            subtitleView
                .padding(.horizontal, 24)
                .padding(.top, 8)
        }
    }

    private var activeStepView: some View {
        HStack(alignment: .center, spacing: 12) {
            ProgressButton(number: "1", isActive: activeStep == 1)
                .frame(width: 24, height: 24)
            ProgressButton(number: "2", isActive: activeStep == 2)
                .frame(width: 24, height: 24)
            ProgressButton(number: "3", isActive: activeStep == 3)
                .frame(width: 24, height: 24)
        }
    }

    private var titleView: some View {
        Text(title)
            .fontStyle(Fonts.title2Bold)
            .foregroundStyle(Colors.GrayScale.normal)
    }

    private var subtitleView: some View {
        Text(subtitle)
            .fontStyle(Fonts.heading3Medium)
            .foregroundStyle(Colors.GrayScale.alternative)
    }
}
