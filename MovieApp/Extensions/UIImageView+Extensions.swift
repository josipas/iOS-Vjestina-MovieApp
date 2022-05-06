import UIKit

extension UIImageView {
    func load(imageUrl: String) {
        let url = URL(string: imageUrl)

        guard let url = url else {
            self.backgroundColor = UIColor(hex: "#EAEAEB")
            return
        }

        if let data = try? Data(contentsOf: url) {
            self.image = UIImage(data: data)
        }
    }
}
