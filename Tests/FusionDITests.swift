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
    final class DependencyTheOtherType { }
    
    @Test func testRegisteringDependency() async throws {
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        
        let key = String(describing: type)
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured[key] != nil)
    }
    
    @Test func testCreatingDependency() async throws {
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        
        let dependency1 = ServiceResolver.shared.forceResolve(type)
        let objectKey1 = ObjectIdentifier(dependency1)
        
        let key = String(describing: type)
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured[key] != nil)
        ServiceResolver.shared.turnOffServiceCache()
        
        let dependency2 = ServiceResolver.shared.forceResolve(type)
        let objectKey2 = ObjectIdentifier(dependency2)
        
        #expect(objectKey1 != objectKey2)
        
        ServiceResolver.shared.turnOnServiceCache()
        
        let dependency3 = ServiceResolver.shared.forceResolve(type)
        let objectKey3 = ObjectIdentifier(dependency3)
        
        let dependency4 = ServiceResolver.shared.forceResolve(type)
        let objectKey4 = ObjectIdentifier(dependency4)
        
        #expect(objectKey3 == objectKey4)
    }
    
    @Test func testRegisteringResolving() async throws {
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
