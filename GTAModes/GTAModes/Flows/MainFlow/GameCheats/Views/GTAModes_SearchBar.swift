
import UIKit
import Combine

public final class GTAModes_SearchBar: GTAModes_NiblessView {
    
    // MARK: - Public properties
    
    @Published public var text: String = ""
    public let cancelButtonClicked = PassthroughSubject<Void, Never>()
    public let textDidEndEditing = PassthroughSubject<Void, Never>()
    public let textDidBeginEditing = PassthroughSubject<Void, Never>()
    
    // MARK: - Private properties
    
    private lazy var cancelButton = UIButton()
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(origin: .zero, size: CGSize(width: 20.0, height: 20.0))
        )
        imageView.image = UIImage(named: "searchIcon")
        return imageView
    }()
    
    private let clearButton = UIButton()
    private let textField = UITextField()
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: GTAModes_SearchBarViewModelApplicable
    
    // MARK: - Life cycle
    
    public init(viewModel: GTAModes_SearchBarViewModelApplicable) {
        self.viewModel = viewModel
        
        super.init()
        
        gta_initialConfiguration()
        gta_initialBinding()
        gta_setupViewModelBindings()
    }
    
    // MARK: - Public functions
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    public func gta_clear() {
        text.removeAll()
    }
    
    // MARK: - Private functions
    
    private func gta_initialBinding() {
        clearButton.addTarget(self, action: #selector(gta_clearButtonTapped), for: .touchUpInside)
        $text
            .sink { [weak self] text in
                self?.textField.text = text
                self?.gta_showClearButton(!text.isEmpty)
            }
            .store(in: &cancellables)
        textField.addTarget(self, action: #selector(gta_textFieldDidEndEditing), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(gta_textFieldEditingDidBegin), for: .editingDidBegin)
        
        textField.addTarget(self, action: #selector(gta_textFieldPrimaryActionTriggered), for: .primaryActionTriggered)
        textField.addTarget(self, action: #selector(gta_textFieldEditingChanged), for: .editingChanged)
    }
    
    private func gta_setupViewModelBindings() {
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
            
            cancelButton.addTarget(self, action: #selector(gta_cancelButtonTapped), for: .touchUpInside)
            
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
    
    private func gta_showClearButton(_ isShow: Bool) {
        textField.rightViewMode = isShow ? .always : .never
    }
    
    // MARK: - Actions
    
    @objc private func textChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        gta_showClearButton(!text.isEmpty)
    }
    
}

extension GTAModes_SearchBar {
    
    @objc private func gta_clearButtonTapped() {
        textField.text?.removeAll()
        text = ""
    }
    
    @objc private func gta_textFieldDidEndEditing() {
        //
        textDidEndEditing.send()
        //
    }
    
    @objc private func gta_textFieldEditingDidBegin() {
        //
        textDidBeginEditing.send()
        //
    }
    
    @objc private func gta_textFieldPrimaryActionTriggered() {
        //
        textField.endEditing(false)
        //
    }
    
    @objc private func gta_textFieldEditingChanged() {
        if let text = textField.text {
            self.text = text
            gta_showClearButton(!text.isEmpty)
        }
    }
    
    @objc private func gta_cancelButtonTapped() {
        textField.endEditing(false)
        textField.text?.removeAll()
        text = ""
        cancelButtonClicked.send()
    }
    
}

extension GTAModes_SearchBar {
    
    private func gta_initialConfiguration() {
        backgroundColor = .clear
        gta_configureCancelButton()
        
        addSubview(textField)
        textField.gta_layout {
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
        textField.rightView = gta_rightView()
        textField.leftViewMode = .always
        textField.leftView = gta_leftView()
        textField.keyboardAppearance = .default
        textField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
    }
    
    private func gta_configureCancelButton() {
        guard viewModel.showsCancelButton else { return }
        
        addSubview(cancelButton)
        let textFieldContentResistancePriority = textField
            .contentCompressionResistancePriority(for: .horizontal)
            .rawValue
        cancelButton.setContentCompressionResistancePriority(
            UILayoutPriority(rawValue: textFieldContentResistancePriority + 1), for: .horizontal
        )
        cancelButton.gta_layout {
            $0.centerY.equal(to: centerYAnchor)
            $0.trailing.equal(to: trailingAnchor)
            $0.height.equal(to: 42.0)
        }
        
        cancelButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func gta_leftView() -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 42.0, height: 42.0)))
        view.addSubview(leftImageView)
        view.gta_layout {
            $0.height.equal(to:42.0)
            $0.width.equal(to:42.0)
        }
        leftImageView.gta_layout {
            $0.height.equal(to:20.0)
            $0.width.equal(to: 20.0)
            $0.centerX.equal(to: view.centerXAnchor)
            $0.centerY.equal(to: view.centerYAnchor)
        }
        
        return view
    }
    
    private func gta_rightView() -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 42.0, height: 42.0)))
        clearButton.setImage(UIImage(systemName: "clear"), for: .normal)
        view.addSubview(clearButton)
        clearButton.gta_layout {
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
