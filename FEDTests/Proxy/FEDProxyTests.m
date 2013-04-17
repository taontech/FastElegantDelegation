//
//  FEDProxyTests.m
//  FEDelegation
//
//  Created by Yan Rabovik on 17.04.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "FEDProxyTests.h"

@interface FEDProxyTests ()
@property (nonatomic,strong) FEDExampleDelegate *delegate;
@property (nonatomic,strong) FEDProxy *proxy;
@property (nonatomic,strong) FEDExampleDelegator *delegator;
@end

@implementation FEDProxyTests

#pragma mark - Setup
-(void)setUp{
    [super setUp];
    _delegate = [FEDExampleDelegate new];
    _proxy = [FEDProxy proxyWithDelegate:_delegate
                                protocol:@protocol(FEDExampleProtocol)];
    _delegator = [FEDExampleDelegator new];
    _delegator.delegate = _delegate;
}

-(void)tearDown{
    [super tearDown];
}

#pragma mark - Signatures
-(void)runMethodSignatureTestForSelector:(SEL)selector{
    NSMethodSignature *delegateSignature =
        [self.delegate methodSignatureForSelector:selector];
    NSMethodSignature *proxySignature = [self.proxy methodSignatureForSelector:selector];
    STAssertNotNil(delegateSignature,
                   @"Selector: %@",
                   NSStringFromSelector(selector));
    STAssertNotNil(proxySignature,
                   @"Selector: %@",
                   NSStringFromSelector(selector));
    STAssertEqualObjects(delegateSignature,
                         proxySignature,
                         @"Selector: %@",
                         NSStringFromSelector(selector));
}

-(void)testMethodSignatures{
    // required
    [self runMethodSignatureTestForSelector:@selector(requiredMethod)];
    // optional
    [self runMethodSignatureTestForSelector:@selector(methodWithArgument:)];
    // method in adopted protocol
    [self runMethodSignatureTestForSelector:@selector(self)];
}

-(void)testSignatureForNonExistentSelector{
    SEL selector = @selector(selector_doesNot_exists);
    STAssertThrows([self.proxy methodSignatureForSelector:selector],@"");
}

-(void)testMethodsInProtocol{
    RTProtocol *protocol = [RTProtocol
                            protocolWithObjCProtocol:@protocol(FEDExampleProtocol)];
    NSArray *methods = [[protocol methodsRequired:YES instance:YES incorporated:YES]
                        arrayByAddingObjectsFromArray:
                        [protocol methodsRequired:NO instance:YES incorporated:YES]];
    for (RTMethod *method in methods) {
        NSLog(@"%@",method.selectorName);
    }
}

#pragma mark - Delegation

@end
