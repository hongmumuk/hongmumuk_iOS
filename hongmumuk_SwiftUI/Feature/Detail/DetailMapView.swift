//
//  DetailMapView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/22/25.
//

import ComposableArchitecture
import KakaoMapsSDK
import KakaoMapsSDK_SPM
import NMapsMap
import SwiftUI

// struct DetailMapView: View {
//    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            UIMapView(viewStore: viewStore)
//                .edgesIgnoringSafeArea(.vertical)
//
//            appLinkButton
//                .padding(.bottom, 60)
//        }
//    }
//
//    private var appLinkButton: some View {
//        ZStack(alignment: .center) {
//            HStack(spacing: 0) {
//                mpaButton("naver".localized(), "naverMapIcon") {
//                    viewStore.send(.naverMapButtonTapped)
//                }
//
//                mpaButton("kakao".localized(), "kakaoMapIcon") {
//                    viewStore.send(.kakaoMapButtonTapped)
//                }
//            }
//
//            Rectangle()
//                .fill(Colors.GrayScale.grayscale20)
//                .frame(width: 1, height: 24)
//        }
//        .background(.white)
//        .cornerRadius(12)
//        .applyShadows(Effects.Shadows.strong)
//    }
//
//    private func mpaButton(_ title: String, _ icon: String, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            mpaButtonContent(title, icon)
//        }
//    }
//
//    private func mpaButtonContent(_ title: String, _ icon: String) -> some View {
//        HStack(spacing: 8) {
//            Image(icon)
//                .resizable()
//                .frame(width: 32, height: 32)
//
//            Text(title)
//                .fontStyle(Fonts.body1SemiBold)
//                .foregroundColor(Colors.GrayScale.grayscale70)
//        }
//        .frame(width: 156, height: 80)
//    }
// }
//
// struct UIMapView: UIViewRepresentable {
//    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
//
//    func makeUIView(context: Context) -> NMFNaverMapView {
//        let view = NMFNaverMapView()
//        view.showCompass = true
//        view.showZoomControls = true
//
//        return view
//    }
//
//    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
//        let position = NMGLatLng(
//            lat: viewStore.restaurantDetail.longitude,
//            lng: viewStore.restaurantDetail.latitude
//        )
//
//        let marker = NMFMarker(position: position)
//        marker.mapView = uiView.mapView
//
//        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
//        uiView.mapView.moveCamera(cameraUpdate)
//    }
// }

// MARK: - 리펙토링

struct DetailMapView: View {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            KakaoMapContainer(viewStore: viewStore)
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

struct KakaoMapContainer: UIViewRepresentable {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>
    
    func makeUIView(context: Context) -> KMViewContainer {
        let container = KMViewContainer()
        container.sizeToFit()
        
        context.coordinator.createController(container)
        context.coordinator.controller?.prepareEngine()
        
        return container
    }
    
    func updateUIView(_ uiView: KMViewContainer, context: Context) {
        context.coordinator.controller?.activateEngine()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewStore: viewStore)
    }
    
    class Coordinator: NSObject, MapControllerDelegate {
        let viewStore: ViewStoreOf<DetailFeature>
        var controller: KMController?
        var container: KMViewContainer?
        private var markerLayer: LabelLayer?
        
        init(viewStore: ViewStoreOf<DetailFeature>) {
            self.viewStore = viewStore
        }
        
        func authenticationFailed(_ errorCode: Int, desc: String) {
            print("로그 Kakao Auth 실패:", errorCode, desc)
        }
        
        func createController(_ view: KMViewContainer) {
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        // 엔진 준비 완료 후 호출
        func addViews() {
            let pos = MapPoint(
                longitude: viewStore.restaurantDetail.latitude,
                latitude: viewStore.restaurantDetail.longitude
            )
            
            let info = MapviewInfo(
                viewName: "mapview",
                viewInfoName: "map",
                defaultPosition: pos
            )
            
            controller?.addView(info)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            guard let mapView = controller?.getView("mapview") as? KakaoMap,
                  let container
            else { return }
            
            // 화면 크기에 맞춰 지도 영역 세팅
            mapView.viewRect = container.bounds
            
            // 좌표 지정
            let target = MapPoint(
                longitude: viewStore.restaurantDetail.latitude,
                latitude: viewStore.restaurantDetail.longitude
            )
            
            // Camera 설정 전달(좌표, 줌레벨, 맵뷰)
            let cameraUpdate = CameraUpdate.make(
                target: target,
                zoomLevel: 15,
                mapView: mapView
            )
            
            // Camera 업데이트
            mapView.moveCamera(cameraUpdate)
            
            // poi(마커) 추가를 위한 매니저 생성
            let manager = mapView.getLabelManager()
            
            // 레이블 레이어 생성
            let layerOptions = LabelLayerOptions(
                layerID: "poiLayer",
                competitionType: .none,
                competitionUnit: .symbolFirst,
                orderType: .rank,
                zOrder: 0
            )
            
            markerLayer = manager.addLabelLayer(option: layerOptions)
        
            // 마커 스타일 정의
            let pinImage = UIImage(systemName: "star.fill")
            
            let iconStyle = PoiIconStyle(
                symbol: pinImage,
                anchorPoint: CGPoint(x: 0.5, y: 1.0),
                badges: []
            )
            
            let poiStyle = PoiStyle(
                styleID: "basicPoiStyle",
                styles: [PerLevelPoiStyle(iconStyle: iconStyle, level: 1)]
            )
        
            manager.addPoiStyle(poiStyle)
            
            // 3) POI 객체 생성 및 표시
            if let layer = markerLayer {
                let poiOption = PoiOptions(styleID: "basicPoiStyle")
                let poi = layer.addPoi(option: poiOption, at: target)
                poi?.show()
            }
        }
        
        // addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
        func addViewFailed(_ viewName: String, viewInfoName: String) {
            print("로그 addViewFailed")
        }
        
        /// KMViewContainer 리사이징 될 때 호출.
        func containerDidResized(_ size: CGSize) {
            print("로그 containerDidResized")
            
            guard let mapView = controller?.getView("mapview") as? KakaoMap else {
                return
            }
            
            mapView.viewRect = CGRect(origin: .zero, size: size)
            
            let target = MapPoint(
                longitude: viewStore.restaurantDetail.latitude,
                latitude: viewStore.restaurantDetail.longitude
            )
            
            let update = CameraUpdate.make(mapView: mapView)
            
            mapView.moveCamera(update)
        }
    }
}
