//
//  FormsManager.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import Foundation
import Alamofire

protocol FormsProtocol {
    func getCategories(params: Parameters,completion: @escaping (Result<[FormCategory], Error>) -> Void)
}
class FormsManager: FormsProtocol {
    let network = NetworkManager()
    func getCategories(params: Parameters,completion: @escaping (Result<[FormCategory], Error>) -> Void) {
        Task {
            do {
                let response = try await network.request(method: .get, url: Constants.CATEGORIES, headers: [:], params: params, of: FormsModel.self)
                await MainActor.run {
                    completion(.success(response.data?.categories ?? []))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
}
