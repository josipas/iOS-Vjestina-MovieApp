import UIKit
import SnapKit

class PeopleCollectionView: UIStackView {
    private var data: [(String, String)]?

    init(data: [(String, String)]) {
        super.init(frame: .zero)
        self.data = data

        buildViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildViews() {
        guard let data = data else { return }

        axis = .vertical
        spacing = 26

        let splitData = data.chunked(into: 3)
        splitData.forEach {
            addArrangedSubview(createHorizontalStack(data: $0))
        }
    }

    private func createHorizontalStack(data: [(String, String)]) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fillEqually

        data.forEach {
            let subview = TitleSubtitleView(title: $0.0, subtitle: $0.1)
            subview.snp.makeConstraints {
                $0.height.equalTo(40)
            }
            horizontalStack.addArrangedSubview(subview)
        }

        return horizontalStack
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
