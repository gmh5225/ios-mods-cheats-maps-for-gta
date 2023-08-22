//
//  Autolayout.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//

import UIKit

public protocol GTA_LayoutAnchor {
    
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

public protocol GTA_LayoutDimension: GTA_LayoutAnchor {
    
    func constraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    
    func constraint(equalTo anchor: Self, multiplier: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: GTA_LayoutAnchor {}
extension NSLayoutDimension: GTA_LayoutDimension {}

public class GTA_LayoutProperty<Anchor: GTA_LayoutAnchor> {
    
    fileprivate let anchor: Anchor
    fileprivate let kind: Kind
    
    public enum Kind { case leading, trailing, top, bottom, centerX, centerY, width, height }
    
    public init(anchor: Anchor, kind: Kind) {
        self.anchor = anchor
        self.kind = kind
    }
}

public class GTA_LayoutAttribute<Dimension: GTA_LayoutDimension>: GTA_LayoutProperty<Dimension> {
    
    fileprivate let dimension: Dimension
    
    public init(dimension: Dimension, kind: Kind) {
        self.dimension = dimension
        
        super.init(anchor: dimension, kind: kind)
    }
}

public final class GTA_LayoutProxy {
    
    public lazy var leading = gta_property(with: view.leadingAnchor, kind: .leading)
    public lazy var trailing = gta_property(with: view.trailingAnchor, kind: .trailing)
    public lazy var top = gta_property(with: view.topAnchor, kind: .top)
    public lazy var bottom = gta_property(with: view.bottomAnchor, kind: .bottom)
    public lazy var centerX = gta_property(with: view.centerXAnchor, kind: .centerX)
    public lazy var centerY = gta_property(with: view.centerYAnchor, kind: .centerY)
    public lazy var width = gta_attribute(with: view.widthAnchor, kind: .width)
    public lazy var height = gta_attribute(with: view.heightAnchor, kind: .height)
    
    private let view: UIView
    
    fileprivate init(view: UIView) {
        self.view = view
    }
    
    private func gta_property<A: GTA_LayoutAnchor>(with anchor: A, kind: GTA_LayoutProperty<A>.Kind) -> GTA_LayoutProperty<A> {
        return GTA_LayoutProperty(anchor: anchor, kind: kind)
    }
    
    private func gta_attribute<D: GTA_LayoutDimension>(with dimension: D, kind: GTA_LayoutProperty<D>.Kind) -> GTA_LayoutAttribute<D> {
        return GTA_LayoutAttribute(dimension: dimension, kind: kind)
    }
}

public extension GTA_LayoutAttribute {
    
    @discardableResult
    func equal(to constant: CGFloat, priority: UILayoutPriority? = nil, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = dimension.constraint(equalToConstant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func greaterThanOrEqual(to constant: CGFloat, priority: UILayoutPriority? = nil,
                            isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func lessThanOrEqual(to constant: CGFloat, priority: UILayoutPriority? = nil,
                         isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func equal(to otherDimension: Dimension, multiplier: CGFloat,
               priority: UILayoutPriority? = nil, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = dimension.constraint(equalTo: otherDimension, multiplier: multiplier)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = isActive
        return constraint
    }
}

public extension GTA_LayoutProperty {
    
    @discardableResult
    func equal(
        to otherAnchor: Anchor,
        offsetBy constant: CGFloat = 0,
        priority: UILayoutPriority? = nil,
        multiplier: CGFloat? = nil,
        isActive: Bool = true) -> NSLayoutConstraint {
        var constraint = anchor.constraint(equalTo: otherAnchor, constant: constant)
        
        if let multiplier = multiplier {
            constraint = constraint.constraintWithMultiplier(multiplier)
        }
        
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func greaterThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0,
                            priority: UILayoutPriority? = nil, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func lessThanOrEqual(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0,
                         priority: UILayoutPriority? = nil, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = isActive
        return constraint
    }
}

public extension UIView {
    
    func gta_layout(using closure: (GTA_LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(GTA_LayoutProxy(view: self))
    }
    
    func gta_layout(in superview: UIView, with insets: UIEdgeInsets = .zero) {
        superview.addSubview(self)
        pinEdges(to: superview, with: insets)
    }
    
    func pinEdges(to view: UIView, with insets: UIEdgeInsets = .zero) {
        gta_layout { proxy in
            proxy.bottom == view.bottomAnchor - insets.bottom
            proxy.top == view.topAnchor + insets.top
            proxy.leading == view.leadingAnchor + insets.left
            proxy.trailing == view.trailingAnchor - insets.right
        }
    }
}

// swiftlint:disable large_tuple

public func + <A: GTA_LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}

public func - <A: GTA_LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

@discardableResult
public func == <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

@discardableResult
public func == <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: ((A, CGFloat), UILayoutPriority)) -> NSLayoutConstraint {
    return lhs.equal(to: rhs.0.0, offsetBy: rhs.0.1, priority: rhs.1)
}

@discardableResult
public func == <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: (A, UILayoutPriority)) -> NSLayoutConstraint {
    return lhs.equal(to: rhs.0, priority: rhs.1)
}

@discardableResult
public func == <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.equal(to: rhs)
}

@discardableResult
public func >= <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

@discardableResult
public func >= <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.greaterThanOrEqual(to: rhs)
}

@discardableResult
public func <= <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

@discardableResult
public func <= <A: GTA_LayoutAnchor>(lhs: GTA_LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.lessThanOrEqual(to: rhs)
}

@discardableResult
public func <= <D: GTA_LayoutDimension>(lhs: GTA_LayoutAttribute<D>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.lessThanOrEqual(to: rhs)
}

@discardableResult
public func == <D: GTA_LayoutDimension>(lhs: GTA_LayoutAttribute<D>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.equal(to: rhs)
}

@discardableResult
public func == <D: GTA_LayoutDimension>(lhs: GTA_LayoutAttribute<D>, rhs: (CGFloat, UILayoutPriority)) -> NSLayoutConstraint {
    return lhs.equal(to: rhs.0, priority: rhs.1)
}

@discardableResult
public func == <D: GTA_LayoutDimension>(lhs: GTA_LayoutAttribute<D>, rhs: GTA_LayoutAttribute<D>) -> NSLayoutConstraint {
    return lhs.equal(to: rhs.dimension)
}

@discardableResult
public func *= <D: GTA_LayoutDimension>(
  lhs: GTA_LayoutAttribute<D>,
  rhs: (GTA_LayoutAttribute<D>, CGFloat, UILayoutPriority)
) -> NSLayoutConstraint {
    return lhs.equal(to: rhs.0.dimension, multiplier: rhs.1, priority: rhs.2)
}

@discardableResult
public func >= <D: GTA_LayoutDimension>(lhs: GTA_LayoutAttribute<D>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.greaterThanOrEqual(to: rhs)
}

// swiftlint:enable large_tuple

public extension UIView {
    
    private struct AssociatedKeys {
        static var layout = "layout"
    }
    
    var layout: Layout {
        get {
            var layout: Layout!
            let lookup = objc_getAssociatedObject(self, &AssociatedKeys.layout) as? Layout
            if let lookup = lookup {
                layout = lookup
            } else {
                let newLayout = Layout()
                self.layout = newLayout
                layout = newLayout
            }
            return layout
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.layout, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

public final class Layout: NSObject {
    
    public weak var top: NSLayoutConstraint?
    public weak var bottom: NSLayoutConstraint?
    public weak var leading: NSLayoutConstraint?
    public weak var trailing: NSLayoutConstraint?
    public weak var centerX: NSLayoutConstraint?
    public weak var centerY: NSLayoutConstraint?
    public weak var width: NSLayoutConstraint?
    public weak var height: NSLayoutConstraint?
    
    fileprivate func update<A: GTA_LayoutAnchor>(constraint: NSLayoutConstraint, kind: GTA_LayoutProperty<A>.Kind) {
        switch kind {
        case .top: top = constraint
        case .bottom: bottom = constraint
        case .leading: leading = constraint
        case .trailing: trailing = constraint
        case .centerX: centerX = constraint
        case .centerY: centerY = constraint
        case .width: width = constraint
        case .height: height = constraint
        }
    }
}

public extension NSLayoutConstraint {
    
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: self.firstItem as Any,
            attribute: self.firstAttribute,
            relatedBy: self.relation,
            toItem: self.secondItem,
            attribute: self.secondAttribute,
            multiplier: multiplier,
            constant: self.constant
        )
    }
}

extension UIView {
  
  @discardableResult
  public func withCornerRadius(
    _ radius: CGFloat = 12.0,
    clipsToBounds: Bool = true,
    corners: CACornerMask = [.layerMaxXMaxYCorner,
                             .layerMaxXMinYCorner,
                             .layerMinXMaxYCorner,
                             .layerMinXMinYCorner]
  ) -> Self {
    layer.cornerRadius = radius
    layer.maskedCorners = corners
    layer.masksToBounds = false
    self.clipsToBounds = clipsToBounds
    
    return self
  }
    
    @discardableResult
    public func withBorder(width: CGFloat = 1.0, color: UIColor = (UIColor(named: "checkCellBlue")?.withAlphaComponent(0.4))!) -> Self {
      layer.borderWidth = width
      layer.borderColor = color.cgColor
      
      return self
    }
  
}
