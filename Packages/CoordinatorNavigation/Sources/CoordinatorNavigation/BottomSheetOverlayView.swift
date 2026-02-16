//
//  BottomSheetOverlayView.swift
//  CoordinatorNavigation
//
//  Custom bottom sheet: view that slides up from the bottom. No system detents. Reusable.
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct BottomSheetOverlayView<Content: View>: View {
    let isPresented: Bool
    let onDismiss: () -> Void
    @ViewBuilder let content: () -> Content

    public init(
        isPresented: Bool,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture(perform: onDismiss)
                    .transition(.opacity)

                content()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
}

public struct BottomSheetContainerModifier<SheetContent: View>: ViewModifier {
    let isPresented: Bool
    let onDismiss: () -> Void
    @ViewBuilder let sheetContent: () -> SheetContent

    public init(
        isPresented: Bool,
        onDismiss: @escaping () -> Void,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) {
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.sheetContent = sheetContent
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            BottomSheetOverlayView(isPresented: isPresented, onDismiss: onDismiss) {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.secondary.opacity(0.5))
                        .frame(width: 36, height: 5)
                        .padding(.top, 8)
                        .padding(.bottom, 4)

                    sheetContent()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(sheetBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 20, y: -4)
            }
        }
    }

    private var sheetBackground: some View {
        #if os(iOS)
        Color(uiColor: .systemBackground)
        #elseif os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color.primary.opacity(0.05)
        #endif
    }
}

extension View {
    public func bottomSheetOverlay<Content: View>(
        isPresented: Bool,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheetContainerModifier(isPresented: isPresented, onDismiss: onDismiss, sheetContent: content))
    }
}
