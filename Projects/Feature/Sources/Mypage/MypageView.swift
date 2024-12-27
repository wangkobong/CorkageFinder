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
            VStack {
                if store.loginedUser != nil {
                    authenticatedProfileView
                } else {
                    unauthenticatedProfileView
                }
            }
            .navigationTitle("마이페이지")
            .onAppear {
                store.send(.checkAuthState)
            }
        }
    }
    
    private var authenticatedProfileView: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(store.loginedUser?.name ?? "이름 정보 없음")
                    .font(.headline)
                Text(store.loginedUser?.userEmail ?? "유저 이메일 없음")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(store.loginedUser?.loginType ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            //                // 활동 내역 섹션
            //                Section("활동 내역") {
            //                    NavigationLink {
            //                        Text("내가 등록한 레스토랑")
            //                    } label: {
            //                        Label("내가 등록한 레스토랑", systemImage: "square.and.pencil")
            //                    }
            //
            //                    NavigationLink {
            //                        Text("찜한 레스토랑")
            //                    } label: {
            //                        Label("찜한 레스토랑", systemImage: "heart.fill")
            //                    }
            //
            //                    NavigationLink {
            //                        Text("최근 본 레스토랑")
            //                    } label: {
            //                        Label("최근 본 레스토랑", systemImage: "clock.fill")
            //                    }
            //
            //                    NavigationLink {
            //                        Text("리뷰 작성 내역")
            //                    } label: {
            //                        Label("리뷰 작성 내역", systemImage: "star.fill")
            //                    }
            //                }
            //
            //                // 계정 설정 섹션
            //                Section("계정 설정") {
            //                    NavigationLink {
            //                        Text("알림 설정")
            //                    } label: {
            //                        Label("알림 설정", systemImage: "bell.fill")
            //                    }
            //
            //                    NavigationLink {
            //                        Text("개인정보 수정")
            //                    } label: {
            //                        Label("개인정보 수정", systemImage: "person.fill")
            //                    }
            //
            //                    NavigationLink {
            //                        Text("비밀번호 변경")
            //                    } label: {
            //                        Label("비밀번호 변경", systemImage: "lock.fill")
            //                    }
            //                }
            //
            //                // 기타 섹션
            //                Section("기타") {
            //                    NavigationLink {
            //                        Text("고객센터")
            //                    } label: {
            //                        Label("고객센터", systemImage: "questionmark.circle.fill")
            //                    }
            //
            //                    NavigationLink {
            //                        Text("공지사항")
            //                    } label: {
            //                        Label("공지사항", systemImage: "bell.badge.fill")
            //                    }
            //
            //                    NavigationLink {
            //                        Text("약관 및 정책")
            //                    } label: {
            //                        Label("약관 및 정책", systemImage: "doc.text.fill")
            //                    }
            //
            //                    HStack {
            //                        Label("앱 버전", systemImage: "info.circle.fill")
            //                        Spacer()
            //                        Text("1.0.0")
            //                            .foregroundColor(.gray)
            //                    }
            //                }
            //
            
            logoutSection
        }
    }
    
    private var unauthenticatedProfileView: some View {
        VStack {

            
            loginButtonSection
            
        }
    }
    
    private var loginButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                store.send(.login(.google))
            }) {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Google로 계속하기")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
            
            Button(action: {
                store.send(.login(.apple))

            }) {
                HStack {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Apple로 계속하기")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
    
    private var logoutSection: some View {
        Section {
            Button(role: .destructive) {
                store.send(.logout)
            } label: {
                Text("로그아웃")
            }
        }
    }
}

//#Preview {
//    MypageView()
//}
