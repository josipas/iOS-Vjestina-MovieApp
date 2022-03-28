import UIKit
import SnapKit

class TitleSubtitleView: UIView {
    private var title: String?
    private var subtitle: String?

    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!

    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        self.title = title
        self.subtitle = subtitle

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildViews() {
        createViews()
        addSubviews()
        configureViews()
    }

    private func createViews() {
        titleLabel = UILabel()
        subtitleLabel = UILabel()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    private func configureViews() {
        styleViews()
        addConstraints()
    }

    private func styleViews() {
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)

        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private func addConstraints() {
        titleLabel.snp.makeConstraints {
            $0.trailing.leading.top.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
