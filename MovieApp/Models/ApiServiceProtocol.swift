protocol ApiServiceProtocol {
    func getGenres(completionHandlerGenres: @escaping ((Result<[Genre], RequestError>) -> Void))

    func getMovies(completionHandlerMovies: @escaping ((Result<[Movie], RequestError>, MovieGroup) -> Void))
    
    func getDetails(id: String, completionHandler: @escaping ((Result<MovieDetails, RequestError>) -> Void))
}
