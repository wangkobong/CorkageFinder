//
//  CommunityView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture
import KakaoMapsSDK

public struct MapView: View {
    let store: StoreOf<MapFeature>
    @State var draw: Bool = false
    public init(store: StoreOf<MapFeature>) {
        self.store = store
    }                                                                                   
    public var body: some View {
        KakaoMapView(draw: $draw).onAppear(perform: {
            self.draw = true
        }).onDisappear(perform: {
            self.draw = false
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
        
}

//#Preview {
//    CommunityView()
//}
