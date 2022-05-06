import Foundation

class NetworkService: NetworkingServiceProtocol {
    func getMovies(_ request: URLRequest, completionHandler: @escaping ((Result<[Movie], RequestError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in

            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completionHandler(.failure(.serverError))
                      return
                  }
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }

            guard let value = try? JSONDecoder().decode(MovieResponse.self, from: data)
            else {
                completionHandler(.failure(.dataDecodingError))
                return
            }
            completionHandler(.success(value.results))
        }
        dataTask.resume()
    }

    func getMovieDetails(_ request: URLRequest, completionHandler: @escaping ((Result<MovieDetails, RequestError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in

            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completionHandler(.failure(.serverError))
                      return
                  }
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }

            guard let value = try? JSONDecoder().decode(MovieDetailsResponse.self, from: data)
            else {
                completionHandler(.failure(.dataDecodingError))
                return
            }
            completionHandler(.success(MovieDetails(genres: value.genres, overview: value.overview, posterPath: value.posterPath, releaseDate: value.releaseDate, runtime: value.runtime, title: value.title)))
        }
        dataTask.resume()
    }

    func getGenres(_ request: URLRequest, completionHandler: @escaping ((Result<[Genre], RequestError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in

            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completionHandler(.failure(.serverError))
                      return
                  }
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }

            guard let value = try? JSONDecoder().decode(GenreResponse.self, from: data)
            else {
                completionHandler(.failure(.dataDecodingError))
                return
            }
            completionHandler(.success(value.genres))
        }
        dataTask.resume()
    }
}
