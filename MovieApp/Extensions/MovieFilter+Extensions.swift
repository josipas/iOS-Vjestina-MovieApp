import MovieAppData

extension MovieFilter {

    var description: String {
        switch self {
        case .streaming:
            return "Streaming"
        case .onTv:
            return "On TV"
        case .forRent:
            return "For rent"
        case .inTheaters:
            return "In theaters"
        case .thriller:
            return "Thriller"
        case .horror:
            return "Horror"
        case .comedy:
            return "Comedy"
        case .romanticComedy:
            return "Romantic comedy"
        case .sport:
            return "Sport"
        case .action:
            return "Action"
        case .sciFi:
            return "Science fiction"
        case .war:
            return "War"
        case .drama:
            return "Drama"
        case .day:
            return "Today"
        case .week:
            return "This week"
        case .month:
            return "This month"
        case .allTime:
            return "Always"
        }
    }
}
