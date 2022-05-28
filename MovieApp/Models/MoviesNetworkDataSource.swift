import Foundation

class MoviesNetworkDataSource: MoviesNetworkDataSourceProtocol {
    private let networkService: NetworkingServiceProtocol = NetworkService()

    func getGenres(completionHandlerGenres: @escaping ((Result<[GenreNetwork], RequestError>) -> Void)) {
        var endpoint = URLComponents()

        endpoint.scheme = Constants.baseScheme
        endpoint.host = Constants.baseHost
        endpoint.path = "/3/genre/movie/list"
        endpoint.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey)]

        guard
            let endpoint = endpoint.string,
            let url = URL(string: endpoint)
        else {
            return
        }

        networkService.getGenres(URLRequest(url: url), completionHandler: completionHandlerGenres)
    }

    func getMovies(completionHandlerMovies: @escaping ((Result<[MovieNetwork], RequestError>, MovieGroupConst) -> Void)) {
        getMovies(group: .popular, completionHandlerMovies: completionHandlerMovies)
        getMovies(group: .trending, completionHandlerMovies: completionHandlerMovies)
        getMovies(group: .recommended, completionHandlerMovies: completionHandlerMovies)
        getMovies(group: .topRated, completionHandlerMovies: completionHandlerMovies)
    }


    private func getMovies(group: MovieGroupConst, completionHandlerMovies: @escaping ((Result<[MovieNetwork], RequestError>, MovieGroupConst) -> Void)) {
        var endpoint = URLComponents()

        endpoint.scheme = Constants.baseScheme
        endpoint.host = Constants.baseHost
        switch group {
        case .popular:
            endpoint.path = "/3/movie/popular"
        case .trending:
            endpoint.path = "/3/trending/movie/day"
        case .topRated:
            endpoint.path = "/3/movie/top_rated"
        case .recommended:
            endpoint.path = "/3/movie/103/recommendations"
        }

        endpoint.queryItems = [URLQueryItem(name: "language", value: "en-US"), URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "api_key", value: Constants.apiKey)]

        guard
            let endpoint = endpoint.string,
            let url = URL(string: endpoint)
        else {
            return
        }

        networkService.getMovies(URLRequest(url: url), group: group, completionHandler: completionHandlerMovies)
    }

    func getDetails(id: String, completionHandler: @escaping ((Result<MovieDetails, RequestError>) -> Void)) {
        var endpoint = URLComponents()

        endpoint.scheme = Constants.baseScheme
        endpoint.host = Constants.baseHost
        endpoint.path = "/3/movie/\(id)"

        endpoint.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey)]

        guard
            let endpoint = endpoint.string,
            let url = URL(string: endpoint)
        else {
            return
        }

        networkService.getMovieDetails(URLRequest(url: url), completionHandler: completionHandler)
    }
}
