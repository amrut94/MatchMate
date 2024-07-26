//
//  AcceptButton.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//

import SwiftUI

struct AcceptButton: View {
    var body: some View {
        Image(systemName: "checkmark.circle")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.green)
            .padding()
    }
    
}

#Preview {
    AcceptButton()
}
