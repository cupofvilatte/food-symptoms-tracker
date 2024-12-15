//
//  MainPageView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//

import SwiftUI
import WebKit

// structure that will be compatible to inject HTML within the app
struct WebView: UIViewRepresentable {
    // instance of WKWebView (native WebKit view)
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    // updates WebView with content
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // check that HTML file exists
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html") {
            let fileURL = URL(fileURLWithPath: filePath)
            uiView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        } else {
            // catch error if HTML file cannot be found in app bundle
            print("HTML file not found")
        }
    }
}


struct MainPageView: View {
    var body: some View {
        VStack {
            // WebView to display HTML
            WebView()
                // height of page
                .frame(height: 900) // Adjust frame size as needed
        }
    }
}
