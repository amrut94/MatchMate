//
//  ProfileView.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    var profile: Profile?
    var onAccept: () -> Void
    var onReject: () -> Void
    
    var body: some View {
        VStack {
            let name = (profile?.name?.first ?? "") + " " + (profile?.name?.last ?? "")
            let address = (profile?.location?.city ?? "") + " " + (profile?.location?.state ?? "")
            WebImage(url: URL(string: profile?.picture?.medium ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 100, height: 100, alignment: .center)
            .clipShape(Circle())
            .padding(.top)
            
            Text(name)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 5)
            
            Text("\(profile?.dob?.age ?? 0), \(address)")
                .font(.subheadline)
                .padding(.top, 1)
            if let isAccepted = profile?.isAccepted {
                if isAccepted {
                    Text("Accepted")
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .fill(.green)
                        )
                    
                } else {
                    Text("Declined")
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .fill(.red)
                        )
                }
            } else {
                HStack {
                    RejectButton()
                        .onTapGesture {
                            onReject()
                        }
                    
                    AcceptButton()
                        .onTapGesture {
                            onAccept()
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
#Preview {
    ProfileView(onAccept: {}, onReject: {})
}
