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

private func ETHSwiftLog(_ flag: ETHLogFlag, file: String, function: String, line: UInt, message: @autoclosure () -> String) {
	if let logger = ETHInjector.default().protocolInstance(for: ETHLogger.self) as? ETHLogger, logger.logLevel.contains(ETHLogLevel(rawValue: flag.rawValue)) {
		withVaList([message()]) { args in
			logger.log(flag, file: file, function: function, line: Int32(line), format: "%@", arguments: args)
		}
  }
}

public func ETHLogTrace(message: @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
  ETHSwiftLog(.trace, file: file, function: function, line: line, message: message)
}

public func ETHLogDebug(message: @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
  ETHSwiftLog(.debug, file: file, function: function, line: line, message: message)
}

public func ETHLogVerbose(message: @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
  ETHSwiftLog(.verbose, file: file, function: function, line: line, message: message)
}

public func ETHLogInfo(message: @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
  ETHSwiftLog(.info, file: file, function: function, line: line, message: message)
}

public func ETHLogWarning(message: @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
  ETHSwiftLog(.warning, file: file, function: function, line: line, message: message)
}

public func ETHLogError(message: @autoclosure () -> String, file: String = #file, function: String = #function, line: UInt = #line) {
	ETHSwiftLog(.error, file: file, function: function, line: line, message: message)
}

public func ETHLogFatal(message: String, file: String = #file, function: String = #function, line: UInt = #line) -> Never {
  ETHSwiftLog(.fatal, file: file, function: function, line: line, message: message)
	fatalError(message)
}
