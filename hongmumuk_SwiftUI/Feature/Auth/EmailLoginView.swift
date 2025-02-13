//
//  EmailLoginView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

struct EmailLoginView: View {
    let store: StoreOf<EmailLoginFeature>
    @ObservedObject var viewStore: ViewStoreOf<EmailLoginFeature>
    
    init(store: StoreOf<EmailLoginFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(alignment: .leading, spacing: geometry.size.height * 0.03) {
                    Divider()
                        .background(Colors.Border.neutral)
                        .frame(height: 1)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("이메일")
                            .fontStyle(Fonts.heading2Bold)
                            .foregroundStyle(Colors.GrayScale.normal)
                            .padding(.leading, 24)
                            .padding(.top, geometry.size.height * 0.04)
                        
                        ZStack {
                            UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                                .fill(Color(hex: "FBFBFE"))
                                .frame(height: geometry.size.height * 0.06)
                            
                            Divider()
                                .background(Colors.Border.strong)
                                .frame(height: 1)
                                .padding(.top, geometry.size.height * 0.06)
                            
                            TextField(
                                "학교 이메일을 입력해주세요",
                                text: Binding(
                                    get: { viewStore.email },
                                    set: { viewStore.send(.emailChanged($0))
                                    }
                                )
                            )
                            // .textFieldStyle(Fonts.body1Medium)
                            .foregroundColor(Colors.GrayScale.normal)
                            .multilineTextAlignment(.leading)
                            .frame(height: geometry.size.height * 0.07)
                            .padding(.horizontal, 12)
                        }
                        .padding(.horizontal, 24)
                        .frame(height: geometry.size.height * 0.07)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("비밀번호")
                            .fontStyle(Fonts.heading2Bold)
                            .foregroundStyle(Colors.GrayScale.normal)
                            .padding(.leading, 24)
                        
                        ZStack {
                            UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12)
                                .fill(Color(hex: "FBFBFE"))
                                .frame(height: geometry.size.height * 0.06)
                            
                            Divider()
                                .background(Colors.Border.strong)
                                .frame(height: 1)
                                .padding(.top, geometry.size.height * 0.06)
                            
                            TextField(
                                "영문, 숫자 포함 8-20자 이내로 입력해 주세요",
                                text: Binding(
                                    get: { viewStore.password },
                                    set: { viewStore.send(.passwordChanged($0))
                                    }
                                )
                            )
                            // .textFieldStyle(Fonts.body1Medium)
                            .foregroundColor(Colors.GrayScale.normal)
                            .multilineTextAlignment(.leading)
                            .frame(height: geometry.size.height * 0.07)
                            .padding(.horizontal, 12)
                        }
                        .padding(.horizontal, 24)
                        .frame(height: geometry.size.height * 0.07)
                    }
                    
                    NextButton(title: "로그인", isActive: false, action: { print("버튼이 눌렸습니다!") })
                        .frame(height: geometry.size.height * 0.07)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                    
                    HStack(alignment: .center, spacing: 12) {
                        Button(action: { print("버튼이 눌렸습니다!") }) {
                            Text("회원가입")
                                .fontStyle(Fonts.body1Medium)
                                .foregroundStyle(Colors.GrayScale.alternative)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                            .background(Colors.GrayScale.alternative)
                            .frame(height: geometry.size.height * 0.02)
                        
                        Button(action: { print("버튼이 눌렸습니다!") }) {
                            Text("비밀번호 찾기")
                                .fontStyle(Fonts.body1Medium)
                                .foregroundStyle(Colors.GrayScale.alternative)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.05)
                    .padding(.top, 12)
                    
                    Spacer()
                }
                .navigationTitle("이메일로 로그인")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("이메일로 로그인")
                            .fontStyle(Fonts.heading1Bold)
                            .foregroundColor(Colors.GrayScale.normal)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Action
                        }) {
                            Image("backButton")
                                .resizable()
                                .frame(width: 36, height: 36)
                        }
                        .padding(.leading, 4)
                    }
                }
            }
        }
    }
}
