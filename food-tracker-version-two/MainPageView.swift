//
//  MainPageView.swift
//  food-tracker-version-two
//
//  Created by Vilate Jules Knapp on 11/14/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html") {
            let fileURL = URL(fileURLWithPath: filePath)
            uiView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        } else {
            print("HTML file not found")
        }
    }
}


struct MainPageView: View {
    var body: some View {
        VStack {
            WebView()
                .frame(height: 300) // Adjust frame size as needed
        }
    }
}
