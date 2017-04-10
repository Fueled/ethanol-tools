//
//  ETHInjector.h
//  Ethanol
//
//  Created by Stephane Copin on 4/24/14.
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

typedef id (^ ETHInjectorBuilderBlock)(void);

@interface ETHInjector : NSObject

+ (instancetype)defaultInjector;

- (void)protocolBindClass:(Class)classToInstantiate toProtocol:(Protocol *)protocolType;
- (void)classBindClass:(Class)classToInstantiate toClass:(Class)classType;

- (void)protocolBindInstance:(id)instance toProtocol:(Protocol *)protocolType;
- (void)classBindInstance:(id)instance toClass:(Class)classType;

- (void)protocolBindBlock:(ETHInjectorBuilderBlock)builderBlock toProtocol:(Protocol *)protocolType;
- (void)classBindBlock:(ETHInjectorBuilderBlock)builderBlock toClass:(Class)classType;

- (id)protocolInstanceForProtocol:(Protocol *)protocolType;
- (id)classInstanceForClass:(Class)classType;

@end
