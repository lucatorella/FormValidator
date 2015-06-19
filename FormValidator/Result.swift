//
//  Result.swift
//  FormValidator
//
//  Created by Luca Torella on 19/06/2015.
//  Copyright © 2015 Luca Torella. All rights reserved.
//

import Foundation

enum Result<T, E> {
    case Success(T)
    case Failure(E)
}
