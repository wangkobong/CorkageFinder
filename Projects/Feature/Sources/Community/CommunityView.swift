//
//  CategoryView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

public struct CommunityView: View {
    let store: StoreOf<CommunityFeature>
    
    public init(store: StoreOf<CommunityFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("CommunityView")
    }
}

//#Preview {
//    CategoryView()
//}
