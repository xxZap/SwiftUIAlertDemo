//
//  AlertLists.swift
//  SwiftUIAlertDemo
//
//  Created by Alessio Boerio on 14/02/25.
//

import SwiftUI
import SwiftUIAlert

// BONUS:
// Using `SwiftUIAlert` you can easily store all of your used Alerts in dedicated files to keep the code cleaner around the app:
extension BaseAlert {
    // MARK: - ❌
    enum Error {
        static func generic(
            onOk: @escaping (() -> Void),
            onCancel: (() -> Void)? = nil
        ) -> BaseAlert {
            SwiftUIAlert(title: "Error", message: "This is resusable generic error alert", alertButtons: [
                AlertButton("Cancel", role: .cancel) {
                    onCancel?()
                },
                AlertButton("Ok", role: .default) {
                    onOk()
                }
            ])
        }
    }
}

extension BaseAlert {
    // MARK: - ✅
    enum Success {
    }
}

extension BaseAlert {
    // MARK: - ✏️
    enum TextEditor {
    }
}

extension BaseAlert {
    // MARK: - 🚦
    enum Confirmation {
    }
}

// MARK: - Example

// In this way, your view models only have business logic and do not have to create alerts at all.

import Combine

private class SimpleViewModel: ObservableObject {

    // Exposed alert variable
    @Published var alert: BaseAlert?
    // Internal publisher
    private var alertPublisher: CurrentValueSubject<BaseAlert?, Never> = .init(nil)
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.alertPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] alert in
                // avoid using .assignTo() since it creates a strong reference to `self` and may cause memory leak.
                self?.alert = alert
            }
            .store(in: &cancellables)
    }

    func showError() {
        alertPublisher.send(
            BaseAlert.Error.generic(
                onOk: { /* whatever */ },
                onCancel: { /* whatever */ }
            )
        )
    }
}
