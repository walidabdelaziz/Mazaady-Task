//
//  FormsManager.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import Foundation
import Alamofire

protocol FormsProtocol {
    func getCategories(completion: @escaping (Result<[FormCategory], Error>) -> Void)
    func getProperties(categoryId: Int,completion: @escaping (Result<[FormCategory], Error>) -> Void)
}
class FormsService: FormsProtocol {
    let network = NetworkManager()
    func getCategories(completion: @escaping (Result<[FormCategory], Error>) -> Void) {
        Task {
            do {
                let response = try await network.request(method: .get, url: Constants.CATEGORIES, headers: [:], params: [:], of: FormsModel.self)
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
    func getProperties(categoryId: Int,completion: @escaping (Result<[FormCategory], Error>) -> Void) {
        Task {
            do {
                let response = try await network.request(method: .get, url: "\(Constants.PROPERTIES)\(categoryId)", headers: [:], params: [:], of: PropertiesModel.self)
                await MainActor.run {
                    completion(.success(response.data ?? []))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
}
