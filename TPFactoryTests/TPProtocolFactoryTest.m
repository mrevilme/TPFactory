//
//  TPProtocolFactory.m
//  TPFactory
//
//  Created by Emil Palm on 06/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "TPFactory.h"

#import "TPProtocolFactoryTestHelpers.h"

@interface TPProtocolFactoryTest : XCTestCase {
    TPTestProtocolFactory *_factory;
}
@end

@implementation TPProtocolFactoryTest

- (void)setUp {
    _factory = [[TPTestProtocolFactory alloc] initWithProtocol:@protocol(TPTestProtocolFactoryProtocol)];
}

- (void) testFoundClasses {
    XCTAssertTrue([[[_factory classes] allKeys] count] > 0,  @"We should atleast find one class in the factory");
}

- (void) testRetrieveExplictClassWithoutObject {
    Class cls = [_factory classForType:TPFactoryTestTypeOne];
    XCTAssertEqual(cls, [TPProtocolFactoryClass2 class], @"We should get class2");
}

- (void) testRetrieveExplicitClassWithObject {
    Class cls = [_factory classForType:TPFactoryTestTypeOne
                            withObject:testingString];
    XCTAssertEqual(cls, [TPProtocolFactoryClass3 class], @"We should get class3");
}

- (void) testRetrieveExplicitClassWithObjects {
    Class cls = [_factory classForType:TPFactoryTestTypeOne
                            withObjects:testingString, nil];
    XCTAssertEqual(cls, [TPProtocolFactoryClass5 class], @"We should get class5");
}

- (void) testPriorityDesc {
    TPTestProtocolFactory *factory = [[TPTestProtocolFactory alloc] initWithProtocol:@protocol(TPTestProtocolFactoryProtocol) andOptions:TPFactoryPrioritySortDesc];
    NSArray *items = [[factory classes] objectForKey:@"0"];
    NSArray *order = @[NSClassFromString(@"TPProtocolFactoryClass5"),NSClassFromString(@"TPProtocolFactoryClass3"),NSClassFromString(@"TPProtocolFactoryClass2"),NSClassFromString(@"TPProtocolFactoryClass1")];
    XCTAssertTrue([items isEqualToArray:order]);
}

- (void) testPriorityAsc {
    TPTestProtocolFactory *factory = [[TPTestProtocolFactory alloc] initWithProtocol:@protocol(TPTestProtocolFactoryProtocol) andOptions:TPFactoryPrioritySortAsc];
    NSArray *items = [[factory classes] objectForKey:@"0"];
    NSArray *order = @[NSClassFromString(@"TPProtocolFactoryClass1"),NSClassFromString(@"TPProtocolFactoryClass2"),NSClassFromString(@"TPProtocolFactoryClass3"),NSClassFromString(@"TPProtocolFactoryClass5")];
    XCTAssertTrue([items isEqualToArray:order]);
}


- (void) testDifferentFactoryType {
    Class cls = [_factory classForType:TPFactoryTestTypeTwo];
    NSArray *clses = [[_factory classes] objectForKey:@"1"];
    XCTAssertTrue([clses count] == 1);
    XCTAssertTrue((cls == [TPProtocolFactoryClass4 class]));
}

- (void) testSingleton {
    TPTestProtocolFactory *firstVariable = [TPTestProtocolFactory shared];
    TPTestProtocolFactory *secondVariable = [TPTestProtocolFactory shared];
    XCTAssertTrue((firstVariable == secondVariable));
}

- (void) testCallingClassForObject {
    XCTAssertNoThrow([_factory classForObject:nil]);    
}

- (void) testCreateInstanceWithObjects {
    id instance = [_factory createInstanceForType:TPFactoryTestTypeOne withObjects:testingString, nil];
    XCTAssertEqual([instance class], [TPProtocolFactoryClass5 class], @"We should get class5");
    XCTAssertTrue([[instance object] isEqualToArray:@[testingString]], @"we should have a array set to property");
    
}

- (void) testCreateInstanceWithObject {
    id instance = [_factory createInstanceForType: TPFactoryTestTypeOne withObject:testingString];
    XCTAssertEqual([instance class], [TPProtocolFactoryClass3 class], @"We should get class3");
    XCTAssertTrue([[instance object] isEqual:testingString], @"we should have a string set to property");
    
}

- (void) testFilterFrameworkClasses {
    TPTestProtocolFactory *factory = [[TPTestProtocolFactory alloc] initWithProtocol:@protocol(TPTestProtocolFactoryProtocol)
                                                                          andOptions:TPFactoryPrioritySortDesc];
    XCTAssertFalse([[[factory classes] objectForKey:@"0"] containsObject:[UIProtocolFactoryClass5 class]]);
}

- (void) testWithFrameworkClasses {
    XCTAssertTrue([[[_factory classes] objectForKey:@"0"] containsObject:[UIProtocolFactoryClass5 class]]);
}



@end
