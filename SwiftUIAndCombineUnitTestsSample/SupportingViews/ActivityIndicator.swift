//
//  ActivityIndicator.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/17.
//  Copyright © 2020 Turara. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ indicator: UIActivityIndicatorView, context: Context) {}
}

#if DEBUG
struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
#endif

struct ActivityIndicatorWithRectangle: View {
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(0.2)
            ActivityIndicator()
        }.disabled(true)
    }
}

#if DEBUG
struct ActivityIndicatorWithRectangle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityIndicatorWithRectangle()
                .colorScheme(.dark)
            ActivityIndicatorWithRectangle()
                .colorScheme(.light)
        }
    }
}
#endif
