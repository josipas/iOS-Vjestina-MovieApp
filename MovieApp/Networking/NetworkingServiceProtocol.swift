import Foundation

protocol NetworkingServiceProtocol {
    func getMovies(_ request: URLRequest, group: MovieGroup, completionHandler: @escaping ((Result<[Movie], RequestError>, MovieGroup) -> Void))

    func getMovieDetails(_ request: URLRequest, completionHandler: @escaping ((Result<MovieDetails, RequestError>) -> Void))

    func getGenres(_ request: URLRequest, completionHandler: @escaping ((Result<[Genre], RequestError>) -> Void))
}
