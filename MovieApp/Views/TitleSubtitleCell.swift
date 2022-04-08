import UIKit
import SnapKit

class TitleSubtitleCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: TitleSubtitleCell.self)

    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        titleLabel = UILabel()
        subtitleLabel = UILabel()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    private func styleViews() {
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private func addConstraints() {
        titleLabel.snp.makeConstraints {
            $0.trailing.leading.top.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
}
