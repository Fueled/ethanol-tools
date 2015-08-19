//
//  InjectorTests.m
//  EthanolTools
//
//  Created by Stephane Copin on 8/19/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ETHInjector.h"

@interface TestBlockClass : NSObject

@property (nonatomic, assign) NSInteger testValue;

@end

@implementation TestBlockClass

@end

@interface InjectorTests : XCTestCase

@property (nonatomic, strong) ETHInjector * injector;

@end

@implementation InjectorTests

- (void)setUp {
  self.injector = [[ETHInjector alloc] init];
}

- (void)testSharedInjector {
  XCTAssertTrue([[ETHInjector defaultInjector] isKindOfClass:[ETHInjector class]]);
}

- (void)testInjectorBindClassToClass {
  Class sourceClass = [NSObject class];
  Class targetClass = [InjectorTests class];
  [self.injector bindClass:targetClass toClass:sourceClass];
  
  XCTAssertEqualObjects([[self.injector instanceForClass:sourceClass] class], targetClass);
  
  [self.injector bindClass:nil toClass:sourceClass];
  
  XCTAssertEqualObjects([[self.injector instanceForClass:sourceClass] class], sourceClass);
}

- (void)testInjectorBindClassToProtocol {
  Protocol * sourceProtocol = @protocol(NSObject);
  Class targetClass = [InjectorTests class];
  [self.injector bindClass:targetClass toProtocol:sourceProtocol];
  
  XCTAssertEqualObjects([[self.injector instanceForProtocol:sourceProtocol] class], targetClass);
  
  [self.injector bindClass:nil toProtocol:sourceProtocol];
  
  XCTAssertEqualObjects([self.injector instanceForProtocol:sourceProtocol], nil);
}

- (void)testInjectorBindInstanceToClass {
  Class sourceClass = [NSObject class];
  id targetInstance = [[NSObject alloc] init];
  [self.injector bindInstance:targetInstance toClass:sourceClass];
  
  XCTAssertEqual([self.injector instanceForClass:sourceClass], targetInstance);
  
  [self.injector bindInstance:nil toClass:sourceClass];
  
  XCTAssertEqualObjects([[self.injector instanceForClass:sourceClass] class], sourceClass);
}

- (void)testInjectorBindInstanceToProtocol {
  Protocol * sourceProtocol = @protocol(NSObject);
  id targetInstance = [[NSObject alloc] init];
  [self.injector bindInstance:targetInstance toProtocol:sourceProtocol];
  
  XCTAssertEqual([self.injector instanceForProtocol:sourceProtocol], targetInstance);
  
  [self.injector bindInstance:nil toProtocol:sourceProtocol];
  
  XCTAssertEqualObjects([self.injector instanceForProtocol:sourceProtocol], nil);
}

- (void)testInjectorBindBlockToClass {
  Class sourceClass = [NSObject class];
  [self.injector bindBlock:^id{
    TestBlockClass * test = [[TestBlockClass alloc] init];
    test.testValue = 123;
    return test;
  } toClass:sourceClass];
  
  XCTAssertEqual([[self.injector instanceForClass:sourceClass] testValue], 123);
  
  [self.injector bindBlock:nil toClass:sourceClass];
  
  XCTAssertNotEqualObjects([[self.injector instanceForClass:sourceClass] class], [TestBlockClass class]);
}

- (void)testInjectorBindBlockToProtocol {
  Protocol * sourceProtocol = @protocol(NSObject);
  [self.injector bindBlock:^id{
    TestBlockClass * test = [[TestBlockClass alloc] init];
    test.testValue = 321;
    return test;
  } toProtocol:sourceProtocol];
  
  XCTAssertEqual([[self.injector instanceForProtocol:sourceProtocol] testValue], 321);
  
  [self.injector bindBlock:nil toProtocol:sourceProtocol];
  
  XCTAssertNotEqualObjects([[self.injector instanceForProtocol:sourceProtocol] class], [TestBlockClass class]);
}

@end
