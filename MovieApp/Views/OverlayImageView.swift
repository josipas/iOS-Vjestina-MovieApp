import UIKit
import SnapKit

//napraviti strrukturu, predati u init

class OverlayImageView: UIView {
    private var title: String?
    private var date: String?
    private var genres: String?
    private var duration: String?
    private var year: String?
    private var backgroundImage: UIImage!

    private var backgroundImageView: UIImageView!
    private var overlay: UIView!
    private var userScoreStack: UIStackView!
    private var percentageLabel: UILabel!
    private var userScoreLabel: UILabel!
    private var titleYearLabel: UILabel!
    private var dateLabel: UILabel!
    private var genresDurationLabel: UILabel!
    private var roundImageView: RoundImageBackgroundView!

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

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        backgroundImageView = UIImageView(image: backgroundImage)
        roundImageView = RoundImageBackgroundView(imageTitle: "star")
        overlay = UIView()
        dateLabel = UILabel()
        percentageLabel = UILabel()
        userScoreLabel = UILabel()
        userScoreStack = UIStackView()
        titleYearLabel = UILabel()
        genresDurationLabel = UILabel()
    }

    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(overlay)

        userScoreStack.addArrangedSubview(percentageLabel)
        userScoreStack.addArrangedSubview(userScoreLabel)

        overlay.addSubview(userScoreStack)
        overlay.addSubview(titleYearLabel)
        overlay.addSubview(dateLabel)
        overlay.addSubview(genresDurationLabel)
        overlay.addSubview(roundImageView)
    }

    private func styleViews() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

        percentageLabel.text = "76%"
        percentageLabel.font = .systemFont(ofSize: 14, weight: .bold)
        percentageLabel.textColor = .white

        userScoreLabel.text = "User Score"
        userScoreLabel.font = .systemFont(ofSize: 14, weight: .bold)
        userScoreLabel.textColor = .white

        userScoreStack.axis = .horizontal
        userScoreStack.alignment = .trailing
        userScoreStack.distribution = .fill
        userScoreStack.spacing = 8

        if
            let title = title,
            let year = year
        {
            titleYearLabel.attributedText = NSMutableAttributedString.getAPartialBoldAttributedString(fromString: "\(title) \(year)",withSubstring: "\(title)", forSize: 24, color: .white)
        }

        dateLabel.text = date
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .white

        if
            let genres = genres,
            let duration = duration
        {
            genresDurationLabel.attributedText = NSMutableAttributedString.getAPartialBoldAttributedString(fromString:"\(genres)  \(duration)",withSubstring: "\(duration)", forSize: 14, color: .white)
        }
    }

    private func addConstraints() {
        userScoreStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(titleYearLabel.snp.top).offset(-20)
        }

        titleYearLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(dateLabel.snp.top).offset(-8)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(genresDurationLabel.snp.top).offset(-2)
        }
        genresDurationLabel.snp.makeConstraints {
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
        super.layoutSubviews()

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
