//
//  SwiftLogging.swift
//  Ethanol
//
//  Created by Stephane Copin on 1/19/15.
//  Copyright (c) 2014 Fueled Digital Media, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
