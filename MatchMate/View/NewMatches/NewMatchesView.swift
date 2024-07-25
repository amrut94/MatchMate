//
//  NewMatchesView.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import SwiftUI

struct NewMatchesView: View {
    @StateObject private var viewModel = NewMatchesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile Matches")
                    .font(.largeTitle)
                    .padding(.top)
                
                if let errorMessage = viewModel.errorMessage {
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
                    List(viewModel.profiles, id: \.id) { profile in
                        ProfileView(profile: profile)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.fetchProfilesData()
                        }
                    }) {
                        Text("Load More")
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchProfilesData()
        }
    }
}

#Preview {
    NewMatchesView()
}
