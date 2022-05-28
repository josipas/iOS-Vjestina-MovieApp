public enum MovieGroupConst: CaseIterable {
    case popular
    case trending
    case topRated
    case recommended

    public var description: String? {
        switch self {
        case .popular:
            return "What's popular"
        case .trending:
            return "Trending"
        case .topRated:
            return "Top rated"
        case .recommended:
            return "Recommended for you"
        }
    }
}
