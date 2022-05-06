struct Movie: Codable {
    let id: Int
    let posterPath: String?
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
    }
}

