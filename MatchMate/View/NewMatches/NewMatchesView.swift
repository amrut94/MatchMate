//
//  NewMatchesView.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import SwiftUI

enum MatchType {
    case all
    case matches
}

struct NewMatchesView: View {
    @StateObject private var viewModel: NewMatchesViewModel
    
    init(viewModel: NewMatchesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile Matches")
                    .font(.largeTitle)
                    .padding(.top)
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = viewModel.errorMessage, !viewModel.showAlert {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchProfilesData()
                            }
                        }) {
                            Text("Retry")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                } else {
                    if viewModel.profiles.isEmpty {
                        EmptyStateView()
                    } else {
                        List(viewModel.profiles.indices, id: \.self) { index in
                            ProfileView(profile: viewModel.profiles[index],
                                        onAccept: {
                                viewModel.upateProfileStatus(index: index, status: true)
                            },
                                        onReject: {
                                viewModel.upateProfileStatus(index: index, status: false)
                            })
                            .onAppear {
                                // Load more items when the user scrolls to the last 10 items
                                if viewModel.profiles.count > 0 {
                                    let totalItems = viewModel.profiles.count
                                    if index == (totalItems - 10) {
                                        Task {
                                            await viewModel.loadMoreData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchProfilesData()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NewMatchesView(viewModel: NewMatchesViewModel(type: .all))
}
