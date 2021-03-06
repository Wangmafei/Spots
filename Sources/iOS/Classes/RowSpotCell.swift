import UIKit
import Brick

/// A default cell for the RowSpot
public class RowSpotCell: UICollectionViewCell, SpotConfigurable {

  /// The preferred view size for the view
  public var preferredViewSize = CGSize(width: 88, height: 44)
  /// A weak referenced Item struct
  public var item: Item?

  /// A UILabel that uses the Item's title as its text
  public var label: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.autoresizingMask = [.flexibleWidth]

    return label
  }()

  /// A UIImageView that uses the Item's image property for its image
  public lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.autoresizingMask = [.flexibleWidth]

    return imageView
  }()

  /// Initializes and returns a newly allocated view object with the specified frame rectangle.
  ///
  /// - parameter frame: The frame rectangle for the view, measured in points.
  ///
  /// - returns: An initialized view object.
  public override init(frame: CGRect) {
    super.init(frame: frame)

    label.frame.size.width = contentView.frame.size.width

    [imageView, label].forEach { contentView.addSubview($0) }
  }

  /// Init with coder
  ///
  /// - parameter aDecoder: An NSCoder
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Configure cell with Item struct
  ///
  /// - parameter item: The Item struct that is used for configuring the view.
  public func configure(_ item: inout Item) {
    imageView.image = UIImage(named: item.image)
    imageView.frame = contentView.frame
    label.text = item.title
    label.sizeToFit()
  }
}
