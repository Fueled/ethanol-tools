//
//  SwiftLogging.swift
//  Ethanol
//
//  Created by Stephane Copin on 1/19/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

private func ETHSwiftLog(flag: ETHLogFlag, file: String, function: String, line: UInt, format: String, args: CVaListPointer) {
  if let logger = ETHInjector.defaultInjector().instanceForProtocol(ETHLogger) as? ETHLogger where logger.logLevel.contains(ETHLogLevel(rawValue: flag.rawValue)) {
    logger.log(flag, file: file, function: function, line: Int32(line), format: format, arguments: args);
  }
}

public func ETHLogTrace(format: String, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, args: CVarArgType...) {
  ETHSwiftLog(.Trace, file: file, function: function, line: line, format: format, args: getVaList(args));
}

public func ETHLogDebug(format: String, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, args: CVarArgType...) {
  ETHSwiftLog(.Debug, file: file, function: function, line: line, format: format, args: getVaList(args));
}

public func ETHLogVerbose(format: String, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, args: CVarArgType...) {
  ETHSwiftLog(.Verbose, file: file, function: function, line: line, format: format, args: getVaList(args));
}

public func ETHLogInfo(format: String, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, args: CVarArgType...) {
  ETHSwiftLog(.Info, file: file, function: function, line: line, format: format, args: getVaList(args));
}

public func ETHLogWarning(format: String, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, args: CVarArgType...) {
  ETHSwiftLog(.Warning, file: file, function: function, line: line, format: format, args: getVaList(args));
}

public func ETHLogError(format: String, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, args: CVarArgType...) {
  ETHSwiftLog(.Error, file: file, function: function, line: line, format: format, args: getVaList(args));
}

public func ETHLogFatal(format: String, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, args: CVarArgType...) {
  ETHSwiftLog(.Fatal, file: file, function: function, line: line, format: format, args: getVaList(args));
}
