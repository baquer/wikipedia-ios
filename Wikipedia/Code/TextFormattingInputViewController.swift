class TextFormattingInputView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 300)
    }
}

class TextFormattingInputViewController: UIInputViewController {
    private let storyboardName = "TextFormatting"
    @IBOutlet weak var containerView: UIView!
    weak var delegate: TextFormattingDelegate?

    enum InputViewType {
        case textFormatting
        case textStyle
    }

    private lazy var textStyleFormattingTableViewController: TextStyleFormattingTableViewController = {
        let viewController = TextStyleFormattingTableViewController.wmf_viewControllerFromStoryboardNamed(storyboardName)
        viewController.delegate = delegate
        return viewController
    }()

    private lazy var textFormattingTableViewController: TextFormattingTableViewController = {
        let viewController = TextFormattingTableViewController.wmf_viewControllerFromStoryboardNamed(storyboardName)
        viewController.delegate = delegate
        return viewController
    }()

    var inputViewType = InputViewType.textFormatting {
        didSet {
            guard viewIfLoaded != nil else {
                return
            }
            guard inputViewType != oldValue else {
                return
            }
            let viewController: UIViewController & Themeable
            switch inputViewType {
            case .textFormatting:
                viewController = textFormattingTableViewController
            case .textStyle:
                viewController = textStyleFormattingTableViewController
            }
            viewController.apply(theme: theme)
            embeddedNavigationController.viewControllers = [viewController]
        }
    }

    private var theme = Theme.standard

    private lazy var embeddedNavigationController: UINavigationController = {
        var rootViewController: (UIViewController & Themeable)

        if inputViewType == .textFormatting {
            rootViewController = textFormattingTableViewController
        } else {
            rootViewController = textStyleFormattingTableViewController
        }

        rootViewController.apply(theme: theme)

        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.isTranslucent = false

        return navigationController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        embedNavigationController()
        addTopShadow()
        apply(theme: theme)
    }

    private func embedNavigationController() {
        addChild(embeddedNavigationController)
        embeddedNavigationController.view.frame = containerView.frame
        assert(containerView.subviews.isEmpty)
        containerView.addSubview(embeddedNavigationController.view)
        embeddedNavigationController.didMove(toParent: self)
    }

    private func addTopShadow() {
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1.0
    }
    
}

extension TextFormattingInputViewController: Themeable {
    func apply(theme: Theme) {
        guard viewIfLoaded != nil else {
            self.theme = theme
            return
        }
        view.backgroundColor = theme.colors.paperBackground
        view.layer.shadowColor = theme.colors.shadow.cgColor
    }
}
