//
//  ProfileView.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import SwiftUI

struct ProfileView: View {
    var profile: Profile?
    var onAccept: () -> Void
    var onReject: () -> Void
    let imageSize: CGFloat = 100
    
    var body: some View {
        VStack {
            let name = (profile?.name?.first ?? "") + " " + (profile?.name?.last ?? "")
            let address = (profile?.location?.city ?? "") + " " + (profile?.location?.state ?? "")
            
            CacheAsyncImage(url: URL(string: profile?.picture?.medium ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: imageSize, height: imageSize)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipped()
                case .failure:
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(Circle())
            
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
