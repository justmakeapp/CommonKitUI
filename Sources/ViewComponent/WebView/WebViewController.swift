//
//  WebViewController.swift
//  AppSettingsKit
//
//  Created by Long Vu on 12/2/25.
//

#if os(iOS)
    import Combine
    import UIKit
    import WebKit

    public final class WebViewController: UIViewController {
        let url: URL?

        @Published private var error: Error?
        @Published private var isLoading = true

        private lazy var loadingView: UIActivityIndicatorView = {
            let v = UIActivityIndicatorView(style: .medium)
            v.startAnimating()
            return v
        }()

        private lazy var webView: WKWebView = {
            let v = WKWebView()

            v.navigationDelegate = self
            v.isHidden = true

            return v
        }()

        private lazy var errorTextView: UILabel = {
            let v = UILabel()
            v.isHidden = true
            return v
        }()

        private var cancellables: Set<AnyCancellable> = []

        public init(url: URL?) {
            self.url = url

            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override public func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = .systemBackground

            let subViews: [UIView] = [webView, loadingView, errorTextView]
            subViews.forEach { view.addSubview($0) }

            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])

            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

            errorTextView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                errorTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

            setupSubscriptions()

            if let url {
                let request = URLRequest(url: url)
                webView.load(request)
            } else {
                error = NSError(
                    domain: String(describing: WebViewController.self),
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
                )
            }
        }

        private func setupSubscriptions() {
            cancellables = []

            Publishers.CombineLatest($error, $isLoading.removeDuplicates())
                .map { error, isLoading -> ViewState in
                    if isLoading {
                        return .loading
                    } else if let error {
                        return .error(error)
                    } else {
                        return .loaded
                    }
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    self?.setupViews(state)
                }
                .store(in: &cancellables)
        }

        private func setupViews(_ state: ViewState) {
            switch state {
            case .loading:
                loadingView.isHidden = false
                webView.isHidden = true
                errorTextView.isHidden = true
            case .loaded:
                loadingView.isHidden = true
                webView.isHidden = false
                errorTextView.isHidden = true
            case let .error(error):
                errorTextView.text = error.localizedDescription
                loadingView.isHidden = true
                webView.isHidden = true
                errorTextView.isHidden = false
            }
        }

        override public func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
            var didHandleEvent = false
            for press in presses {
                guard let key = press.key else {
                    continue
                }
                if key.charactersIgnoringModifiers == UIKeyCommand.inputEscape {
                    self.dismiss(animated: true)
                    didHandleEvent = true
                }
            }

            if didHandleEvent == false {
                // Didn't handle this key press, so pass the event to the next responder.
                super.pressesBegan(presses, with: event)
            }
        }
    }

    extension WebViewController {
        enum ViewState {
            case loading
            case loaded
            case error(Error)
        }
    }

    extension WebViewController: WKNavigationDelegate {
        public func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            // show indicator
            isLoading = true
        }

        public func webView(
            _: WKWebView,
            decidePolicyFor _: WKNavigationAction,
            decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
        ) {
            // dismiss indicator
            isLoading = false

            // if url is not valid {
            //    decisionHandler(.cancel)
            // }
            decisionHandler(.allow)
        }

        public func webView(_: WKWebView, didFinish _: WKNavigation!) {
            // dismiss indicator
            isLoading = false

            print("didFinish")
        }

        public func webView(
            _: WKWebView,
            didFail _: WKNavigation!,
            withError error: any Error
        ) {
            isLoading = false
            print("didFail: \(error)")
            self.error = error
        }

        public func webView(
            _: WKWebView,
            didFailProvisionalNavigation _: WKNavigation!,
            withError error: any Error
        ) {
            isLoading = false
            print("didFailProvisionalNavigation: \(error)")
            self.error = error
        }
    }
#endif
