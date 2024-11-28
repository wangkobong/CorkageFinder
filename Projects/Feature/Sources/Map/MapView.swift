//
//  CommunityView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

public struct MapView: View {
    let store: StoreOf<MapFeature>
    
    public init(store: StoreOf<MapFeature>) {
        self.store = store
    }
    public var body: some View {
        Text("MapView")
    }
}

//#Preview {
//    CommunityView()
//}
