//
//  MovieListRow.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import SwiftUI


struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            CachedAsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 135)
                    .cornerRadius(8)
            } placeholder: {
                Color.gray
                    .frame(width: 90, height: 135)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.accentColor)
                
                if let releaseDate = movie.releaseDate {
                    Text("\(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Votes: \(movie.voteCount)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 2) {
                           Text("Rating : \(movie.voteAverage, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.accentColor)
                                .font(.caption)

                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.vertical, 4)
        }
        .padding(.horizontal, 8)
        .background(Color.white)
        .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accentColor, lineWidth: 2)
            )
        .cornerRadius(12)
        .padding(.vertical, 4)
    }
}
