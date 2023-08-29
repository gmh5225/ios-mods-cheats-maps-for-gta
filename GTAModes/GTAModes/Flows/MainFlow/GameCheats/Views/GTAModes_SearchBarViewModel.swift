
import UIKit
import Combine

public enum SearchBarViewStyle {
    case lightContent
    case darkContent
}

public protocol GTAModes_SearchBarViewModelApplicable {

    var searchBarColor: AnyPublisher<UIColor, Never> { get }
    var cancelButtonText: AnyPublisher<NSAttributedString, Never> { get }
    var searchTextIndicatorColor: AnyPublisher<UIColor, Never> { get }
    var placeholderText: AnyPublisher<NSAttributedString, Never> { get }

    var textColor: AnyPublisher<UIColor, Never> { get }
    var textFont: AnyPublisher<UIFont, Never> { get }
    var autocorrectionType: UITextAutocorrectionType { get }
    var returnKeyType: UIReturnKeyType { get }
    var showsCancelButton: Bool { get }

    var viewStyle: SearchBarViewStyle { get }
    var placeholderString: String { get }

}

public extension GTAModes_SearchBarViewModelApplicable {

    var placeholderString: String {
        "Search here"
    }

    var searchBarColor: AnyPublisher<UIColor, Never> {
        Just(UIColor(named: "checkCellBlue")!).eraseToAnyPublisher()
    }

    var cancelButtonText: AnyPublisher<NSAttributedString, Never> {
        let cancelButtonTitle = "Cancel"
        let cancelButtonFont = UIFont(name: "Inter-Regular", size: 14)!
        let cancelButtonColor = UIColor.white

        let attributes: [NSAttributedString.Key: Any] = [
            .font: cancelButtonFont,
            .foregroundColor: cancelButtonColor
        ]

        let attributedString = NSAttributedString(string: cancelButtonTitle, attributes: attributes)
        return Just(attributedString).eraseToAnyPublisher()
    }

    var searchTextIndicatorColor: AnyPublisher<UIColor, Never> {
        return Just(UIColor.white).eraseToAnyPublisher()
    }

    var placeholderText: AnyPublisher<NSAttributedString, Never> {
        let placeholderFont = UIFont(name: "Inter-Regular", size: 16)!
        let placeholderColor = UIColor.white

        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont,
            .foregroundColor: placeholderColor
        ]

        let attributedString = NSAttributedString(string: placeholderString, attributes: attributes)
        return Just(attributedString).eraseToAnyPublisher()
    }

    var textFont: AnyPublisher<UIFont, Never> {
        Just(UIFont(name: "Inter-Regular", size: 16)!).eraseToAnyPublisher()
    }

    var textColor: AnyPublisher<UIColor, Never> {
        Just(UIColor.white).eraseToAnyPublisher()
    }

    var autocorrectionType: UITextAutocorrectionType {
        .no
    }

    var returnKeyType: UIReturnKeyType {
        .search
    }

    var showsCancelButton: Bool {
        true
    }

    var viewStyle: SearchBarViewStyle {
        .lightContent
    }
}

public class GTAModes_SearchBarViewModel: GTAModes_SearchBarViewModelApplicable {
    
    public init() { }
}

