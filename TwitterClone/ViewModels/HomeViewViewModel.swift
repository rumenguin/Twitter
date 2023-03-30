//
//  HomeViewViewModel.swift
//  TwitterClone
//
//  Created by RUMEN GUIN on 30/03/23.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    private var subcriptions: Set<AnyCancellable> = []
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subcriptions)

    }
    
}
