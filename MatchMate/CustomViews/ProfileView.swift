//
//  ProfileView.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import SwiftUI

struct ProfileView: View {
    var profile: Profile?
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: profile?.picture?.thumbnail ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.top)
            
            Text(profile?.name?.first ?? "")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 5)
            
            Text("\(profile?.dob?.age ?? 0), \(profile?.location?.city ?? "")")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 1)
            
            HStack {
                Button(action: {
                    // Reject action
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    // Accept action
                }) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
//#Preview {
//    ProfileView(
//        name: "Amrut Waghmare",
//        age: 29,
//        address: "Aundh, Pune, Maharashtra, India",
//        imageUrl: URL(string: "https://randomuser.me/api/portraits/thumb/women/76.jpg")!)
//}
