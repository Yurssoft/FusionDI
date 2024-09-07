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
    
    private var serviceCreation = [ObjectIdentifier: (ServiceResolver) -> AnyObject]()
    private var serviceResolve = [ObjectIdentifier: InjectionService]()
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
    
    public func register<Service: AnyObject>(_ type: Service.Type, closure: @escaping (ServiceResolver) -> Service) {
        accessQueue.sync {
            let key = ObjectIdentifier(type)
            serviceCreation[key] = closure
        }
    }
    
    public func resolve<Service: AnyObject>(_ type: Service.Type) -> Service? {
        let key = ObjectIdentifier(type)
        
        if let cachedService: Service = accessQueue.sync(execute: {
            return isUsingCache ? serviceResolve[key]?.service as? Service : nil
        }) {
            return cachedService
        }
        
        guard let serviceCreationClosure = accessQueue.sync(execute: { serviceCreation[key] }) else {
            return nil
        }
        let service = serviceCreationClosure(self)
        
        accessQueue.sync {
            serviceResolve[key] = InjectionService(service: service)
        }
        
        return service as? Service
    }
}