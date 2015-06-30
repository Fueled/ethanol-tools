//
//  ETHInjector.h
//  Ethanol
//
//  Created by Stephane Copin on 4/24/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

typedef id (^ ETHInjectorBuilderBlock)(void);

@interface ETHInjector : NSObject

+ (instancetype)defaultInjector;

- (void)bindClass:(Class)classToInstanciate toProtocol:(Protocol *)protocolType;
- (void)bindClass:(Class)classToInstanciate toClass:(Class)classType;

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocolType;
- (void)bindInstance:(id)instance toClass:(Class)classType;

- (void)bindBlock:(ETHInjectorBuilderBlock)builderBlock toProtocol:(Protocol *)protocolType;
- (void)bindBlock:(ETHInjectorBuilderBlock)builderBlock toClass:(Class)classType;

- (id)instanceForProtocol:(Protocol *)protocolType;
- (id)instanceForClass:(Class)classType;

@end
