//
//  String+.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import Foundation

extension String {
    // 단어를 초성으로 변환
    func convertToChosung() -> String {
        let chosungArr = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
        var result = ""
        
        for char in self {
            if let scalar = char.unicodeScalars.first?.value {
                if scalar >= 0xAC00, scalar <= 0xD7A3 {
                    let index = (Int(scalar) - 0xAC00) / 28 / 21
                    result += chosungArr[index]
                } else {
                    result += String(char)
                }
            }
        }
        return result
    }
    
    // 입력된 단어가 초성인지 판단
    func isChosung() -> Bool {
        return allSatisfy { char in
            let scalar = char.unicodeScalars.first?.value ?? 0
            return (0x3131 ... 0x314E).contains(scalar)
        }
    }
}
