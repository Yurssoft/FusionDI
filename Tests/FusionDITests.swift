//
//  FusionDITests.swift
//  FusionDI
//
//  Created by Yurii Boiko on 11/7/24.
//

import Testing
import FusionDI

struct Test {
    final class Dependency { }
    
    @Test func testRegisteringDependency() async throws {
        ServiceResolver.shared.clearAllServiceCaches()
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        
        let key = String(describing: type)
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured[key] != nil)
    }
    
    @Test func testRegisteringResolving() async throws {
        ServiceResolver.shared.clearAllServiceCaches()
        let type = Dependency.self
        let object = Dependency()
        ServiceResolver.shared.register(type) { object }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        
        let key = String(describing: type)
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured[key] != nil)
        
        let dependency = ServiceResolver.shared.forceResolve(type)
        #expect(dependency === object)
    }
    
    @Test func testRegisteringResolvingWithClearCache() async throws {
        ServiceResolver.shared.clearAllServiceCaches()
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        
        let key = String(describing: type)
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured[key] != nil)
        
        let dependency1 = ServiceResolver.shared.forceResolve(type)
        let key1 = ObjectIdentifier(dependency1)
        
        ServiceResolver.shared.clearServiceCache()
        
        let dependency2 = ServiceResolver.shared.forceResolve(type)
        let key2 = ObjectIdentifier(dependency2)
        
        #expect(key1 != key2)
    }
    
    @Test func testClearCache() async throws {
        ServiceResolver.shared.clearAllServiceCaches()
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        
        let key = String(describing: type)
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured[key] != nil)
        
        let dependency1 = ServiceResolver.shared.forceResolve(type)
        let key1 = ObjectIdentifier(dependency1)
        
        ServiceResolver.shared.clearServiceCache()
        
        let dependency2 = ServiceResolver.shared.forceResolve(type)
        let key2 = ObjectIdentifier(dependency2)
        
        #expect(key1 != key2)
        ServiceResolver.shared.clearAllServiceCaches()
        
        do {
            let dependency3 = try ServiceResolver.shared.resolve(type)
            fatalError(String(describing: dependency3))
        } catch let error {
            if let serviceError = error as? ServiceResolver.ServiceError {
                #expect(serviceError == ServiceResolver.ServiceError.absentCreationClosure)
            } else {
                fatalError()
            }
        }
        
    }
}
