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
    
    @Test func testSubscriptRegisteringDependency() async throws {
        let type = Dependency.self
        let dependency = Dependency()
        ServiceResolver.shared[type] = dependency
        
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        #expect(ServiceResolver.shared.forceResolve(type) === dependency)
    }

    @Test func testSubscriptResolvingDependency() async throws {
        let type = Dependency.self
        let dependency = Dependency()
        ServiceResolver.shared[type] = dependency
        
        let resolvedDependency = ServiceResolver.shared[type]
        #expect(resolvedDependency === dependency)
    }

    @Test func testSubscriptClearDependency() async throws {
        let type = Dependency.self
        ServiceResolver.shared[type] = Dependency()
        
        #expect(ServiceResolver.shared.forceResolve(type) is Dependency)
        
        ServiceResolver.shared[type] = nil
        let resolvedDependency = ServiceResolver.shared.resolveOptional(type)
        
        #expect(resolvedDependency == nil)
    }

    @Test func testSubscriptServiceCacheBehavior() async throws {
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        ServiceResolver.shared.turnOffServiceCache()
        
        let dependency1 = ServiceResolver.shared[type]
        let dependency2 = ServiceResolver.shared[type]
        
        #expect(ObjectIdentifier(dependency1!) != ObjectIdentifier(dependency2!))
        
        ServiceResolver.shared.turnOnServiceCache()
        
        let dependency3 = ServiceResolver.shared[type]
        let dependency4 = ServiceResolver.shared[type]
        
        #expect(ObjectIdentifier(dependency3!) == ObjectIdentifier(dependency4!))
    }

    @Test func testSubscriptWithExistingFunctionality() async throws {
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        
        let resolvedBySubscript = ServiceResolver.shared[type]
        let resolvedByMethod = ServiceResolver.shared.forceResolve(type)
        
        #expect(resolvedBySubscript === resolvedByMethod)
    }
    
//    @Test func testWrongServiceCache() async throws {
//        let type = Dependency.self
//        ServiceResolver.shared.register(type) { DependencyTheOtherType() }
//        do {
//            let dependency = try ServiceResolver.shared.resolve(type)
//            fatalError(String(describing: dependency))
//        } catch let error {
//            if let serviceError = error as? ServiceResolver.ServiceError {
//                #expect(serviceError == ServiceResolver.ServiceError.cannotCastServiceType)
//            } else {
//                fatalError()
//            }
//        }
//    }
}
