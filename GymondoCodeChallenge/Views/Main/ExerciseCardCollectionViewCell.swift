import UIKit
import Kingfisher

class ExerciseCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExerciseCardCollectionViewCell"

    private let exImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "")
        imageView.backgroundColor = .white.withAlphaComponent(0.9)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let exLabelView: UILabel = {
        let labelView = UILabel()
        labelView.text = "House"
        labelView.font = UIFont(name: "Sans-serif", size: 16)
        labelView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        labelView.textColor = .black.withAlphaComponent(0.8)
        labelView.textAlignment = .center
        labelView.backgroundColor = .white

        return labelView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(exLabelView)
        contentView.addSubview(exImageView)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        exLabelView.frame = CGRect(x: 15, y: contentView.frame.size.height-50, width: contentView.frame.size.width-30, height: 50)

        exImageView.frame = CGRect(x: 15, y: 0, width: contentView.frame.size.width-30, height: contentView.frame.size.height-50)
    }

    public func configure(label: String, url: URL?) {
        exLabelView.text = label
        if let url = url {
            exImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        exLabelView.text = nil
        exImageView.image = nil
    }
}
