//
//  ContentView.swift
//  SwiftUIAlertDemo
//
//  Created by Alessio Boerio on 14/02/25.
//

import SwiftUI
import SwiftUIAlert

struct ExampleRootView: View {

    @StateObject private var alertController = AlertController()

    var body: some View {
        NavigationStack {
            ExampleView()
                .navigationTitle("SwiftUIAlert Demo App")
        }
        .registerAlertController(alertController)       // <--- Important: register an AlertController instance on the root
                                                        //      to make it accassible to all the subviews through a dedicated Environment variable
                                                        //
                                                        //      You have to call this method everytime a new navigation starts:
                                                        //      - sheet/popover/fullscreenCover/...
                                                        //      - navigationView/navigationStack/...
    }
}
