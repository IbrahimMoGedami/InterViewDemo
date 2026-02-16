//
//  AlertModifier.swift
//  CoordinatorNavigation
//
//  Presents an alert from AlertConfig. Dismiss via closure so it works with any coordinator.
//

import SwiftUI

public struct CoordinatorAlertModifier: ViewModifier {
    @Binding var config: AlertConfig?
    let onDismiss: () -> Void

    public init(config: Binding<AlertConfig?>, onDismiss: @escaping () -> Void) {
        _config = config
        self.onDismiss = onDismiss
    }

    public func body(content: Content) -> some View {
        content
            .alert(config?.title ?? "", isPresented: Binding(
                get: { config != nil },
                set: { if !$0 { onDismiss() } }
            )) {
                if let c = config {
                    if let secondary = c.secondaryTitle {
                        Button(secondary, role: .cancel) {
                            c.secondaryAction?()
                            onDismiss()
                        }
                    }
                    Button(c.primaryTitle) {
                        c.primaryAction?()
                        onDismiss()
                    }
                }
            } message: {
                if let message = config?.message {
                    Text(message)
                }
            }
    }
}

extension View {
    public func coordinatorAlert(config: Binding<AlertConfig?>, onDismiss: @escaping () -> Void) -> some View {
        modifier(CoordinatorAlertModifier(config: config, onDismiss: onDismiss))
    }
}
