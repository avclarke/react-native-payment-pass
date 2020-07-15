//
//  RNPaymentPass.m
//  RNPaymentPass
//
//  Created by Adam Clarke on 17/07/2020.
//  Copyright © 2020 Adam Clarke. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTBridge.h>
#import <React/RCTUtils.h>

@interface RNPaymentPass : RCTEventEmitter<RCTBridgeModule, PKAddPaymentPassViewControllerDelegate>

@end
