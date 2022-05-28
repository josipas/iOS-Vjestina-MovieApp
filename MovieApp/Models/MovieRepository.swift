class MovieRepository {
    private let networkService: MoviesNetworkDataSourceProtocol
    private let databaseService: MovieDatabaseDataSourceProtocol

    init(networkService: MoviesNetworkDataSourceProtocol, databaseService: MovieDatabaseDataSourceProtocol) {
        self.networkService = networkService
        self.databaseService = databaseService
    }

    func getGenresFromNetwork(completionHandlerGenres: @escaping ((Result<[GenreNetwork], RequestError>) -> Void)) {
        networkService.getGenres(completionHandlerGenres: completionHandlerGenres)
    }

    func getMoviesFromNetwork(completionHandlerMovies: @escaping ((Result<[MovieNetwork], RequestError>, MovieGroupConst) -> Void)) {
        networkService.getMovies(completionHandlerMovies: completionHandlerMovies)
    }

    func getDetailsFromNetwork(id: String, completionHandler: @escaping ((Result<MovieDetails, RequestError>) -> Void)) {
        networkService.getDetails(id: id, completionHandler: completionHandler)
    }

    func saveGenresToDatabase(genres: [GenreNetwork]) {
        databaseService.saveGenres(genres: genres)
    }

    func saveGroupsToDatabase(groups: [MovieGroupConst]) {
        databaseService.saveGroups(groups: groups)
    }

    func saveMoviesToDatabase(movies: [MovieNetwork], group: MovieGroupConst) {
        databaseService.saveMovies(movies: movies, group: group)
    }

    func fetchMoviesFromDatabase(inMovieGroup group: MovieGroupConst) -> [MovieViewModel] {
        return databaseService.fetchMovies(forGroupWithName: group).map {
            MovieViewModel(fromModel: $0)
        }
    }

    func fetchGenresFromDatabase() -> [MovieGenreViewModel] {
        return databaseService.fetchGenres().map {
            MovieGenreViewModel(fromModel: $0)
        }
    }

    func updateMovieInDatabase(movieId: Int, isFavorite: Bool) {
        databaseService.updateMovie(forMovieWithId: movieId, isFavorite: isFavorite)
    }

    func fetchMoviesFromDatabase(text: String) -> [MovieViewModel] {
        databaseService.fetchMovies(whichNameContains: text).map {
            MovieViewModel(fromModel: $0)
        }
    }

    func fetchFavoriteMoviesFromDatabase() -> [MovieViewModel] {
        return databaseService.fetchFavoriteMovies().map {
            MovieViewModel(fromModel: $0)
        }
    }
}
