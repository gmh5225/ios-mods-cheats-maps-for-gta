//
//  Reusable.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//

import UIKit

// Inspired by non-swift3 version of https://github.com/AliSoftware/Reusable

// MARK: Code-based Reusable

/// Protocol for `UITableViewCell` and `UICollectionViewCell` subclasses when they are code-based
public protocol Reusable: AnyObject {
    
  static var reuseIdentifier: String { get }
    
}

public extension Reusable {
    
  static var reuseIdentifier: String {
    String(describing: self)
  }
    
}

// MARK: - NIB-based Reusable

/// Protocol for `UITableViewCell` and `UICollectionViewCell` subclasses when they are NIB-based
public protocol NibReusable: Reusable, NibLoadable {}

public protocol NibLoadable: AnyObject {
    
  static var nib: UINib { get }
    
}

public extension NibLoadable {
    
  static var nib: UINib {
    UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }
    
}

public extension UITableView {
    
  // MARK: UITableViewCell
  
  /** Register a NIB-Based `UITableViewCell` subclass (conforming to `NibReusable`) */
  final func registerReusableCell<T: UITableViewCell>(cellType: T.Type) where T: NibReusable {
    register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
  }
  
  /** Register a Class-Based `UITableViewCell` subclass (conforming to `Reusable`) */
  final func registerReusableCell<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
    register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
  }
  
  /** Returns a reusable `UITableViewCell` object for the class inferred by the return-type */
  final func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath, cellType: T.Type = T.self) -> T
    where T: Reusable {
      guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
        fatalError(
          "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) "
            + "matching type \(cellType.self). "
            + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
            + "and that you registered the cell beforehand"
        )

      }
      
      return cell
  }
  
  // MARK: UITableViewHeaderFooterView
  
  /** Register a NIB-Based `UITableViewHeaderFooterView` subclass (conforming to `NibReusable`) */
  final func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: NibReusable {
    register(viewType.nib, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
  }
  
  /** Register a Class-Based `UITableViewHeaderFooterView` subclass (conforming to `Reusable`) */
  final func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: Reusable {
    register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
  }
  
  /** Returns a reusable `UITableViewHeaderFooterView` object for the class inferred by the return-type */
  final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type = T.self) -> T?
    where T: Reusable {
    guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
      fatalError(
        "Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) "
          + "matching type \(viewType.self). "
          + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
          + "and that you registered the header/footer beforehand"
      )
    }
        
    return view
  }
    
}

