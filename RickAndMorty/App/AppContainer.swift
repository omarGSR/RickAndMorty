//
//  AppContainer.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

final class AppContainer {
    
    static let shared = AppContainer()
    
    private static var initialEnvironment: EnvironmentServer {
        #if DEBUG
        .dev
        #else
        .prod
        #endif
    }
    
    private(set) var environment: EnvironmentServer
    
    let networkMonitor: NWPathNetworkMonitor
    let apiClient: AlamofireAPIClient
    let persistenceDataBase: PersistenceDataSource
    
    private init(environment: EnvironmentServer = AppContainer.initialEnvironment,
                 networkMonitor: NWPathNetworkMonitor = .shared) {
        
        let swiftDataManager: SwiftDataManager = .shared
        
        self.environment = environment
        self.networkMonitor = networkMonitor
        
        self.apiClient = AlamofireAPIClient(environment: environment,
                                            monitor: networkMonitor)
        
        self.persistenceDataBase = SwiftDataSource(context: swiftDataManager.context)
    }
    
    func setEnvironment(_ environment: EnvironmentServer) {
        self.environment = environment
        apiClient.setEnvironment(environment)
    }
    
    // MARK: - Make repositories / Datasources 
    
    func makeCharacterRepository() -> CharacterRepository {
        RickAndMortyCharacterRepository(remoteDataSource: makeCharacterRemoteDataSource(),
                                        localDataSource: persistenceDataBase)
    }
    
    func makeCharacterRemoteDataSource() -> CharacterRemoteDataSource {
        RickAndMortyCharacterRemoteDataSource(apiClient: apiClient)
    }
}

