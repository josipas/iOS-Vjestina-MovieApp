import UIKit

protocol MoviePictureCollectionViewCellDelegate: AnyObject {
    func heartTapped(movieId: Int, state: Bool)
}

class MoviePictureCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MoviePictureCollectionViewCell.self)

    private var image: UIImage!
    private var imageView: UIImageView!
    private var heartView: RoundImageBackgroundView!
    private var view: UIView!
    private var movieId: Int?

    weak var delegate: MoviePictureCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

    func set(imageUrl: String, movieId: Int, isFavorite: Bool) {
        imageView.load(imageUrl: imageUrl)
        self.movieId = movieId
        heartView.set(isFavorite: isFavorite)
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addContraints()
    }

    private func createViews() {
        imageView = UIImageView()
        heartView = RoundImageBackgroundView(imageTitle: "heart", hexColor: "#0B253F", size: 18)
        heartView.delegate = self
    }

    private func addSubviews() {
        addSubview(imageView)
        addSubview(heartView)
    }

    private func styleViews() {
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
    }

    private func addContraints() {
        imageView.snp.makeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview()
        }

        heartView.snp.makeConstraints {
            $0.height.width.equalTo(32)
            $0.top.leading.equalToSuperview().inset(10)
        }
    }
}

extension MoviePictureCollectionViewCell: RoundImageBackgroundViewDelegate {
    func heartTapped(state: Bool) {
        guard let movieId = movieId else { return }

        delegate?.heartTapped(movieId: movieId, state: state)
    }
}
