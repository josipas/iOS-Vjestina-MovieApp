struct MovieGenreViewModel {
    let id: Int
    let name: String

    init(fromModel model: MovieGenre) {
        self.id = Int(model.id)
        self.name = model.name ?? ""
    }
}
