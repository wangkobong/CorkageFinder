//
//  CategoryView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

public struct RegisterRestaurantView: View {
    let store: StoreOf<RegisterRestaurantFeature>
    
    public init(store: StoreOf<RegisterRestaurantFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("RegisterRestaurantView")
    }
}

//#Preview {
//    RegisterRestaurantView()
//}
