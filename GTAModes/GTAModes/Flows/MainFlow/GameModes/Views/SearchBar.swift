//
//  SearchBar.swift
//  GTAModes
//
//  Created by Максим Педько on 15.08.2023.
//

import UIKit
import Combine

public final class SearchBar: NiblessView {
    
    // MARK: - Public properties
    
    @Published public var text: String = ""
    public let cancelButtonClicked = PassthroughSubject<Void, Never>()
    public let textDidEndEditing = PassthroughSubject<Void, Never>()
    public let textDidBeginEditing = PassthroughSubject<Void, Never>()
    
    // MARK: - Private properties
    
    private lazy var cancelButton = UIButton()
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(origin: .zero, size: CGSize(width: 16.0, height: 16.0))
        )
        imageView.image = UIImage(named: "searchIcon")
        return imageView
    }()
    
    private let clearButton = UIButton()
    private let textField = UITextField()
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: SearchBarViewModelApplicable
    
    // MARK: - Life cycle
    
    public init(viewModel: SearchBarViewModelApplicable) {
        self.viewModel = viewModel
        
        super.init()
        
        initialConfiguration()
        initialBinding()
        setupViewModelBindings()
    }
    
    // MARK: - Public functions
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    public func clear() {
        text.removeAll()
    }
    
    // MARK: - Private functions
    
    private func initialBinding() {
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        $text
            .sink { [weak self] text in
                self?.textField.text = text
                self?.showClearButton(!text.isEmpty)
            }
            .store(in: &cancellables)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        
        textField.addTarget(self, action: #selector(textFieldPrimaryActionTriggered), for: .primaryActionTriggered)
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    private func setupViewModelBindings() {
        // search bar text and placeholder text bindings
        viewModel.textFont
            .sink { [weak self] font in
                self?.textField.font = font
            }
            .store(in: &cancellables)
        
        viewModel.textColor
            .sink { [weak self] color in
                self?.textField.textColor = color
            }
            .store(in: &cancellables)
        
        viewModel.searchTextIndicatorColor
            .sink { [weak self] color in
                self?.textField.tintColor = color
            }
            .store(in: &cancellables)
        
        viewModel.placeholderText
            .sink { [weak self] attributedText in
                self?.textField.attributedPlaceholder = attributedText
            }
            .store(in: &cancellables)
        
        textField.autocorrectionType = viewModel.autocorrectionType
        textField.returnKeyType = viewModel.returnKeyType
        
        if viewModel.showsCancelButton {
            viewModel.cancelButtonText
                .sink { [weak self] attributedTitle in
                    self?.cancelButton.setAttributedTitle(attributedTitle, for: .normal)
                }
                .store(in: &cancellables)
            
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        }
        
        // search bar elements color
        viewModel.searchBarColor
            .sink { [weak self] color in
                self?.textField.layer.borderColor = color.cgColor
                self?.leftImageView.tintColor = color
                self?.clearButton.tintColor = color
            }
            .store(in: &cancellables)
    }
    
    private func showClearButton(_ isShow: Bool) {
        textField.rightViewMode = isShow ? .always : .never
    }
    
    // MARK: - Actions
    
    @objc private func textChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        showClearButton(!text.isEmpty)
    }
    
    // ... (other private functions as in your original code)
    
}

extension SearchBar {
    
    @objc private func clearButtonTapped() {
        textField.text?.removeAll()
        text = ""
    }
    
    @objc private func textFieldDidEndEditing() {
            textDidEndEditing.send()
    }
    
    @objc private func textFieldEditingDidBegin() {
        textDidBeginEditing.send()
    }
    
    @objc private func textFieldPrimaryActionTriggered() {
        textField.endEditing(false)
    }
    
    @objc private func textFieldEditingChanged() {
        if let text = textField.text {
            self.text = text
            showClearButton(!text.isEmpty)
        }
    }
    
    @objc private func cancelButtonTapped() {
        textField.endEditing(false)
        textField.text?.removeAll()
        text = ""
        cancelButtonClicked.send()
    }
    
}

extension SearchBar {
    
    private func initialConfiguration() {
        backgroundColor = .clear
        configureCancelButton()
        
        addSubview(textField)
        textField.layout {
            $0.top.equal(to: topAnchor)
            $0.bottom.equal(to: bottomAnchor)
            $0.leading.equal(to: leadingAnchor)
            
            if viewModel.showsCancelButton {
                $0.trailing.equal(to: cancelButton.leadingAnchor, offsetBy: -16.0)
            } else {
                $0.trailing.equal(to: trailingAnchor)
            }
        }
        
        textField.layer.borderWidth = 1.0
        textField.rightViewMode = .never
        textField.rightView = rightView()
        textField.leftViewMode = .always
        textField.leftView = leftView()
//        textField.inputAccessoryView = KeyboardToolbar(resignResponerView: textField)
        textField.keyboardAppearance = .default
        textField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
    }
    
    private func configureCancelButton() {
        guard viewModel.showsCancelButton else { return }
        
        addSubview(cancelButton)
        let textFieldContentResistancePriority = textField
            .contentCompressionResistancePriority(for: .horizontal)
            .rawValue
        cancelButton.setContentCompressionResistancePriority(
            UILayoutPriority(rawValue: textFieldContentResistancePriority + 1), for: .horizontal
        )
        cancelButton.layout {
            $0.centerY.equal(to: centerYAnchor)
            $0.trailing.equal(to: trailingAnchor)
            $0.height.equal(to: 42.0)
        }
        
        cancelButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func leftView() -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 42.0, height: 42.0)))
        view.addSubview(leftImageView)
        view.layout {
            $0.height.equal(to:42.0)
            $0.width.equal(to:42.0)
        }
        leftImageView.layout {
            $0.height.equal(to:16.0)
            $0.width.equal(to: 16.0)
            $0.centerX.equal(to: view.centerXAnchor)
            $0.centerY.equal(to: view.centerYAnchor)
        }
        
        return view
    }
    
    private func rightView() -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 42.0, height: 42.0)))
        clearButton.setImage(UIImage(systemName: "clear"), for: .normal)
        view.addSubview(clearButton)
        clearButton.layout {
            $0.width.equal(to: 42.0)
            $0.height.equal(to: 42.0)
            $0.top.equal(to: view.topAnchor)
            $0.bottom.equal(to: view.bottomAnchor)
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
        }
        
        return view
    }
    
}
