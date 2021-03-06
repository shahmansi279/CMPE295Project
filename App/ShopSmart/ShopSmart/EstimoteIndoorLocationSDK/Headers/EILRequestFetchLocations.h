//  Copyright © 2015 Estimote. All rights reserved.

#import <Foundation/Foundation.h>
#import <EstimoteSDK/EstimoteSDK.h>

/** 
 * A block object to be executed when the request finishes. Returns an array of `EILIndoorLocation` objects.
 */
typedef void(^EILRequestFetchLocationsBlock)(NSArray *locations, NSError *error);

/**
 * Request to fetch all locations from Estimote Cloud for currently authorised user.
 *
 * Note that in order to have request working you need to be authenticated in Estimote Cloud.
 * To do that you have to call -[ESTConfig setupAppID:andAppToken:] first.
 * You can find your API App ID and API App Token in the Apps: http://cloud.estimote.com/#/apps
 * section of the Estimote Cloud: http://cloud.estimote.com/.
 */
@interface EILRequestFetchLocations : ESTRequestGetJSON

/**
 * Sends request to Estimote Cloud with completion block.
 *
 * param completion Completion block to be executed when the request finishes.
 */
- (void)sendRequestWithCompletion:(EILRequestFetchLocationsBlock)completion;

@end
