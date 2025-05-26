//
//  WebView.swift
//  AppSettingsKit
//
//  Created by Long Vu on 9/1/25.
//

import SwiftUI
#if canImport(WebKit)
    import WebKit

    public struct WebView: View {
        @State private var isLoading = true
        @State private var error: Error? = nil
        let url: URL?

        public init(url: URL?) {
            self.url = url
        }

        public var body: some View {
            ZStack {
                if let error {
                    Text(error.localizedDescription)
                        .foregroundColor(.pink)
                } else if let url {
                    PlatformWebView(
                        url: url,
                        isLoading: $isLoading,
                        error: $error
                    )
                    .edgesIgnoringSafeArea(.all)
                    if isLoading {
                        SwiftUI.ProgressView()
                    }
                } else {
                    Text("Sorry, we could not load this url.")
                }
            }
            .onAppear {
//            WKWebsiteDataStore.default().removeData(
//                ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache],
//                modifiedSince: Date(timeIntervalSince1970: 0),
//                completionHandler: {}
//            )
            }
        }
    }

    @MainActor
    private struct PlatformWebView {
        var url: URL
        @Binding var isLoading: Bool
        @Binding var error: Error?

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func makeWebView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
            webView.load(request)
            return webView
        }

        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: PlatformWebView

            init(_ webView: PlatformWebView) {
                self.parent = webView
            }

            func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
                parent.isLoading = true
            }

            func webView(_: WKWebView, didFinish _: WKNavigation!) {
                parent.isLoading = false
            }

            func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
                print("loading error: \(error)")
                parent.isLoading = false
                parent.error = error
            }
        }
    }
#endif

#if os(macOS)
    extension PlatformWebView: NSViewRepresentable {
        func makeNSView(context: Context) -> WKWebView {
            makeWebView(context: context)
        }

        func updateNSView(_: WKWebView, context _: Context) {}
    }
#endif

#if os(iOS)
    extension PlatformWebView: UIViewRepresentable {
        func makeUIView(context: Context) -> WKWebView {
            makeWebView(context: context)
        }

        func updateUIView(_: WKWebView, context _: Context) {}
    }
#endif
