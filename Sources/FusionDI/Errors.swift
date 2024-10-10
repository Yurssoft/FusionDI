//
//  File.swift
//  FusionDI
//
//  Created by Yurii Boiko on 10/10/24.
//

import Foundation

public extension ServiceResolver {
    enum ServiceError: Error {
        case absentCreationClosure
        case cannotCastServiceType
    }
}
