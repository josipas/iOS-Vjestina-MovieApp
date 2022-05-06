import UIKit
import SnapKit

//navigation bar - popraviti!!!!!!

class MovieDetailsViewController: UIViewController {
    private var imageView: OverlayImageView!
    private var overviewLabel: UILabel!
    private var overviewDescription: UILabel!
    private var peopleCollection: UICollectionView!
    private var stackView: UIStackView!
    private var activityIndicatorView: UIActivityIndicatorView!

    private var navigationBarImageView: UIImageView!
    private var navigationBarImage: UIImage!

    private let networkService: NetworkingServiceProtocol = NetworkService()

    private var id: String?

    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let data = [
        ("Don Heck", "Characters"),
        ("Jack Kirby", "Characters"),
        ("Jon Favreau", "Director"),
        ("Don Heck", "Screenplay"),
        ("Jack Marcum", "Screenplay"),
        ("Matt Holloway", "Screenplay"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        getData()

        navigationBarImageView = UIImageView()
        navigationBarImage = UIImage(named: "tmdb")

        navigationBarImageView.frame = CGRect(x: 0, y: 0, width: 145, height: 35)
        navigationBarImageView.image = navigationBarImage

        self.navigationItem.titleView = navigationBarImageView
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)

        overviewLabel = UILabel()
        overviewDescription = UILabel()
        stackView = UIStackView()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        peopleCollection = UICollectionView(frame:
                                                CGRect(
                                                    x: 0,
                                                    y: 0,
                                                    width: (view.bounds.width),
                                                    height: 350),
                                            collectionViewLayout: flowLayout)
        peopleCollection.register(TitleSubtitleCell.self, forCellWithReuseIdentifier: TitleSubtitleCell.reuseIdentifier)
        peopleCollection.delegate = self
        peopleCollection.dataSource = self

        imageView = OverlayImageView()
    }

    private func addSubviews() {
        view.addSubview(stackView)
        stackView.addSubview(imageView)
        stackView.addSubview(overviewLabel)
        stackView.addSubview(overviewDescription)
        stackView.addSubview(peopleCollection)
        stackView.addSubview(activityIndicatorView)
    }

    private func styleViews() {
        view.backgroundColor = .white

        stackView.axis = .vertical

        overviewLabel.text = "Overview"
        overviewLabel.font = .systemFont(ofSize: 20, weight: .bold)
        overviewLabel.textColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)

        overviewDescription.font = .systemFont(ofSize: 14, weight: .regular)
        overviewDescription.numberOfLines = 0
    }

    private func addConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.height.equalTo(303)
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }

        overviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }

        overviewDescription.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(27)
            $0.top.equalTo(overviewLabel.snp.bottom).offset(8)
        }

        peopleCollection.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(overviewDescription.snp.bottom).offset(22)
            $0.bottom.equalToSuperview()
        }

        activityIndicatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }

    private func reload(movieDetails: MovieDetails) {
        var url = ""
        var date = ""
        var year = ""
        var duration = ""
        var genres = ""

        if let posterPath = movieDetails.posterPath {
            url = "\(Constants.baseUrlForImages)\(posterPath)"
        }

        let dateArray = movieDetails.releaseDate.split(separator: "-")

        if dateArray.count > 2 {
            date = "\(dateArray[2])/\(dateArray[1])/\(dateArray[0])"
            year = "(\(dateArray[0]))"
        }

        if let runtime = movieDetails.runtime {
            duration = "\(runtime)m"
        }

        movieDetails.genres.forEach { genre in
            genres += "\(genre.name), "
        }

        imageView.set(data: OverlayImageViewData(imageTitle: url, title: movieDetails.title, year: year, date: date, genres: String(genres.dropLast(2)), duration: duration))

        overviewDescription.text = movieDetails.overview
    }

    private func getData() {
        activityIndicatorView.startAnimating()
        guard let id = id else { return }

        var endpoint = URLComponents()

        endpoint.scheme = Constants.baseScheme
        endpoint.host = Constants.baseHost
        endpoint.path = "/3/movie/\(id)"

        endpoint.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey)]

        guard
            let endpoint = endpoint.string,
            let url = URL(string: endpoint)
        else {
            return
        }

        networkService.getMovieDetails(URLRequest(url: url)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let details):
                print(details)
                DispatchQueue.main.async {
                    self.reload(movieDetails: details)
                    self.activityIndicatorView.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
}

extension MovieDetailsViewController: UICollectionViewDelegate {

}

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = peopleCollection.dequeueReusableCell(withReuseIdentifier: TitleSubtitleCell.reuseIdentifier,
                                                        for: indexPath) as! TitleSubtitleCell
        cell.configure(title: data[indexPath.row].0, subtitle: data[indexPath.row].1)
        return cell
    }
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let peopleCollectionWidth = peopleCollection.frame.width
        let itemDimension = (peopleCollectionWidth - 2*10) / 3

        return CGSize(width: itemDimension, height: 50)
    }
}
