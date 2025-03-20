//
//  ProfileInfoFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/7/25.
//

import ComposableArchitecture
import SwiftUI

struct ProfileInfoFeature: Reducer {
    struct State: Equatable {
        var pickerSelection = 0
        var profile: ProfileModel = .mock()
        
        var nickName: String = ""
        var nickNameState: TextFieldState = .empty
        var nickNameErrorMessage: String? = nil
        
        var currentPassword: String = ""
        var currentPasswordState: TextFieldState = .empty
        var currentPasswordErrorMessage: String? = nil
        var currentPasswordVisible = false
        var validChangeButton = false
        var changeButtonText = "비밀번호 확인"
        
        var newPassword: String = ""
        var newPasswordState: TextFieldState = .empty
        var newPasswordErrorMessage: String? = "영문, 숫자 포함 8~20자 이내로 입력해 주세요."
        
        var newPasswordConfirm: String = ""
        var newPasswordConfirmState: TextFieldState = .empty
        var newPasswordConfirmErrorMessage: String? = nil

        var todayString = ""
        var token: String = ""
        
        var showLogoutAlert = false
        var showWithdrawAlert = false
        
        var pop = false
        
        var isButtonEnabled: Bool {
            return newPasswordState == .nicknameVerified &&
                newPasswordConfirmState == .nicknameVerified &&
                currentPasswordState == .codeVerified
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case pickerSelectionChanged(Int)
        case checkUser(String)
        
        case profileLoaded(TaskResult<ProfileModel>)
        case nickNameLoaded(TaskResult<Bool>)
        case deleteAccountLoaded(TaskResult<Bool>)
        case postPasswordLoaded(TaskResult<Bool>)
        case resetPasswordLoaded(TaskResult<Bool>)
        case logoutLoaded
        case toRoot
        
        case nickNameChanged(String)
        case nickNameFocused(Bool)
        case nickNameOnSubmit
        case nickNameTextClear
        
        case currentPasswordChanged(String)
        case currentPasswordFocused(Bool)
        case currentPasswordOnSubmit
        case currentPasswordTextClear
        case currentpasswordVisibleToggled
        
        case newPasswordChanged(String)
        case newPasswordFocused(Bool)
        case newPasswordOnSubmit
        case newPasswordTextClear
        
        case newPasswordConfirmChanged(String)
        case newPasswordConfirmFocused(Bool)
        case newPasswordConfirmOnSubmit
        case newPasswordConfirmTextClear

        case changeButtonTapped
        case passwordConfirmButtonTapped
        case logoutButtonTapped
        case logoutConfirmButtonTapped
        case withdrawButtonTapped
        case withdrawConfirmButtonTapped
        case newPasswordConfirmButtonTapped
        
        case alertDismiss
    }
    
    @Dependency(\.profileClient) var profileClient
    @Dependency(\.authClient) var authClient
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.validationClient) var validationClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let today = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy. MM. dd"
                let formattedDate = formatter.string(from: today)
                state.todayString = formattedDate
                
                return .run { send in
                    if let token = await keychainClient.getString(.accessToken) {
                        await send(.checkUser(token))
                    }
                }
                
            case .onDismiss:
                return .none
                
            case let .checkUser(token):
                state.token = token
                return .run { [token = token] send in
                    let result = await TaskResult {
                        try await profileClient.getProfile(token)
                    }
                    
                    await send(.profileLoaded(result))
                }
                
            case let .pickerSelectionChanged(index):
                state.pickerSelection = index
                return .none
                
            case let .profileLoaded(.success(profile)):
                state.profile = profile
                state.nickName = profile.nickName
                
                return .none
                
            case let .profileLoaded(.failure(error)):
                // TODO: 에러 처리
                return .none
                
            case let .nickNameChanged(nickName):
                state.nickName = nickName
                return .none

            case let .nickNameFocused(isFocused):
                state.nickNameState = isFocused ? .focused : (state.nickName.isEmpty ? .empty : .normal)
                state.nickNameErrorMessage = nil
                return .none

            case .nickNameOnSubmit:
                if state.profile.nickName == state.nickName {
                    state.nickNameState = .invalid
                    state.nickNameErrorMessage = "기존 닉네임과 동일합니다."
                } else {
                    state.nickNameState = .nicknameVerified
                    state.nickNameErrorMessage = "사용 가능한 닉네임입니다."
                }
                
                return .none

            case .nickNameTextClear:
                state.nickName = ""
                state.nickNameState = .empty
                state.nickNameErrorMessage = nil
                
                return .none

            case .changeButtonTapped:
                let nickname = state.nickName
                let token = state.token
                
                return .run { send in
                    let result = await TaskResult {
                        try await profileClient.patchNickName(token, nickname)
                    }
                    
                    await send(.nickNameLoaded(result))
                }
                
            case let .nickNameLoaded(.success(_)):
                state.profile.nickName = state.nickName
                return .none
                
            case let .nickNameLoaded(.failure(error)):
                let error = error as? NickNameError ?? .unknown
                
