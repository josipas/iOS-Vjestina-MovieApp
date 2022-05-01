import UIKit
import MovieAppData

protocol TappedMovieDelegate: AnyObject {
    func movieTapped()
}

class MoviesFocusTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MoviesFocusTableViewCell.self)

    private var containerView: UIView!
    private var posterView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    weak var delegate: TappedMovieDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        posterView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    func set(movie: MovieModel) {
        posterView.load(imageUrl: movie.imageUrl)
        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addContraints()
        addGesture()
    }

    private func createViews() {
        containerView = UIView()
        posterView = UIImageView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()
    }

    private func addSubviews() {
        containerView.addSubview(posterView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        addSubview(containerView)
    }

    private func styleViews() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#000000")

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor(hex: "#828282")

        posterView.clipsToBounds = true
        posterView.contentMode = .scaleAspectFill

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
    }

    private func addContraints() {
        containerView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(18)
            $0.top.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
        }

        posterView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(140)
        }

        titleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.leading.equalTo(posterView.snp.trailing).offset(15)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(posterView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(20)
        }
    }

    private func addGesture() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(recognizer)
    }

    @objc private func viewTapped() {
        delegate?.movieTapped()
    }

    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.1
    }
}
