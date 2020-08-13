#if canImport(UIKit)
import UIKit

extension UITableView {
    
    public var sections: [Section] {
        get {
            return source?.data.sections ?? []
        }
        set {
            let data = Data(sections: newValue)
            if let source = source {
                source.setData(data, tableView: self, animated: window != nil && UIView.inheritedAnimationDuration > 0)
            } else {
                self.source = Source(tableView: self, data: data)
            }
        }
    }
    
    public var sectionIndexTitles: [String]? {
        get {
            return storage[\.sectionIndexTitles]
        }
        set {
            // MARK: Performance equality check
            guard sectionIndexTitles != nil || newValue != nil else { return }
            if let sectionIndexTitles = sectionIndexTitles, let newValue = newValue, sectionIndexTitles == newValue { return }
            storage[\.sectionIndexTitles] = newValue
            reloadSectionIndexTitles()
        }
    }
    
    public func indexPath(for key: AnyHashable) -> IndexPath? {
        return source?.data.rowsByKey[key]
    }
    
    var source: Source? {
        get {
            return storage[\.source]
        }
        set {
            storage[\.source] = newValue
        }
    }
    
    var reuseIdentifiers: Set<String> {
        get {
            return storage[\.reuseIdentifiers, default: []]
        }
        set {
            storage[\.reuseIdentifiers] = newValue
        }
    }
    
}
#endif
