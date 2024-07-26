//
//  EmptyStateView.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 26/07/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            Text("No Records Found")
                .font(.title)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
    }
}
