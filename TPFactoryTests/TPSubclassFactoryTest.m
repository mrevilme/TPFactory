//
//  TPSubclassFactoryTest.m
//  TPFactory
//
//  Created by Emil Palm on 14/04/14.
//  Copyright (c) 2014 Typo.nu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPSubclassFactory.h"
#import "TPSubclassFactoryTestHelpers.h"

@interface TPSubclassFactoryTest : XCTestCase {
    TPTestSubclassFactory *_factory;
}
@end

@implementation TPSubclassFactoryTest

- (void)setUp
{
    [super setUp];
    _factory = [[TPTestSubclassFactory alloc] initWithClass:[TPSubclassTestRoot class]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testNumberOfClassesInFactory {
    XCTAssertTrue([[_factory classes] count] > 0);
}

- (void) testClassForObject {
    Class cls = [_factory classForObject:testingString];
    XCTAssertTrue(cls == [TPSubclassTestClass2 class]);
}

- (void) testPriorityDesc {
    TPTestSubclassFactory *factory = [[TPTestSubclassFactory alloc] initWithClass:[TPSubclassTestRoot class] andOptions:TPFactoryPrioritySortDesc];
    NSArray *items = [factory classes];
    NSArray *order = @[NSClassFromString(@"TPSubclassTestClass3"),NSClassFromString(@"TPSubclassTestClass2"),NSClassFromString(@"TPSubclassTestClass1")];
    XCTAssertTrue([items isEqualToArray:order]);
}

- (void) testPriorityAsc {
    TPTestSubclassFactory *factory = [[TPTestSubclassFactory alloc] initWithClass:[TPSubclassTestRoot class] andOptions:TPFactoryPrioritySortAsc];
    NSArray *items = [factory classes];
    NSArray *order = @[NSClassFromString(@"TPSubclassTestClass1"),NSClassFromString(@"TPSubclassTestClass2"),NSClassFromString(@"TPSubclassTestClass3")];
    XCTAssertTrue([items isEqualToArray:order]);
}

- (void) testSingleton {
    TPTestSubclassFactory *firstVariable = [TPTestSubclassFactory shared];
    TPTestSubclassFactory *secondVariable = [TPTestSubclassFactory shared];
    XCTAssertTrue((firstVariable == secondVariable));
}

@end
