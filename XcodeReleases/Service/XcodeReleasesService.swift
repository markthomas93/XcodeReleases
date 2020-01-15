//
//  XcodeReleasesService.swift
//  XcodeReleases
//
//  Created by Jeff Lett on 7/3/19.
//  Copyright © 2019 Jeff Lett. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import XcodeReleasesKit

class XcodeReleasesService: NSObject, ObservableObject {
    
    @Published var releases: [XcodeRelease] = []
    @Published var isLoading: Bool = false
    @Published var loadingError: XcodeReleasesKit.XcodeReleasesLoader.Error? = nil
    
    let loader: XcodeReleasesLoader
    var cancellable: AnyCancellable? = nil
    
    public init(loader: XcodeReleasesLoader) {
        self.loader = loader
    }
    
    func refresh() {
        guard cancellable == nil else {
            print("Already Laoding Releases.")
            return
        }
        DispatchQueue.main.async { self.isLoading = true }
        cancellable = loader.releases.sink(receiveCompletion: { completion in
            self.cancellable = nil
            switch completion {
            case .failure(let error):
                print("Error Loading Releases: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.loadingError = error
                    self.isLoading = false
                }
            case .finished:
                DispatchQueue.main.async {
                    self.loadingError = nil
                    self.isLoading = false
                }
                break
            }
        }) { releases in
            print("Loaded \(releases.count) Releases.")
            DispatchQueue.main.async { self.releases = releases }
        }
    }
    
}
