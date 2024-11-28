//
//  MypageView.swift
//  Feature
//
//  Created by sungyeon on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

public struct MypageView: View {
    let store: StoreOf<MypageFeature>
    
    public init(store: StoreOf<MypageFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("MypageView")
    }
}

//#Preview {
//    MypageView()
//}
