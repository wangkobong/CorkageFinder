//
//  CategoryView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

public struct CategoryView: View {
    let store: StoreOf<CategoryFeature>
    
    public init(store: StoreOf<CategoryFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("CategoryView")
    }
}

//#Preview {
//    CategoryView()
//}
