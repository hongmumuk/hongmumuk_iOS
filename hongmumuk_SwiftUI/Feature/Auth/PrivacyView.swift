//
//  PrivacyView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 3/2/25.
//

import ComposableArchitecture
import SwiftUI

struct PrivacyView: View {
    let store: StoreOf<PrivacyFeature>
    
    @ObservedObject var viewStore: ViewStoreOf<PrivacyFeature>
    
    init(store: StoreOf<PrivacyFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    SignupHeaderView(
                        activeStep: 1,
                        title: "필수 약관에 동의해 주세요",
                        subtitle: "서비스 이용을 위해서는 약관 동의가 필요합니다"
                    )
                    
                    allAgreeButton
                        .padding(.top, geometry.size.height * 0.056)
                        .padding(.horizontal, 24)
                    
                    HStack(alignment: .center) {
                        serviceAgreeButton
                        
                        Spacer()
                        
                        serviceModalButton
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 22)
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    
                    HStack(alignment: .center) {
                        privacyAgreeButton
                        
                        Spacer()
                        
                        privacyModalButton
                            .padding(.trailing, 20)
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        SignupToastView(imageName: "checkWhiteIcon", title: "필수 약관 동의가 필요합니다")
                            .opacity(viewStore.isToastShown ? 1 : 0)
                            .animation(.easeOut(duration: 1.0), value: viewStore.isToastShown)
                            .frame(width: geometry.size.width * 0.6, height: 44)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 24)
                        
                        Spacer()
                    }
                    
                    NextButton(title: "다음으로",
                               isActive: viewStore.isContinueButtonEnabled,
                               action: { viewStore.send(.continueButtonTapped) })
                        .frame(height: 60)
                        .padding(.horizontal, 24)
                        .padding(.bottom, geometry.size.height * 0.1)
                        .onTapGesture {
                            if !viewStore.isContinueButtonEnabled {
                                viewStore.send(.toastPresented)
                            }
                        }
                }
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("회원가입")
                        .fontStyle(Fonts.heading1Bold)
                        .foregroundColor(Colors.GrayScale.normal)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { viewStore.send(.backButtonTapped) }) {
                        Image("backButton")
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                    .padding(.leading, 4)
                }
            }
            .sheet(isPresented: Binding(
                get: { viewStore.isServiceModalPresented },
                set: { _, _ in viewStore.send(.serviceModalDismissed) }
            )) {
                PrivacyModalView(
                    title: "서비스 이용약관",
                    content: "",
                    onDismiss: {
                        viewStore.send(.serviceModalDismissed)
                    },
                    agreeAction: {
                        viewStore.send(.serviceAgree)
                        viewStore.send(.serviceModalDismissed)
                    }
                )
            }
            .sheet(isPresented: Binding(
                get: { viewStore.isPrivacyModalPresented },
                set: { _, _ in viewStore.send(.privacyModalDismissed) }
            )) {
                PrivacyModalView(
                    title: "서비스 이용약관",
                    content: "",
                    onDismiss: {
                        viewStore.send(.privacyModalDismissed)
                    },
                    agreeAction: {
                        viewStore.send(.privacyAgree)
                        viewStore.send(.privacyModalDismissed)
                    }
                )
            }
        }
    }
    
    private var allAgreeButton: some View {
        Button(action: {
            viewStore.send(.allAgreeToggled)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Colors.GrayScale.grayscale5)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Colors.Border.normal)
                            .fill(Color.clear)
                    )
                
                HStack(alignment: .center) {
                    Image(viewStore.allAgree ? "checkBlueIcon" : "checkIcon")
                        .frame(width: 32, height: 32)
                    
                    Text("약관 전체 동의 하기")
                        .fontStyle(Fonts.heading2Bold)
                        .foregroundColor(Colors.GrayScale.normal)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var serviceAgreeButton: some View {
        Button(action: {
            viewStore.send(.serviceAgreeToggled)
        }) {
            ZStack {
                HStack(alignment: .top) {
                    Image(viewStore.serviceAgree ? "checkBlueIcon" : "checkIcon")
                        .frame(width: 20, height: 20)
                        .padding(.leading, 20)
                    
                    Text("서비스 이용약관 동의")
                        .fontStyle(Fonts.heading3Medium)
                        .foregroundColor(Colors.GrayScale.normal)
                        .padding(.leading, 8)
                }
            }
        }
    }
    
    private var serviceModalButton: some View {
        Button(action: {
            viewStore.send(.serviceModalPresented)
        }) {
            Image("arrowIcon")
                .frame(width: 32, height: 32)
        }
    }
    
    private var privacyAgreeButton: some View {
        Button(action: {
            viewStore.send(.privacyAgreeToggled)
        }) {
            ZStack {
                HStack(alignment: .top) {
                    Image(viewStore.privacyAgree ? "checkBlueIcon" : "checkIcon")
                        .frame(width: 20, height: 20)
                        .padding(.leading, 20)
                    
                    Text("개인정보 수집 및 이용 동의")
                        .fontStyle(Fonts.heading3Medium)
                        .foregroundColor(Colors.GrayScale.normal)
                        .padding(.leading, 8)
                }
            }
        }
    }
    
    private var privacyModalButton: some View {
        Button(action: {
            viewStore.send(.privacyModalPresented)
        }) {
            Image("arrowIcon")
                .frame(width: 32, height: 32)
        }
    }
}
