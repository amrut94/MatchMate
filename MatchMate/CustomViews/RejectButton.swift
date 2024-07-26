//
//  RejectButton.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//

import SwiftUI

struct RejectButton: View {
    var body: some View {
        Image(systemName: "xmark.circle")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.red)
            .padding()
        
    }
}

#Preview {
    RejectButton()
}
