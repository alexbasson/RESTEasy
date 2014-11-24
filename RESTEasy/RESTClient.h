#import <Foundation/Foundation.h>

typedef void (^RESTEasyArraySuccessBlock)(NSArray *array);
typedef void (^RESTEasyErrorBlock)(NSError *error);

@protocol RESTEasyConfiguration;

@interface RESTClient : NSObject

- (instancetype)init __unavailable;
- (instancetype)initWithConfiguration:(Class<RESTEasyConfiguration>)configuration;

- (void)getResourcesForPath:(NSString *)path
                    success:(RESTEasyArraySuccessBlock)successBlock
                      error:(RESTEasyErrorBlock)errorBlock;

@end

@protocol RESTEasyConfiguration <NSObject>

@optional
+ (NSString *)host;
+ (NSString *)scheme;
+ (NSNumber *)port;

@end
