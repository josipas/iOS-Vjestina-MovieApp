protocol MoviesNetworkDataSourceProtocol {
    func getGenres(completionHandlerGenres: @escaping ((Result<[GenreNetwork], RequestError>) -> Void))

    func getMovies(completionHandlerMovies: @escaping ((Result<[MovieNetwork], RequestError>, MovieGroupConst) -> Void))
    
    func getDetails(id: String, completionHandler: @escaping ((Result<MovieDetails, RequestError>) -> Void))
}
