struct Movie: Codable {
    let id: Int
    let posterPath: String?
    let title: String
    let overview: String

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case overview
    }
}
