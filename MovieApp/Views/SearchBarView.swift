import UIKit

protocol SearchInFocusDelegate: AnyObject {
    func inFocus(bool: Bool)
}

class SearchBarView: UIView {
    private var imageView: UIImageView!
    private var textField: UITextField!
    private var xMarkButton: UIButton!
    private var cancelButton: UIButton!
    private var innerHorizontalStack: UIStackView!
    private var outerHorizontalStack: UIStackView!
    private var backgroundView: UIView!

    weak var delegate: SearchInFocusDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)

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
        addActions()
    }

    private func createViews() {
        imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        textField = UITextField()
        textField.delegate = self
        xMarkButton = UIButton()
        cancelButton = UIButton()
        innerHorizontalStack = UIStackView()
        outerHorizontalStack = UIStackView()
        backgroundView = UIView()
    }

    private func addSubviews() {
        innerHorizontalStack.addArrangedSubview(imageView)
        innerHorizontalStack.addArrangedSubview(textField)
        innerHorizontalStack.addArrangedSubview(xMarkButton)

        backgroundView.addSubview(innerHorizontalStack)

        outerHorizontalStack.addArrangedSubview(backgroundView)
        outerHorizontalStack.addArrangedSubview(cancelButton)

        addSubview(outerHorizontalStack)


    }

    private func styleViews() {
        backgroundView.backgroundColor = UIColor(hex: "#EAEAEB")
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10

        innerHorizontalStack.axis = .horizontal
        innerHorizontalStack.spacing = 10

        outerHorizontalStack.axis = .horizontal
        outerHorizontalStack.spacing = 20

        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: "#0B253F")

        textField.textColor = UIColor(hex: "#0B253F")
        textField.tintColor = UIColor(hex: "#0B253F")
        textField.placeholder = "Search"

        xMarkButton.isHidden = true
        xMarkButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xMarkButton.tintColor = UIColor(hex: "#0B253F")
        xMarkButton.imageView?.contentMode = .scaleAspectFit

        cancelButton.isHidden = true
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(hex: "#0B253F"), for: .normal)
    }

    private func addConstraints() {
        outerHorizontalStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(18)
            $0.height.equalTo(45)
        }

        innerHorizontalStack.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }

        xMarkButton.snp.makeConstraints {
            $0.height.width.equalTo(12)
        }
    }

    private func addActions() {
        xMarkButton.addTarget(self, action: #selector(tappedXMarkButton), for: .touchUpInside)

        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }

    @objc private func tappedXMarkButton() {
        textField.text = ""
    }

    @objc private func tappedCancelButton() {
        textField.endEditing(true)
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        xMarkButton.isHidden = false
        cancelButton.isHidden = false
        delegate?.inFocus(bool: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
        xMarkButton.isHidden = true
        cancelButton.isHidden = true
        delegate?.inFocus(bool: false)
    }
}
