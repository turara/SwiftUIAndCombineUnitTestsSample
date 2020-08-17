//
//  SearchBar.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/17.
//  Copyright © 2020 Turara. All rights reserved.
//

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {
    private var action: (String) -> Void
    private var placeholder: String?
    
    init(placeholder: String? = nil, action: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self.action = action
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.showsCancelButton = true
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: Context) {}
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar
        
        init(_ searchBar: SearchBar) {
            parent = searchBar
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.endEditing(false)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let query = searchBar.text {
                parent.action(query)
                searchBar.endEditing(false)
            }
        }
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholder: "Input search query", action: { _ in })
    }
}
#endif
