struct MovieNetwork: Codable {
    let id: Int
    let posterPath: String?
    let title: String
    let overview: String
    let adult: Bool
    let backdropPath: String
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case overview
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
