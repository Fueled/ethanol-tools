//
//  ETHInjector.m
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

#import <UIKit/UIKit.h>
#import "ETHInjector.h"

@interface ETHInjector ()

@property (nonatomic, strong) NSMutableDictionary * protocolBuilderBlocks;
@property (nonatomic, strong) NSMutableDictionary * classBuilderBlocks;

@end

@implementation ETHInjector

+ (instancetype)defaultInjector {
  static ETHInjector * injector;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    injector = [[self alloc] init];
  });
  return injector;
}

- (id)init {
  self = [super init];
  if(self != nil) {
    self.protocolBuilderBlocks = [[NSMutableDictionary alloc] init];
    self.classBuilderBlocks = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)bindClass:(Class)classToInstanciate toProtocol:(Protocol *)protocolType {
  [self bindBlock:classToInstanciate != nil ? ^id{
    return [[classToInstanciate alloc] init];
  } : nil toProtocol:protocolType];
}

- (void)bindClass:(Class)classToInstanciate toClass:(Class)classType {
  [self bindBlock:classToInstanciate != nil ? ^id{
    return [[classToInstanciate alloc] init];
  } : nil toClass:classType];
}

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocolType {
  [self bindBlock:instance != nil ? ^id{
    return instance;
  } : nil toProtocol:protocolType];
}

- (void)bindInstance:(id)instance toClass:(Class)classType {
  [self bindBlock:instance != nil ? ^id{
    return instance;
  } : nil toClass:classType];
}

- (void)bindBlock:(ETHInjectorBuilderBlock)builderBlock toProtocol:(Protocol *)protocolType {
  if(builderBlock == nil) {
    [self.protocolBuilderBlocks removeObjectForKey:NSStringFromProtocol(protocolType)];
  } else {
    self.protocolBuilderBlocks[NSStringFromProtocol(protocolType)] = [builderBlock copy];
  }
}

- (void)bindBlock:(ETHInjectorBuilderBlock)builderBlock toClass:(Class)classType {
  if(builderBlock == nil) {
    [self.classBuilderBlocks removeObjectForKey:NSStringFromClass(classType)];
  } else {
    self.classBuilderBlocks[NSStringFromClass(classType)] = [builderBlock copy];
  }
}

- (id)instanceForProtocol:(Protocol *)protocolType {
  ETHInjectorBuilderBlock builderBlock = self.protocolBuilderBlocks[NSStringFromProtocol(protocolType)];
  if(builderBlock != nil) {
    return builderBlock();
  }
  
  return nil;
}

- (id)instanceForClass:(Class)classType {
  ETHInjectorBuilderBlock builderBlock = self.classBuilderBlocks[NSStringFromClass(classType)];
  if(builderBlock != nil) {
    return builderBlock() ?: [[classType alloc] init];;
  }

  return [[classType alloc] init];
}

@end
