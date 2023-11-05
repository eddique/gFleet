//
//  Backrgound.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import Foundation
import SwiftUI

extension BackgroundStyle {
    static let translucent = VisualEffect()
    static let transparent = TransparentWindow()
}
struct VisualEffect: NSViewRepresentable {
   func makeNSView(context: Self.Context) -> NSView { return NSVisualEffectView() }
   func updateNSView(_ nsView: NSView, context: Context) { }
}
class TransparentWindowView: NSView {
  override func viewDidMoveToWindow() {
    window?.backgroundColor = .clear
    super.viewDidMoveToWindow()
  }
}
struct TransparentWindow: NSViewRepresentable {
   func makeNSView(context: Self.Context) -> NSView { return TransparentWindowView() }
   func updateNSView(_ nsView: NSView, context: Context) { }
}
