import UIKit

struct MovieViewModel {
    let id: Int
    let posterPath: UIImage?
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
    var genres: [MovieGenreViewModel] = []

    init(fromModel model: Movie) {
        self.id = Int(model.id)
        if let imageData = model.posterPath as Data? {
            self.posterPath = UIImage(data: imageData)
        } else {
            self.posterPath = nil
        }
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
        if let genres = model.genres {
            for g in genres {
                let genre = g as? MovieGenre
                if let movieGenre = genre {
                    self.genres.append(MovieGenreViewModel(fromModel: movieGenre))
                }
            }
        }
    }
}