                if error == .duplicate {
                    state.nickNameState = .invalid
                    state.nickNameErrorMessage = "이미 사용 중인 닉네임입니다."
                }
                
                return .none
                
            case .logoutButtonTapped:
                state.showLogoutAlert = true
                return .none
                
            case .logoutConfirmButtonTapped:
                return .run { send in
                    await keychainClient.remove(.accessToken)
                    await keychainClient.remove(.refreshToken)
                    
                    await send(.logoutLoaded)
                }

            case .withdrawButtonTapped:
                state.showWithdrawAlert = true
                return .none
                
            case .withdrawConfirmButtonTapped:
                let token = state.token
                
                return .run { send in
                    let result = await TaskResult {
                        try await profileClient.deleteAccount(token)
                    }
                    
                    await send(.deleteAccountLoaded(result))
                }
                
            case .deleteAccountLoaded(.success(_)):
                return .run { send in
                    await keychainClient.remove(.accessToken)
                    await keychainClient.remove(.refreshToken)
                    await send(.toRoot)
                }
                
            case .toRoot:
                state.pop = true
                return .none
                
            case let .deleteAccountLoaded(.failure(error)):
                // TODO: 에러 처리
                return .none
                
            case .alertDismiss:
                state.showLogoutAlert = false
                state.showWithdrawAlert = false
                return .none
                
            case .logoutLoaded:
                state.pop = true
                return .none
                
            case let .currentPasswordChanged(password):
                state.currentPassword = password
                
                return .none
                
            case let .currentPasswordFocused(isFocused):
                state.currentPasswordErrorMessage = nil
                
                return .none
                
            case .currentPasswordOnSubmit:
                state.validChangeButton = validationClient.validatePassword(state.currentPassword)
                
                return .none

            case .currentPasswordTextClear:
                state.currentPassword = ""
                state.currentPasswordState = .empty
                state.currentPasswordErrorMessage = nil
                state.validChangeButton = validationClient.validatePassword(state.currentPassword)
                
                return .none
                
            case .currentpasswordVisibleToggled:
                state.currentPasswordVisible.toggle()
                
                return .none
                
            case .passwordConfirmButtonTapped:
                let passowrd = state.currentPassword
                let token = state.token
                
                return .run { send in
                    let result = await TaskResult {
                        try await profileClient.postPassword(token, passowrd)
                    }
                    
                    await send(.postPasswordLoaded(result))
                }
                
            case .postPasswordLoaded(.success):
                state.validChangeButton = false
                state.changeButtonText = "확인 완료"
                state.currentPasswordErrorMessage = "현재 비밀번호와 일치합니다."
                state.currentPasswordState = .codeVerified
                
                return .none
                
            case let .postPasswordLoaded(.failure(error)):
                state.currentPasswordErrorMessage = "현재 비밀번호와 일치하지 않습니다."
                state.currentPasswordState = .invalid
                
                return .none
                
            case let .newPasswordChanged(password):
                state.newPassword = password
                
                return .none

            case .newPasswordFocused:
                state.newPasswordState = .empty
                state.newPasswordErrorMessage = "영문, 숫자 포함 8~20자 이내로 입력해 주세요."
                
                return .none

            case .newPasswordOnSubmit:
                if !validationClient.validatePassword(state.newPassword) {
                    state.newPasswordState = .invalid
                } else {
                    state.newPasswordErrorMessage = ""
                }
                
                return .none

            case .newPasswordTextClear:
                state.newPassword = ""
                state.newPasswordState = .empty
                
                return .none
                
            case let .newPasswordConfirmChanged(password):
                state.newPasswordConfirm = password
                state.newPasswordConfirmErrorMessage = ""
                
                return .none

            case .newPasswordConfirmFocused:
                state.newPasswordConfirmState = .empty
                
                return .none

            case .newPasswordConfirmOnSubmit:
                if state.newPasswordConfirm != state.newPassword {
                    state.newPasswordConfirmState = .invalid
                    state.newPasswordConfirmErrorMessage = "비밀번호가 일치하지 않습니다."
                } else {
                    state.newPasswordState = .nicknameVerified
                    state.newPasswordConfirmState = .nicknameVerified
                    state.newPasswordConfirmErrorMessage = "비밀번호가 일치합니다."
                }
                
                return .none

            case .newPasswordConfirmTextClear:
                state.newPasswordConfirm = ""
                state.newPasswordConfirmState = .empty
                state.newPasswordConfirmErrorMessage = nil
                
                return .none

            case .newPasswordConfirmButtonTapped:
                let email = state.profile.email
                let password = state.newPasswordConfirm
                
                let body = ResetPasswordModel(email: email, newPassword: password)
                
                return .run { send in
                    let result = await TaskResult {
                        try await authClient.resetPassword(body)
                    }
                    
                    await send(.resetPasswordLoaded(result))
                }
                
            case .resetPasswordLoaded(.success):
                state.pop = true
                return .none

            case let .resetPasswordLoaded(.failure(error)):
                return .none
            }
        }
    }
}
