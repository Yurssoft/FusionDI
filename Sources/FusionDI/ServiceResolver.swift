import Foundation

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
    private let accessQueue = DispatchQueue(label: String(describing: ServiceResolver.self))
    
    private init() { }
    
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
            let key = String(describing: type)
            serviceCreation[key] = closure
        }
    }
    
    public func forceResolve<Service: AnyObject>(_ type: Service.Type) -> Service {
        try! resolve(type)
    }
    
    public func resolve<Service: AnyObject>(_ type: Service.Type) -> Service? {
        try? resolve(type)
    }
    
    public func resolve<Service: AnyObject>(_ type: Service.Type) throws -> Service {
        let key = String(describing: type)
        if let cachedService: Service = accessQueue.sync(execute: {
            return isUsingCache ? serviceResolve[key]?.service as? Service : nil
        }) {
            return cachedService
        }
        
        guard let serviceCreationClosure = accessQueue.sync(execute: { serviceCreation[key] }) else {
            throw ServiceError.absentCreationClosure
        }
        let service = serviceCreationClosure(self)
        
        accessQueue.sync {
            serviceResolve[key] = InjectionService(service: service)
        }
        if let createdService = service as? Service {
            return service as! Service
        } else {
            throw ServiceError.cannotCastServiceType
        }
    }
}
