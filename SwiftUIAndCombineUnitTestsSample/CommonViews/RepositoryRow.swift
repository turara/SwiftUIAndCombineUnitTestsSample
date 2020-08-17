//
//  RepositoryRow.swift
//  SwiftUIAndCombineUnitTestsSample
//
//  Created by Turara on 2020/08/17.
//  Copyright © 2020 Turara. All rights reserved.
//

import SwiftUI

struct RepositoryRow: View {
    let repository: GitHubRepo
    let isFavorite: Bool
    let tapFavoriteButton: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            self.avatar
            self.description
            Spacer()
            self.favoriteButton
        }
    }
    
}

private extension RepositoryRow {
    var avatar: some View {
        // TODO: Show avatar image
        Text("Avatar")
    }
    
    var description: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.repository.fullName)
                .font(.headline)
            
            Text(self.repository.description)
                .font(.caption)
                .foregroundColor(Color.gray)
            HStack(alignment: .center) {
                Text(self.repository.language ?? "")
                    .font(.subheadline)
                    .frame(width: self.languageWidth, alignment: .leading)
                Image(systemName: "star.fill")
                    .scaleEffect(self.isStarsCountOver999 ? 1.0 : 0.8)
                    .foregroundColor(Color(red: 106.0 / 255, green: 115.0 / 255, blue: 125.0 / 255))
                    .offset(x: 4, y: 0)
                Text("\(self.repository.stargazersCount)")
            }
        }.padding()
    }
    
    var favoriteButton: some View {
        Button(action: tapFavoriteButton) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(Color.pink)
                .scaleEffect(isFavorite ? 1.5 : 1)
                .padding(.trailing, 8)
                .frame(alignment: .center)
                .animation(.interactiveSpring())
        }.buttonStyle(BorderlessButtonStyle())
    }
    
    private var languageWidth: CGFloat {
        UIScreen.main.bounds.width < 375 ? 72 : 100
    }
    
    private var isStarsCountOver999: Bool {
        self.repository.stargazersCount > 999
    }
    
}

struct RepositoryRow_Previews: PreviewProvider {
    static var previews: some View {
        let repositories = makeStubRepositories()
        return Group {
            RepositoryRow(repository: repositories[0], isFavorite: true) { }
            RepositoryRow(repository: repositories[1], isFavorite: false) { }
        }
        .previewLayout(.fixed(width: 345, height: 180))
    }
    
    private static func makeStubRepositories() -> [GitHubRepo] {
        (0...1).map { id in
            GitHubRepo(
                id: id,
                description: "Description of Project \(id): This is a long description for this project.",
                fullName: "Project \(id): This is a long name for a project name",
                language: id == 0 ? "Long Language name" : nil,
                stargazersCount: id == 0 ? 20000 : 100,
                owner: GitHubUser(
                    id: id,
                    avatarURL: URL(string: "https://example.com")!
                ),
                url: URL(string: "https://example.com")!
            )
        }
    }
    
}
