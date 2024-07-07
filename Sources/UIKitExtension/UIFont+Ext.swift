//
//  UIFont+Ext.swift
//
//
//  Created by Long Vu on 7/7/24.
//

#if canImport(UIKit)
    import UIKit

    public extension UIFont {
        func withTraits(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
            let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
            return UIFont(descriptor: descriptor!, size: 0) // size 0 means keep the size as it is
        }

        func withWeight(_ weight: UIFont.Weight) -> UIFont {
            var attributes = fontDescriptor.fontAttributes
            var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]

            traits[.weight] = weight

            attributes[.name] = nil
            attributes[.traits] = traits
            attributes[.family] = familyName

            let descriptor = UIFontDescriptor(fontAttributes: attributes)

            return UIFont(descriptor: descriptor, size: pointSize)
        }

        var semibold: UIFont { withWeight(.semibold) }
        var regular: UIFont { withTraits(traits: .init()).withWeight(.regular) }

        var bold: UIFont { withTraits(traits: .traitBold) }

        var italic: UIFont { withTraits(traits: .traitItalic) }

        var boldItalic: UIFont { withTraits(traits: .traitBold, .traitItalic) }

        var isBold: Bool {
            return fontDescriptor.symbolicTraits.contains(.traitBold)
        }

        var isItalic: Bool {
            return fontDescriptor.symbolicTraits.contains(.traitItalic)
        }

        var isBoldItalic: Bool {
            return fontDescriptor.symbolicTraits.contains(.traitBold) && fontDescriptor.symbolicTraits
                .contains(.traitItalic)
        }
    }

#endif
