//
//  UIImageView+ReadmillHighlights.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 24/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageView+ReadmillHighlights.h"

/**
 Image cache for all network images.
 */
static NSCache *ReadmillHighlightsNetworkImageCache = nil;

/**
 Operation queue for loading images.
 */
static NSOperationQueue *ReadmillHighlightsNetworkImageOperationQueue = nil;

/**
 Key for `URLrequest` property.
 */
static void *ReadmillHighlightsNetworkImageRequestKey = &ReadmillHighlightsNetworkImageRequestKey;

/**
 The `UIImageView (ReadmillHighlightsInternal)` encapsulates internal properties and methods to be used with `UIImageView (ReadmillHighlights)` category.
 */
@interface UIImageView (ReadmillHighlightsInternal)

/**
 The last associated URL request with the image view.
 */
@property(copy, nonatomic) NSURLRequest *URLRequest;

/**
 Returns the image cache singleton.
 
 @return A `NSCache` object.
 */
+ (NSCache *)imageCache;

/**
 Returns the operation queue singleton.
 
 @return A `NSOperationQueue` object.
 */
+ (NSOperationQueue *)operationQueue;

@end

@implementation UIImageView (ReadmillHighlightsInternal)
@dynamic URLRequest;

#pragma mark -
#pragma mark Class Methods

+ (NSCache *)imageCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReadmillHighlightsNetworkImageCache = [NSCache new];
        [ReadmillHighlightsNetworkImageCache setTotalCostLimit:20*1000*1000]; // This will equal to maximum of 20MB cached images.
    });
    return ReadmillHighlightsNetworkImageCache;
}

+ (NSOperationQueue *)operationQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReadmillHighlightsNetworkImageOperationQueue = [NSOperationQueue new];
        ReadmillHighlightsNetworkImageOperationQueue.maxConcurrentOperationCount = 10;
    });
    return ReadmillHighlightsNetworkImageOperationQueue;
}

#pragma mark -
#pragma mark Properties

- (NSURLRequest *)URLRequest
{
    return objc_getAssociatedObject(self, &ReadmillHighlightsNetworkImageRequestKey);
}

- (void)setURLRequest:(NSURLRequest *)URLRequest
{
    objc_setAssociatedObject(self, &ReadmillHighlightsNetworkImageRequestKey, URLRequest, OBJC_ASSOCIATION_COPY);
}

@end

@implementation UIImageView (ReadmillHighlights)

#pragma mark -
#pragma mark Instance Methods

- (void)setImageWithURL:(NSURL *)imageURL completionHandler:(ReadmillHighlightsNetworkImageCompletionHandler)completionHandler
{
    NSString *key = [imageURL absoluteString];
    UIImage *image = [[[self class] imageCache] objectForKey:key];

    // Assign cached image if it exists.
    if (image) {
        self.image = image;
        if (completionHandler) {
            completionHandler(nil, image, nil);
        }
    }
    // Load image from the network if it's not in the cache.
    else {
        NSURLRequest *URLRequest = [NSURLRequest requestWithURL:imageURL];
        self.URLRequest = URLRequest;
        [NSURLConnection sendAsynchronousRequest:URLRequest queue:[[self class] operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            UIImage *image = nil;
            
            // Only set the image if view's current request equals image request.
            if ([URLRequest isEqual:self.URLRequest]) {
                image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.image = image;
                    if (completionHandler) {
                        completionHandler(response, image, error);
                    }
                });
            }
            
            // Cache the image even if we don't set it.
            if (image) {
                [[[self class] imageCache] setObject:image forKey:[[URLRequest URL] absoluteString] cost:[data length]];
            }
        }];
    }
}

@end
