struct MovieGroupViewModel {
    let name: String

    init(fromModel model: MovieGroup) {
        self.name = model.name ?? ""
    }
}
