//
//  DetailMapView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import NMapsMap
import SwiftUI

struct DetailMapView: View {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            UIMapView(viewStore: viewStore)
                .edgesIgnoringSafeArea(.vertical)
            
            appLinkButton
                .padding(.bottom, 60)
        }
    }
    
    private var appLinkButton: some View {
        ZStack(alignment: .center) {
            HStack(spacing: 0) {
                mpaButton("naver".localized(), "naverMapIcon") {
                    viewStore.send(.naverMapButtonTapped)
                }
                
                mpaButton("kakao".localized(), "kakaoMapIcon") {
                    viewStore.send(.kakaoMapButtonTapped)
                }
            }
            
            Rectangle()
                .fill(Colors.GrayScale.grayscale20)
                .frame(width: 1, height: 24)
        }
        .background(.white)
        .cornerRadius(12)
        .applyShadows(Effects.Shadows.strong)
    }
    
    private func mpaButton(_ title: String, _ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            mpaButtonContent(title, icon)
        }
    }
    
    private func mpaButtonContent(_ title: String, _ icon: String) -> some View {
        HStack(spacing: 8) {
            Image(icon)
                .resizable()
                .frame(width: 32, height: 32)
            
            Text(title)
                .fontStyle(Fonts.body1SemiBold)
                .foregroundColor(Colors.GrayScale.grayscale70)
        }
        .frame(width: 156, height: 80)
    }
}

struct UIMapView: UIViewRepresentable {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showCompass = true
        view.showZoomControls = true
        
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let position = NMGLatLng(
            lat: viewStore.restaurantDetail.longitude,
            lng: viewStore.restaurantDetail.latitude
        )
        
        let marker = NMFMarker(position: position)
        marker.mapView = uiView.mapView
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        uiView.mapView.moveCamera(cameraUpdate)
    }
}
