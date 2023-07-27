//
//  Resolver+Autoresolve.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import Swinject

extension Resolver {

  public func autoresolve<T>() -> T! {
    resolve(T.self)
  }

  public func autoresolve<T>(name: String) -> T! {
    resolve(T.self, name: name)
  }

  public func autoresolve<T, Arg1>(argument: Arg1) -> T! {
    resolve(T.self, argument: argument)
  }
  
  public func autoresolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T! {
    resolve(T.self, arguments: arg1, arg2)
  }
  
  public func autoresolve<T, Arg1, Arg2, Arg3>(arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T! {
    resolve(T.self, arguments: arg1, arg2, arg3)
  }
  
  public func autoresolve<T, Arg1, Arg2, Arg3, Arg4>(arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> T! {
    resolve(T.self, arguments: arg1, arg2, arg3, arg4)
  }
  
  public func autoresolve<T, Arg1, Arg2, Arg3, Arg4, Arg5 >(arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> T! {
    resolve(T.self, arguments: arg1, arg2, arg3, arg4, arg5)
  }
  // swiftlint:disable:next line_length function_parameter_count
  public func autoresolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6 >(arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> T! {
    resolve(T.self, arguments: arg1, arg2, arg3, arg4, arg5, arg6)
  }

}

