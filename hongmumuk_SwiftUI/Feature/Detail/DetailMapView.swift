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
        ZStack {
            UIMapView(viewStore: viewStore)
                .edgesIgnoringSafeArea(.vertical)
        }
    }
}

struct UIMapView: UIViewRepresentable {
    @ObservedObject var viewStore: ViewStoreOf<DetailFeature>

    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showCompass = true
        view.showZoomControls = true
        view.showLocationButton = true

        return view
    }

    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let position = NMGLatLng(
            lat: viewStore.restaurantDetail.latitude,
            lng: viewStore.restaurantDetail.longitude
        )

        let marker = NMFMarker(position: position)
        marker.mapView = uiView.mapView
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        uiView.mapView.moveCamera(cameraUpdate)
    }
}
