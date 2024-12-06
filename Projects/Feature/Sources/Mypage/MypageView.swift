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
        NavigationView {
            List {
                // 프로필 섹션
                Section {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("사용자 닉네임")
                                .font(.headline)
                            Text("user@email.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // 활동 내역 섹션
                Section("활동 내역") {
                    NavigationLink {
                        Text("내가 등록한 레스토랑")
                    } label: {
                        Label("내가 등록한 레스토랑", systemImage: "square.and.pencil")
                    }
                    
                    NavigationLink {
                        Text("찜한 레스토랑")
                    } label: {
                        Label("찜한 레스토랑", systemImage: "heart.fill")
                    }
                    
                    NavigationLink {
                        Text("최근 본 레스토랑")
                    } label: {
                        Label("최근 본 레스토랑", systemImage: "clock.fill")
                    }
                    
                    NavigationLink {
                        Text("리뷰 작성 내역")
                    } label: {
                        Label("리뷰 작성 내역", systemImage: "star.fill")
                    }
                }
                
                // 계정 설정 섹션
                Section("계정 설정") {
                    NavigationLink {
                        Text("알림 설정")
                    } label: {
                        Label("알림 설정", systemImage: "bell.fill")
                    }
                    
                    NavigationLink {
                        Text("개인정보 수정")
                    } label: {
                        Label("개인정보 수정", systemImage: "person.fill")
                    }
                    
                    NavigationLink {
                        Text("비밀번호 변경")
                    } label: {
                        Label("비밀번호 변경", systemImage: "lock.fill")
                    }
                }
                
                // 기타 섹션
                Section("기타") {
                    NavigationLink {
                        Text("고객센터")
                    } label: {
                        Label("고객센터", systemImage: "questionmark.circle.fill")
                    }
                    
                    NavigationLink {
                        Text("공지사항")
                    } label: {
                        Label("공지사항", systemImage: "bell.badge.fill")
                    }
                    
                    NavigationLink {
                        Text("약관 및 정책")
                    } label: {
                        Label("약관 및 정책", systemImage: "doc.text.fill")
                    }
                    
                    HStack {
                        Label("앱 버전", systemImage: "info.circle.fill")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
                
                // 로그아웃 섹션
                Section {
                    Button(role: .destructive) {
                        // 로그아웃 액션
                    } label: {
                        Text("로그아웃")
                    }
                }
            }
            .navigationTitle("마이페이지")
        }
    }
}

//#Preview {
//    MypageView()
//}
