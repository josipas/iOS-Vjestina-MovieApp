import Foundation

protocol NetworkingServiceProtocol {
    func getMovies(_ request: URLRequest, group: MovieGroupConst, completionHandler: @escaping ((Result<[MovieNetwork], RequestError>, MovieGroupConst) -> Void))

    func getMovieDetails(_ request: URLRequest, completionHandler: @escaping ((Result<MovieDetails, RequestError>) -> Void))

    func getGenres(_ request: URLRequest, completionHandler: @escaping ((Result<[GenreNetwork], RequestError>) -> Void))
}
