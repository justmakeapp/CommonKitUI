//
//  EdgeInsets+Extension.swift
//
//
//  Created by Long Vu on 14/12/2022.
//

import SwiftUI

public extension EdgeInsets {
    init(_ value: CGFloat) {
        self.init(
            top: value,
            leading: value,
            bottom: value,
            trailing: value
        )
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(
            top: vertical,
            leading: horizontal,
            bottom: vertical,
            trailing: horizontal
        )
    }
}

extension EdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(leading)
        hasher.combine(bottom)
        hasher.combine(trailing)
    }
}

extension EdgeInsets: Codable {
    enum CodingKeys: String, CodingKey {
        case top, leading, bottom, trailing
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let top = try container.decode(CGFloat.self, forKey: .top)
        let leading = try container.decode(CGFloat.self, forKey: .leading)
        let bottom = try container.decode(CGFloat.self, forKey: .bottom)
        let trailing = try container.decode(CGFloat.self, forKey: .trailing)
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(top, forKey: .top)
        try container.encode(leading, forKey: .leading)
        try container.encode(bottom, forKey: .bottom)
        try container.encode(trailing, forKey: .trailing)
    }
}
