import UIKit
import SnapKit

class OverlayImageView: UIView {
    private var title: String?
    private var date: String?
    private var genres: String?
    private var duration: String?
    private var year: String?
    private var backgroundImage: UIImage!

    private var backgroundImageView: UIImageView!
    private var overlay: UIView!
    private var titleLabel: UILabel!
    private var yearLabel: UILabel!
    private var dateLabel: UILabel!
    private var genresLabel: UILabel!
    private var durationLabel: UILabel!
    private var percentageLabel: UILabel!
    private var userScoreLabel: UILabel!
    private var roundImageView: RoundImageBackgroundView!
    private var userScoreStack: LeadingHorizontalStack!
    private var movieTitleStack: LeadingHorizontalStack!
    private var movieDetailsStack: LeadingHorizontalStack!

    init(imageTitle: String, title: String, year: String, date: String, genres: String, duration: String) {
        super.init(frame: .zero)
        backgroundImage = UIImage(named: imageTitle)
        self.year = year
        self.title = title
        self.date = date
        self.genres = genres
        self.duration = duration
        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildViews() {
        createViews()
        addSubviews()
        configureViews()
    }

    private func createViews() {
        backgroundImageView = UIImageView(image: backgroundImage)
        roundImageView = RoundImageBackgroundView(imageTitle: "star")
        overlay = UIView()
        titleLabel = UILabel()
        yearLabel = UILabel()
        dateLabel = UILabel()
        genresLabel = UILabel()
        durationLabel = UILabel()
        percentageLabel = UILabel()
        userScoreLabel = UILabel()
        userScoreStack = LeadingHorizontalStack(percentageLabel, userScoreLabel)
        movieTitleStack = LeadingHorizontalStack(titleLabel, yearLabel)
        movieDetailsStack  = LeadingHorizontalStack(genresLabel, durationLabel)
    }

    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(overlay)

        overlay.addSubview(userScoreStack)
        overlay.addSubview(movieTitleStack)
        overlay.addSubview(dateLabel)
        overlay.addSubview(movieDetailsStack)
        overlay.addSubview(roundImageView)
    }


    private func configureViews() {
        styleViews()
        addConstraints()
     }

    private func styleViews() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white

        dateLabel.text = date
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .white

        genresLabel.text = genres
        genresLabel.font = .systemFont(ofSize: 14)
        genresLabel.textColor = .white

        durationLabel.text = duration
        durationLabel.font = .systemFont(ofSize: 14, weight: .bold)
        durationLabel.textColor = .white

        yearLabel.text = year
        yearLabel.font = .systemFont(ofSize: 24)
        yearLabel.textColor = .white

        percentageLabel.text = "76%"
        percentageLabel.font = .systemFont(ofSize: 14, weight: .bold)
        percentageLabel.textColor = .white

        userScoreLabel.text = "User Score"
        userScoreLabel.font = .systemFont(ofSize: 14, weight: .bold)
        userScoreLabel.textColor = .white

    }

    private func addConstraints() {
        userScoreStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-20)
        }

        movieTitleStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(dateLabel.snp.top).offset(-8)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(movieDetailsStack.snp.top).offset(-2)
        }
        movieDetailsStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(roundImageView.snp.top).offset(-15)
        }

        roundImageView.snp.makeConstraints {
            $0.height.width.equalTo(32)
            $0.bottom.equalToSuperview().offset(-20)
        }

        backgroundImageView.snp.makeConstraints {
            $0.trailing.leading.height.top.equalToSuperview()
        }

        overlay.snp.makeConstraints {
            $0.top.height.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-18)
            $0.leading.equalToSuperview().offset(18)
        }
    }

    override func layoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.colors = [startColor, endColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.2)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        backgroundImageView.layer.insertSublayer(gradient, at: 0)
    }
}
