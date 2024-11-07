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
        let type = Dependency.self
        ServiceResolver.shared.register(type) { Dependency() }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
        
        let key = String(describing: type)
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured[key] != nil)
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
}
