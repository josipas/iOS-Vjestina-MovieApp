import MovieAppData

extension MovieGroup  {
    var description: String? {
        switch self {
        case .popular:
            return "What's popular"
        case .freeToWatch:
            return "Free to watch"
        case .trending:
            return "Trending"
        case .upcoming:
            return nil
        case .topRated:
            return nil
        }
    }
}
