//
//  ReviewMakeNoticeModalView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 8/8/25.
//

import SwiftUI

struct ReviewMakeNoticeModalView: View {
    var title: String
    var content: String
    var onDismiss: () -> Void
    var agreeAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                closeButton
                
                ZStack {
                    scrollView

                    VStack {
                        Spacer()
                        acceptButton
                            .padding(.bottom, geometry.size.height * 0.1)
                    }
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(title)
                    .fontStyle(Fonts.title2Bold)
                    .foregroundColor(Colors.GrayScale.normal)
                
                Text(content)
                    .fontStyle(Fonts.body1Medium)
                    .foregroundColor(Colors.GrayScale.normal)
                    .padding(.top, 40)
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            
            Button(action: onDismiss) {
                Image("modalCloseIcon")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 20)
    }
    
    private var acceptButton: some View {
        Button(action: agreeAction) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Colors.Primary.normal)
                    .frame(height: 60)
                
                Text("review_guidelines_ack".localized())
                    .fontStyle(Fonts.heading2Bold)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 60)
        .padding(.horizontal, 24)
    }
}
