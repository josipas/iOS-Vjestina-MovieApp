//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Five on 24.05.2022..
//

struct MovieViewModel {
    let id: Int
    let posterPath: String?
    let title: String
    let overview: String
    let adult: Bool
    let backdropPath: String
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let isFavorite: Bool

    init(fromModel model: Movie) {
        self.id = Int(model.id)
        self.posterPath = model.posterPath ?? ""
        self.title = model.title ?? ""
        self.overview = model.overview ?? ""
        self.adult = model.adult
        self.backdropPath = model.backdropPath ?? ""
        self.originalLanguage = model.originalLanguage ?? ""
        self.originalTitle = model.originalTitle ?? ""
        self.popularity = model.popularity
        self.releaseDate = model.releaseDate ?? ""
        self.video = model.video
        self.voteAverage = model.voteAverage
        self.voteCount = Int(model.voteCount)
        self.isFavorite = model.isFavorite
    }
}
