import UIKit
import SnapKit

class LeadingHorizontalStack: UIStackView {
    private var views: [UIView] = []

    init(_ views: UIView...) {
        super.init(frame: .zero)
        self.views = views
        buildViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildViews() {
        addSubviews()
        styleViews()
    }

    private func addSubviews() {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }

    private func styleViews() {
        axis = .horizontal
        alignment = .trailing
        distribution = .fill
        spacing = 8
    }
}
