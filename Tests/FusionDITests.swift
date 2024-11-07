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
        ServiceResolver.shared.register(Dependency.self) { Dependency() }
        #expect(ServiceResolver.shared.registeredDependenciesCreationClosured.count == 1)
    }

}
