//
//  ExampleView.swift
//  SwiftUIAlertDemo
//
//  Created by Alessio Boerio on 14/02/25.
//

import SwiftUI
import SwiftUIAlert

struct ExampleView: View {

    @StateObject private var viewModel = ExampleViewModel()
    @Environment(\.alertController) private var alertController // <--- You can access to registered alertController
                                                                //      instance as an Environment variable
                                                                //      all along ExampleRootView navigation children
    var body: some View {
        VStack {
            Button {
                viewModel.onOkButtonTap()
            } label: {
                Text("Show Ok alert")
            }.buttonStyle(.bordered)

            Button {
                viewModel.onDestructableButtonTap()
            } label: {
                Text("Show Desctructable alert")
            }.buttonStyle(.bordered)

            Button {
                viewModel.onConsecutiveAlertsButtonTap()
            } label: {
                Text("Show Consecutive alerts")
            }.buttonStyle(.bordered)

            Button {
                viewModel.onTextFieldButtonTap()
            } label: {
                Text("Show TextField alert")
            }.buttonStyle(.bordered)
        }
        .onChange(of: viewModel.alert) { alert in               // <--- When the view model emits a new alert value
            alertController.alert = alert                       //      just pass it to the alertController to handle its visibility
        }
    }
}
