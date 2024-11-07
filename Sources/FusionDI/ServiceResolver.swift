import Foundation

extension Dictionary where Key == String {
    subscript<Service>(type: Service.Type) -> Value? {
        get {
            return self[String(describing: type)]
        }
        set {
            self[String(describing: type)] = newValue
        }
    }
}

open class ValueDependencyWrapper<Service> {
    public init(service: Service) {
        self.service = service
    }
    
    open var service: Service
}

final class InjectionService {
    init(service: AnyObject?) {
        self.service = service
    }
    
    weak var service: AnyObject?
}

public final class ServiceResolver {
    public static let shared = ServiceResolver()
    private var isUsingCache = true
    
    private var serviceCreation = [String: (ServiceResolver) -> AnyObject]()
    private var serviceResolve = [String: InjectionService]()
    private let accessQueue = DispatchQueue(label: ServiceResolver.typeName(ServiceResolver.self))
    
    private init() { }
    
    public var registeredDependenciesCreationClosured: [String: (ServiceResolver) -> AnyObject] { accessQueue.sync { serviceCreation } }
    
    public func clearCreationClosures() {
        accessQueue.sync {
            serviceCreation.removeAll()
        }
    }
    
    public func clearServiceCache() {
        accessQueue.sync {
            serviceResolve.removeAll()
        }
    }
    
    public func removeCreationClosure<Service: AnyObject>(_ type: Service.Type) {
        accessQueue.sync {
            serviceCreation[Self.typeName(type)] = nil
        }
    }
    
    public func removeServiceObject<Service: AnyObject>(_ type: Service.Type) {
        accessQueue.sync {
            serviceResolve[Self.typeName(type)] = nil
        }
    }
    
    public func removeService<Service: AnyObject>(_ type: Service.Type) {
        removeCreationClosure(type)
        removeServiceObject(type)
    }
    
    public func clearAllServiceCaches() {
        clearCreationClosures()
        clearServiceCache()
    }
    
    public func turnOffServiceCache() {
        accessQueue.sync {
            isUsingCache = false
        }
    }
    
    public func turnOnServiceCache() {
        accessQueue.sync {
            isUsingCache = true
        }
    }
    
    public func register<Service: AnyObject>(_ type: Service.Type, closure: @escaping () -> Service) {
        register(type) { _ in closure() }
    }
    
    public func register<Service: AnyObject>(_ type: Service.Type, closure: @escaping (ServiceResolver) -> Service) {
        accessQueue.sync {
            serviceCreation[Self.typeName(type)] = closure
        }
    }
    
    public func forceResolve<Service: AnyObject>(_ type: Service.Type) -> Service {
        try! resolve(type)
    }
    
    public func resolveOptional<Service: AnyObject>(_ type: Service.Type) -> Service? {
        try? resolve(type)
    }
    
    public func resolve<Service: AnyObject>(_ type: Service.Type) throws -> Service {
        if let cachedService: Service = accessQueue.sync(execute: {
            return isUsingCache ? serviceResolve[Self.typeName(type)]?.service as? Service : nil
        }) {
            return cachedService
        }
        
        guard let serviceCreationClosure = accessQueue.sync(execute: { serviceCreation[Self.typeName(type)] }) else {
            throw ServiceError.absentCreationClosure
        }
        let service = serviceCreationClosure(self)
        
        accessQueue.sync {
            serviceResolve[Self.typeName(type)] = InjectionService(service: service)
        }
        if let createdService = service as? Service {
            return createdService
        } else {
            /*
             Technically, this could not happen as it would not compile
             Error: Cannot convert value of type 'DependencyTheOtherType' to closure result type 'Dependency'
             ServiceResolver.shared.register(Dependency.self) { DependencyTheOtherType() }
             */
            throw ServiceError.cannotCastServiceType
        }
    }
    
    private static func typeName<T>(_ type: T.Type) -> String { String(describing: type) }
    
    public subscript<Service: AnyObject>(type: Service.Type) -> Service? {
        get {
            return resolveOptional(type)
        }
        set {
            accessQueue.sync {
                if let service = newValue {
                    serviceResolve[type] = InjectionService(service: service)
                    serviceCreation[type] = { _ in service }
                } else {
                    serviceResolve[type] = nil
                    serviceCreation[type] = nil
                }
            }
        }
    }
}
