//
//  ExampleViewModel.swift
//  SwiftUIAlertDemo
//
//  Created by Alessio Boerio on 14/02/25.
//

import Combine
import Foundation
import SwiftUIAlert

class ExampleViewModel: ObservableObject {

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

    func onOkButtonTap() {
        alertPublisher.send(SwiftUIAlert(title: "Title", message: "This is classic cancel/ok alert", alertButtons: [
            AlertButton("Cancel", role: .cancel) {
                // Whatever the viewmodel wants to do here...
            },
            AlertButton("Ok", role: .default) {
                // Whatever the viewmodel wants to do here...
            }
        ]))
    }

    func onDestructableButtonTap() {
        alertPublisher.send(SwiftUIAlert(title: "Title", message: "This is a destructable alert", alertButtons: [
            AlertButton("Cancel", role: .cancel) {
                // Whatever the viewmodel wants to do here...
            },
            AlertButton("Ok", role: .destructive) {
                // Whatever the viewmodel wants to do here...
            }
        ]))
    }

    func onConsecutiveAlertsButtonTap() {
        alertPublisher.send(SwiftUIAlert(title: "Title", message: "This alert shows another alert", alertButtons: [
            AlertButton("Show another alert") { [weak self] in
                // TODO:
                // one limitation of SwiftUI is that there's no completion on system alert show/hide action
                // and if you try to present an alert while another one is dismissing, unpredictable things can happen.
                // for the moment, a programmatic delay is needed.
                //
                // While for iOS18+ it seems fine to don't use any delay,
                // on iOS17 and previous, the delay seems needed for unknown reasons.
                // 200 milliseconds are safe. Shorter delays may be useless
                Task {
                    try? await Task.sleep(for: .milliseconds(200))
                    self?.alertPublisher.send(SwiftUIAlert(title: "Callback", message: "You see another alert", alertButtons: [
                        AlertButton("Ok") {
                            // Whatever the viewmodel wants to do here...
                        }
                    ]))
                }
            }
        ]))
    }

    func onTextFieldButtonTap() {
        alertPublisher.send(SwiftUITextFieldAlert(
            title: "Title",
            message: "This is an alert that contains a textfield",
            alertButtons: [
                AlertButton("Cancel", role: .cancel) {
                    // Whatever the viewmodel wants to do here...
                },
                AlertButton("Ok", role: .default) {
                    // Whatever the viewmodel wants to do here...
                    // the onSubmit will be automatically called
                }
            ],
            placeholder: "Placeholder text...",
            onSubmit: { confirmed, text, submitType in
                print("the user confirmed: \(confirmed)")
                print("the content of the textfield: \"\(text)\"")
                print("the user submit type: \(submitType)")
            }
        ))
    }
}
