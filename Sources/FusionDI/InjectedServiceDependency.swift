import Foundation

@propertyWrapper
public struct ServiceDependency<Service: AnyObject> {
    public var wrappedValue: Service
    
    /// This ensures that wrapped value strongly holds dependency.
    /// When dependency user is deallocated, dependency is deallocated as well.
    public init() {
        self.wrappedValue = ServiceResolver.shared.forceResolve(Service.self)
    }
}
