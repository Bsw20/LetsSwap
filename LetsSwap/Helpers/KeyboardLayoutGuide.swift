import UIKit

public final class Keyboard {
    public static let shared = Keyboard()
    public var currentHeight: CGFloat = 0
}

extension UIView {
    public var keyboardLayoutGuide: UILayoutGuide {
        getOrCreateKeyboardLayoutGuide(
            identifier: "KeyboardLayoutGuideUsingSafeArea",
            isUsesSafeArea: true
        )
    }

    public var keyboardLayoutGuideNoSafeArea: UILayoutGuide {
        getOrCreateKeyboardLayoutGuide(
            identifier: "KeyboardLayoutGuide",
            isUsesSafeArea: false
        )
    }

    var isVisibleInSuperview: Bool {
        isVisible(inView: superview)
    }

    private func getOrCreateKeyboardLayoutGuide(
        identifier: String,
        isUsesSafeArea: Bool
    ) -> UILayoutGuide {
        let keyboardLayoutGuide =
            getExistingKeyboardLayoutGuide(identifier: identifier)
                ?? createKeyboardLayoutGuide(
                    identifier: identifier,
                    isUsesSafeArea: isUsesSafeArea
                )
        return keyboardLayoutGuide
    }

    private func getExistingKeyboardLayoutGuide(identifier: String)
        -> UILayoutGuide? {
        layoutGuides.first(where: { $0.identifier == identifier })
    }

    private func createKeyboardLayoutGuide(
        identifier: String,
        isUsesSafeArea: Bool
    ) -> UILayoutGuide {
        let keyboardLayoutGuide = KeyboardLayoutGuide()
        keyboardLayoutGuide.isUsesSafeArea = isUsesSafeArea
        keyboardLayoutGuide.identifier = identifier
        addLayoutGuide(keyboardLayoutGuide)
        keyboardLayoutGuide.setupConstraints()
        return keyboardLayoutGuide
    }

    private func isVisible(inView: UIView?) -> Bool {
        guard let inView = inView else { return true }
        let viewFrame = inView.convert(bounds, from: self)
        if viewFrame.intersects(inView.bounds) {
            return isVisible(inView: inView.superview)
        }
        return false
    }
}

open class KeyboardLayoutGuide: UILayoutGuide {
    public var isUsesSafeArea = true {
        didSet {
            updateButtomConstraint()
        }
    }

    private var bottomConstraint: NSLayoutConstraint?

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(
        notificationCenter: NotificationCenter = NotificationCenter
            .default
    ) {
        super.init()
        notificationCenter.addObserver(
            self,
            selector: #selector(onKeyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    // Установка констрэйнтов
    func setupConstraints() {
        guard let view = owningView else { return }
        // swiftlint:disable all
        NSLayoutConstraint.activate(
            [
                heightAnchor
                    .constraint(equalToConstant: Keyboard.shared.currentHeight),
                leftAnchor.constraint(equalTo: view.leftAnchor),
                rightAnchor.constraint(equalTo: view.rightAnchor)
            ]
        )
        // swiftlint:enable all
        updateButtomConstraint()
    }

    // Обновление значения нижнего констрэйнта
    private func updateButtomConstraint() {
        if let bottomConstraint = bottomConstraint {
            bottomConstraint.isActive = false
        }

        guard let view = owningView else { return }

        let viewBottomAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *), isUsesSafeArea {
            viewBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            viewBottomAnchor = view.bottomAnchor
        }

        bottomConstraint = bottomAnchor.constraint(equalTo: viewBottomAnchor)
        bottomConstraint?.isActive = true
    }

    // При изменении фрейма клавиатуры
    @objc private func onKeyboardWillChangeFrame(_ notification: Notification) {
        guard
            var height = notification.keyboardHeight,
            let duration = notification.animationDuration
        else { return }

        if
            #available(iOS 11.0, *),
            isUsesSafeArea,
            height > 0,
            let bottom = owningView?.safeAreaInsets.bottom {
            height -= bottom
        }

        heightConstraint?.constant = height

        if duration > 0.0 {
            animateOwningViewIfNeeded()
        }

        Keyboard.shared.currentHeight = height
    }

    // Анимировать изменение owningView если это необходимо
    private func animateOwningViewIfNeeded() {
        guard let owningView = owningView else { return }
        if owningView.isVisibleInSuperview {
            owningView.layoutIfNeeded()
        } else {
            UIView.performWithoutAnimation {
                owningView.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Helpers
extension UILayoutGuide {
    var heightConstraint: NSLayoutConstraint? {
        owningView?.constraints.first {
            $0.firstItem as? UILayoutGuide == self && $0
                .firstAttribute == .height
        }
    }
}

extension Notification {
    public var keyboardHeight: CGFloat? {
        guard let keyboardFrame =
            userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return nil
        }
        // Weirdly enough UIKeyboardFrameEndUserInfoKey doesn't have the same behaviour
        // in ios 10 or iOS 11 so we can't rely on v.cgRectValue.width
//        let screenHeight = UIApplication.shared.keyWindow?.bounds.height ?? UIScreen.main.bounds.height
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight - keyboardFrame.cgRectValue.minY
    }

    public var animationDuration: CGFloat? {
        userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat
    }
}
