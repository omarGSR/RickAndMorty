//
//  AppContainer.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation
import Nuke

final class AppContainer {
    
    private enum ImageCacheConstants {
        static let diskCacheName = "com.rickandmorty.images"
        static let memoryLimitMb = 80
        static let memoryTTLMinutes: TimeInterval = 15
        static let diskLimitMb = 200
    }
    
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
        
        self.setupImagePipeline()
    }
    
    /// configuration about NUKE SDK images cached
    func setupImagePipeline() {
        
        ImagePipeline.shared = ImagePipeline {
            
            let imageCache = ImageCache()
            imageCache.costLimit = ImageCacheConstants.memoryLimitMb * 1024 * 1024
            imageCache.ttl = ImageCacheConstants.memoryTTLMinutes * 60
            
            let dataCache = try? DataCache(name: ImageCacheConstants.diskCacheName)
            dataCache?.sizeLimit = ImageCacheConstants.diskLimitMb * 1024 * 1024
            
            $0.dataCache = dataCache
            $0.dataCachePolicy = .automatic
            $0.imageCache = imageCache
        }
    }
  
    func setEnvironment(_ environment: EnvironmentServer) {
        self.environment = environment
        apiClient.setEnvironment(environment)
    }
    
    // MARK: - ViewModels for screens
    
    func makeCharacterListVM() -> CharacterListVM {
        CharacterListVM(
            characterRepository: makeCharacterRepository(),
            networkMonitor: networkMonitor)
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
