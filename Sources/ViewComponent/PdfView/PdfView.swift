//
//  PdfView.swift
//  AppTopicKit
//
//  Created by Long Vu on 5/3/25.
//

import SwiftUI
#if os(iOS)
    import UIKit
#endif
#if os(macOS)
    import AppKit
#endif

#if canImport(PDFKit)
    import PDFKit
#endif

public struct PdfKitView {
    let url: URL

    public init(url: URL) {
        self.url = url
    }
}

#if os(iOS)
    extension PdfKitView: UIViewRepresentable {
        public func makeUIView(context _: UIViewRepresentableContext<PdfKitView>) -> PDFView {
            // Creating a new PDFVIew and adding a document to it
            let pdfView = PDFView()
            pdfView.document = PDFDocument(url: self.url)
            pdfView.autoScales = true
            return pdfView
        }

        public func updateUIView(_: PDFView, context _: UIViewRepresentableContext<PdfKitView>) {
            // we will leave this empty as we don't need to update the PDF
        }
    }
#endif

#if os(macOS)
    extension PdfKitView: NSViewRepresentable {
        public func makeNSView(context _: Context) -> PDFView {
            let pdfView = PDFView()
            pdfView.document = PDFDocument(url: self.url)
            return pdfView
        }

        public func updateNSView(_: PDFView, context _: Context) {}
    }
#endif

// #Preview {
//    PdfView(url: .init(string: "https://pdfobject.com/pdf/sample.pdf")!)
// }
