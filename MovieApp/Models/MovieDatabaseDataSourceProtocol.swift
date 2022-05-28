protocol MovieDatabaseDataSourceProtocol {
    func saveGenres(genres: [GenreNetwork])
    func saveGroups(groups: [MovieGroupConst])
    func saveMovies(movies: [MovieNetwork], group: MovieGroupConst)
    func fetchMovies(forGroupWithName group: MovieGroupConst) -> [Movie]
    func fetchGenres() -> [MovieGenre]
    func updateMovie(forMovieWithId id: Int, isFavorite: Bool)
    func fetchMovies(whichNameContains substring: String) -> [Movie]
    func fetchFavoriteMovies() -> [Movie]
}
