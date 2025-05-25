//
//  UIImage+Ext.swift
//  CommonKitUI
//
//  Created by Long Vu on 23/5/25.
//

#if canImport(UIKit) && canImport(SwiftUI)
    import UIKit

    public extension UIImage {
        // https://stackoverflow.com/questions/53949421/selecting-images-with-uiimagepickercontroller-auto-rotates-them
        func fixedOrientation() -> UIImage {
            if imageOrientation == .up {
                return self
            }

            var transform = CGAffineTransform.identity

            switch imageOrientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: size.width, y: size.height)
                transform = transform.rotated(by: CGFloat.pi)
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: size.width, y: 0)
                transform = transform.rotated(by: CGFloat.pi / 2)
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: size.height)
                transform = transform.rotated(by: CGFloat.pi / -2)
            case .up, .upMirrored:
                break
            @unknown default:
                break
            }

            switch imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .up, .down, .left, .right:
                break
            @unknown default:
                break
            }

            if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace,
               let ctx = CGContext(
                   data: nil,
                   width: Int(size.width),
                   height: Int(size.height),
                   bitsPerComponent: cgImage.bitsPerComponent,
                   bytesPerRow: 0,
                   space: colorSpace,
                   bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
               ) {
                ctx.concatenate(transform)

                switch imageOrientation {
                case .left, .leftMirrored, .right, .rightMirrored:
                    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
                default:
                    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                }
                if let ctxImage: CGImage = ctx.makeImage() {
                    return UIImage(cgImage: ctxImage)
                } else {
                    return self
                }
            } else {
                return self
            }
        }
    }
#endif
