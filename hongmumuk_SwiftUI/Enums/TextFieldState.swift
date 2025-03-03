//
//  TextFieldState.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/28/25.
//

import Foundation

public enum TextFieldState {
    case normal // 일반적인 상태
    case focused // 포커스된 상태
    case empty // 비어있는 상태
    case valid // 유효한 입력
    case invalid // 유효하지 않은 입력
    case loginError // 로그인 에러 발생
    case codeInvalid // 인증 코드가 잘못된 경우
    case codeVerified // 인증이 완료된 경우
    case disabled // 인증코드 입력 후 인증이 완료된 코드 텍스트 필드
}
