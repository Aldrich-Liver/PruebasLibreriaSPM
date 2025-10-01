//
//  DemoApi.swift
//  PruebasLibreriaSPM
//
//  Created by ALDRICH GONZALEZ GOMEZ on 01/10/25.
//

import Foundation

struct DemoUser: Decodable {
    let id: Int
    let name: String
    let email: String
}

final class DemoAPIClient {
    private let base = URL(string: "https://jsonplaceholder.typicode.com")!

    func fetchUser(id: Int = 1) async throws -> DemoUser {
        let url = base.appending(path: "/users/\(id)")
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(DemoUser.self, from: data)
    }
}
