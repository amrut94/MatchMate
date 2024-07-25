//
//  HomeView.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            NewMatchesView(viewModel: NewMatchesViewModel(type: .all))
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            NewMatchesView(viewModel: NewMatchesViewModel(type: .matches))
                .tabItem {
                    Label("Matches", systemImage: "person.2.fill")
                }
        }
    }
}

#Preview {
    HomeView()
}
