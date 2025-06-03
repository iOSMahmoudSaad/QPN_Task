//
//  MovieListView.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import SwiftUI

struct MovieListView: View {
    
    @StateObject private var viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                movieList
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Trending Movie")
                    .font(.headline)
                    .foregroundColor(.accent)
            }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
    
    private var movieList: some View {
        List(viewModel.movies) { movie in
            MovieRow(movie: movie)
                .onTapGesture {
                    viewModel.selectMovie(movie)
                }
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
