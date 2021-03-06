//
//  RootView.swift
//  XcodeReleases
//
//  Created by Jeff Lett on 11/23/19.
//  Copyright © 2019 Jeff Lett. All rights reserved.
//

import SwiftUI

struct TabbedRootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
       TabView {
           XcodeReleaseList().tabItem {
               Image(systemName: "list.dash")
               Text("Releases")
           }.environmentObject(appState)
           SettingsView().tabItem {
               Image(systemName: "gear")
               Text("Settings")
           }.environmentObject(appState)
       }
    }
}

struct RootViewPreviews: PreviewProvider {
    static var previews: some View {
        TabbedRootView()
    }
}
