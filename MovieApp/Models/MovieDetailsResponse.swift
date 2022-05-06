struct MovieDetailsResponse: Codable {
    let genres: [Genre]
    let overview: String?
    let posterPath: String?
    let releaseDate: String
    let runtime: Int?
    let title: String

    enum CodingKeys: String, CodingKey {
        case genres
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case title
    }
}
