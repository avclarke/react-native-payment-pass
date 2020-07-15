//
//  RNPaymentPass.m
//  RNPaymentPass
//
//  Created by Adam Clarke on 17/07/2020.
//  Copyright © 2020 Adam Clarke. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "RNPaymentPass.h"

@implementation RNPaymentPass

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(canAddPaymentPass:(RCTPromiseResolveBlock)resolve
                  rejector:(RCTPromiseRejectBlock)reject) {
  resolve(@([PKAddPassesViewController canAddPasses]));
}

- (NSDictionary *)constantsToExport {
  PKAddPassButton *addPassButton = [[PKAddPassButton alloc] initWithAddPassButtonStyle:PKAddPassButtonStyleBlack];
  [addPassButton layoutIfNeeded];

  return @{
           @"AddPassButtonStyle": @{
               @"black": @(PKAddPassButtonStyleBlack),
               @"blackOutline": @(PKAddPassButtonStyleBlackOutline),
               },
           @"AddPassButtonWidth": @(CGRectGetWidth(addPassButton.frame)),
           @"AddPassButtonHeight": @(CGRectGetHeight(addPassButton.frame)),
           };
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

RCT_EXPORT_METHOD(addPaymentPass:(NSString *)last4 cardHolderName: (NSString *)cardHolderName
resolver:(RCTPromiseResolveBlock)resolve
rejector:(RCTPromiseRejectBlock)reject) {
    if (![PKAddPaymentPassViewController canAddPaymentPass]) {
        NSLog(@"PK Payment not supported");
        reject(@"payment_pass_unsupported", @"Unable to add payment pass, please check you have the correct entitlements", nil);
        return;
    };
    PKAddPaymentPassRequestConfiguration  * passConfig =  [[PKAddPaymentPassRequestConfiguration alloc] initWithEncryptionScheme:PKEncryptionSchemeECC_V2];
    passConfig.primaryAccountSuffix = last4;
    passConfig.cardholderName = cardHolderName;

    PKAddPaymentPassViewController * paymentPassVC = [[PKAddPaymentPassViewController alloc] initWithRequestConfiguration:passConfig delegate:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *sharedApplication = RCTSharedApplication();
        UIWindow *window = sharedApplication.keyWindow;
        if (window) {
          UIViewController *rootViewController = window.rootViewController;
          if (rootViewController) {
              [rootViewController presentViewController:paymentPassVC animated:YES completion:^{
                // Succeeded
                resolve(nil);
              }];
              return;
          }
        }
    });

}

#pragma mark - PKAddPaymentPassViewControllerDelegate

- (void)addPaymentPassViewController:(PKAddPaymentPassViewController *)controller didFinishAddingPaymentPass:(PKPaymentPass *)pass error:(NSError *)error  {

    // TODO: Handle pass
    [self sendEventWithName:@"addPaymentPassViewControllerDidFinish" body:nil];
}

- (void)addPaymentPassViewController:(PKAddPaymentPassViewController *)controller generateRequestWithCertificateChain:(NSArray<NSData *> *)certificates nonce:(NSData *)nonce nonceSignature:(NSData *)nonceSignature completionHandler:(void (^)(PKAddPaymentPassRequest * _Nonnull))handler {

    PKAddPaymentPassRequest *paymentPassRequest = [[PKAddPaymentPassRequest alloc] init];

    // TODO: Get encrypted data from server
    NSString * ecryptedPassString = @"data_from_server";
    NSString * activationString = @"data_from_server";
    NSString * pubKey = @"public_key";

    NSData * encryptedPassData = [[NSData alloc] initWithBase64EncodedString:ecryptedPassString options:0];
    NSData * activationData = [[NSData alloc] initWithBase64EncodedString:activationString options:0];
    NSData * pubKeyData = [[NSData alloc] initWithBase64EncodedString:pubKey options:0];

    paymentPassRequest.encryptedPassData = encryptedPassData;
    paymentPassRequest.activationData = activationData;
    paymentPassRequest.ephemeralPublicKey = pubKeyData;

    handler(paymentPassRequest);
}


#pragma mark - RCTEventEmitter implementation

- (NSArray<NSString *> *)supportedEvents {
  return @[@"addPaymentPassViewControllerDidFinish"];
}

@end
