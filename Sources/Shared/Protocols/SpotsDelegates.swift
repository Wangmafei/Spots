import Brick

#if os(iOS)
  import UIKit
#endif

/// A protocol for composite delegates
public protocol CompositeDelegate: class {
  /// A collection of composite spotable objects, indexed by Spotable object index and Item index.
  var compositeSpots: [Int : [Int : [Spotable]]] { get set }
}

// MARK: - CompositeDelegate extension
extension CompositeDelegate {

  /// Resolve composite container using spot index and item index.
  ///
  /// - parameter spotIndex: The index of the Spotable object.
  /// - parameter itemIndex: The index of the Item that is being displayed on screen.
  ///
  /// - returns: A collection of Spotable objects.
  func resolve(_ spotIndex: Int, itemIndex: Int) -> [Spotable]? {
    guard let compositeContainer = compositeSpots[spotIndex],
      let result = compositeContainer[itemIndex] else {
        return nil
    }

    return result
  }
}

/// A generic delegate for Spots
public protocol SpotsDelegate: class {

  /// A delegate method that is triggered when spots is changed
  ///
  /// - parameter spots: New collection of Spotable objects
  func spotsDidChange(_ spots: [Spotable])

  /// A delegate method that is triggered when ever a cell is tapped by the user
  ///
  /// - parameter spot: An object that conforms to the spotable protocol
  /// - parameter item: The view model that was tapped
  func didSelect(item: Item, in spot: Spotable)
}

// MARK: - SpotsDelegate extension
public extension SpotsDelegate {

  /// Triggered when ever a user taps on an item
  ///
  /// - parameter item: The item struct that the user tapped on.
  /// - parameter spot: The spotable object that the item belongs to.
  func didSelect(item: Item, in spot: Spotable) {}

  /// Invoked when ever the collection of spotable objects changes on the Controller.
  ///
  /// - parameter spots: The collection of new Spotable objects.
  func spotsDidChange(_ spots: [Spotable]) {}
}

/// A refresh delegate for handling reloading of a Spot
public protocol RefreshDelegate: class {

  /// A delegate method for when your spot controller was refreshed using pull to refresh
  ///
  /// - parameter refreshControl: A UIRefreshControl
  /// - parameter completion: A completion closure that should be triggered when the update is completed
#if os(iOS)
  func spotsDidReload(_ refreshControl: UIRefreshControl, completion: Completion)
#endif
}

/// A scroll delegate for handling spotDidReachBeginning and spotDidReachEnd
public protocol ScrollDelegate: class {

  /// A delegate method that is triggered when the scroll view reaches the top
  ///
  /// - parameter completion: A completion closure that gets triggered when the view did reach the beginning of the scroll view.
  func spotDidReachBeginning(_ completion: Completion)

  /// A delegate method that is triggered when the scroll view reaches the end
  ///
  /// - parameter completion: A completion closure that gets triggered when the view did reach the end of the scroll view.
  func spotDidReachEnd(_ completion: Completion)
}

/// A dummy scroll delegate extension to make spotDidReachBeginning optional
public extension ScrollDelegate {

  /// A default implementation for spotDidReachBeginning, it renders the method optional
  ///
  /// - parameter completion: A completion closure
  func spotDidReachBeginning(_ completion: Completion) {
    completion?()
  }
}

public protocol CarouselScrollDelegate: class {

  /// Invoked when ever a user scrolls a CarouselSpot.
  ///
  /// - parameter spot: The spotable object that was scrolled.
  func spotDidScroll(_ spot: Spotable)

  /// - parameter spot: Object that comforms to the Spotable protocol
  /// - parameter item: The last view model in the component
  func spotDidEndScrolling(_ spot: Spotable, item: Item)
}
