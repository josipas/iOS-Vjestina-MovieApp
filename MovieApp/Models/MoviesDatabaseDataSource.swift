import CoreData
import UIKit

class MoviesDatabaseDataSource: MovieDatabaseDataSourceProtocol {
    func saveGroups(groups: [MovieGroupConst]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetch: NSFetchRequest<MovieGroup> = MovieGroup.fetchRequest()

        guard
            let count = try? managedContext.count(for: fetch),
            count == 0
        else {
            return
        }

        for group in groups {
            let entity = NSEntityDescription.entity(forEntityName: "MovieGroup", in:
                                                        managedContext)!

            let movieGroup = MovieGroup(entity: entity, insertInto: managedContext)

            if
                let name = group.description
            {
                movieGroup.name = name
            }

            try? managedContext.save()
        }
    }

    func saveGenres(genres: [GenreNetwork]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetch: NSFetchRequest<MovieGenre> = MovieGenre.fetchRequest()

        guard
            let count = try? managedContext.count(for: fetch),
            count == 0
        else {
            return
        }

        for genre in genres {
            let entity = NSEntityDescription.entity(forEntityName: "MovieGenre", in:
                                                        managedContext)!

            let movieGenre = MovieGenre(entity: entity, insertInto: managedContext)

            movieGenre.id = Int16(genre.id)
            movieGenre.name = genre.name

            try? managedContext.save()
        }
    }

    func saveMovies(movies: [MovieNetwork], group: MovieGroupConst) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        guard
            let groupName = group.description,
            let group = fetchMovieGroup(withName: groupName)
        else {
            return
        }
        for movieNetwork in movies {

            let entity = NSEntityDescription.entity(forEntityName: "Movie", in:
                                                        managedContext)!

            if
                let movieDatabase = fetchMovie(forMovieWithId: movieNetwork.id)
            {
                group.addToGroupMovies(movieDatabase)
            } else {
                print("nije u bazi")
                let movie = Movie(entity: entity, insertInto: managedContext)
                movie.id = Int32(movieNetwork.id)
                movie.posterPath = movieNetwork.posterPath
                movie.title = movieNetwork.title
                movie.overview = movieNetwork.overview
                movie.adult = movieNetwork.adult
                movie.backdropPath = movieNetwork.backdropPath
                movie.originalLanguage = movieNetwork.originalLanguage
                movie.originalTitle = movieNetwork.originalTitle
                movie.popularity = movieNetwork.popularity
                movie.releaseDate = movieNetwork.releaseDate
                movie.video = movieNetwork.video
                movie.voteAverage = movieNetwork.voteAverage
                movie.voteCount = Int32(movieNetwork.voteCount)
                movie.isFavorite = false

                for genre in movieNetwork.genreIds {
                    if
                        let genreDatabase = fetchGenre(forGenreWithId: genre)
                    {
                        print("u filmu našli žanr wooohooo")
                        genreDatabase.addToMovies(movie)
                    }
                }
                group.addToGroupMovies(movie)
            }
            try? managedContext.save()
        }
    }

    func fetchGenre(forGenreWithId genreId: Int) -> MovieGenre? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MovieGenre> = MovieGenre.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", "\(genreId)")
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            return try managedContext.fetch(request).first
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return nil
        }
    }

    func fetchMovie(forMovieWithId movieId: Int) -> Movie? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", "\(movieId)")
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            return try managedContext.fetch(request).first
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return nil
        }
    }

    func fetchMovieGroup(withName name: String) -> MovieGroup? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<MovieGroup> = MovieGroup.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", "\(name)")
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            return try managedContext.fetch(request).first
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return nil
        }
    }

    func fetchMovies() -> [Movie] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            let results = try managedContext.fetch(request)
            return results
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return []
        }
    }

    func fetchGenres() -> [MovieGenre] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<MovieGenre> = MovieGenre.fetchRequest()
        do {
            let results = try managedContext.fetch(request)
            return results
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return []
        }
    }

    func fetchGroups() -> [MovieGroup] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<MovieGroup> = MovieGroup.fetchRequest()
        do {
            let results = try managedContext.fetch(request)
            return results
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return []
        }
    }

    func fetchMovies(forGroupWithName group: MovieGroupConst) -> [Movie] {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let groupName = group.description
        else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "ANY groups.name = %@", "\(groupName)")
        request.predicate = predicate
        do {
            return try managedContext.fetch(request)
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return []
        }
    }

    func fetchFavoriteMovies() -> [Movie] {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate        else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite = true")
        request.predicate = predicate
        do {
            return try managedContext.fetch(request)
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return []
        }
    }

    func updateMovie(forMovieWithId id: Int, isFavorite: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let movie = fetchMovie(forMovieWithId: id)
        movie?.isFavorite = isFavorite
        try? managedContext.save()
    }

    func fetchMovies(whichNameContains substring: String) -> [Movie] {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate        else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "%K CONTAINS[c] %@", argumentArray: [#keyPath(Movie.title), substring])

        request.predicate = predicate
        do {
            return try managedContext.fetch(request)
        } catch let error as NSError {
            print("Error \(error) | Info: \(error.userInfo)")
            return []
        }
    }
}
