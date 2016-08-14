import Foundation
import Brick
import Sugar

public enum RegistryType: String {
  case Nib = "nib"
  case Regular = "regular"
}

/// A registry that is used internally when resolving kind to the corresponding spot.
public class Registry {

  public enum Item {
    case classType(View.Type)
    case nib(Nib)
  }

  /// A Key-value dictionary of registred types
  var storage = [String : Item]()

  var defaultItem: Item? {
    didSet {
      storage[defaultIdentifier] = defaultItem
    }
  }

  var defaultIdentifier: String {
    return String(defaultItem)
  }

  /**
   A subscripting method for getting a value from storage using a StringConvertible key

   - Returns: An optional Nib
   */
  public subscript(key: StringConvertible) -> Item? {
    get {
      return storage[key.string]
    }
    set(value) {
      storage[key.string] = value
    }
  }

  // MARK: - Template

  private var cache: NSCache = NSCache()

  func purge() {
    cache.removeAllObjects()
  }

  func make(identifier: String) -> (type: RegistryType?, view: View?) {
    guard let item = storage[identifier] else { return (type: nil, view: nil) }

    let registryType: RegistryType?
    var view: View? = nil

    switch item {
    case .classType(let classType):
      registryType = .Regular
      if let view = cache.objectForKey(registryType!.rawValue + identifier) as? View {
        return (type: registryType, view: view)
      }

      view = classType.init()

    case .nib(let nib):
      registryType = .Nib
      if let view = cache.objectForKey(registryType!.rawValue + identifier) as? View {
        return (type: registryType, view: view)
      }
      #if os(OSX)
        var views: NSArray?
        if nib.instantiateWithOwner(nil, topLevelObjects: &views) {
          view = views?.filter({ $0 is NSTableRowView }).first as? View
        }
      #else
      view = nib.instantiateWithOwner(nil, options: nil).first as? View
      #endif
    }

    if let view = view {
      cache.setObject(view, forKey: identifier)
    }

    return (type: registryType, view: view)
  }
}

extension Registry: Then {}
