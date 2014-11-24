#import <Cedar/Cedar.h>
#import <PivotalCoreKit/Foundation+PivotalSpecHelper.h>
#import "RESTClient.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface TestConfiguration : NSObject <RESTEasyConfiguration>
@end

@implementation TestConfiguration
+ (NSString *)scheme { return @"https"; }
+ (NSString *)host { return @"www.example.com"; }
+ (NSNumber *)port { return @1234; }
@end

SPEC_BEGIN(RESTClientSpec)

describe(@"RESTClient", ^{
    __block RESTClient *restClient;
    __block RESTClient *restClientEmptyConfiguration;

    beforeEach(^{
        restClient = [[RESTClient alloc] initWithConfiguration:[TestConfiguration class]];
        restClientEmptyConfiguration = [[RESTClient alloc] initWithConfiguration:nil];
    });

    describe(@"-getResourceForPath:success:error:", ^{
        __block NSArray *fetchedArray;
        __block NSError *fetchError;

        beforeEach(^{
            fetchedArray = nil;
            fetchError = nil;
        });

        sharedExamplesFor(@"making the request", ^(NSDictionary *sharedContext) {
            __block NSURL *requestedURL;

            beforeEach(^{
                requestedURL = ((NSURLConnection *)[NSURLConnection connections].lastObject).request.URL;
            });

            it(@"should have the scheme provided by the configuration", ^{
                requestedURL.scheme should equal(sharedContext[@"scheme"]);
            });

            it(@"should have the host provided by the configuration", ^{
                requestedURL.host should equal(sharedContext[@"host"]);
            });

            it(@"should have the port provided by the configuration", ^{
                requestedURL.port should equal(sharedContext[@"port"]);
            });

            it(@"should have the path in the request", ^{
                requestedURL.pathComponents should equal(@[@"/", @"path", @"to", @"resources"]);
            });
        });

        context(@"with a full configuration", ^{
            beforeEach(^{
                [restClient getResourcesForPath:@"/path/to/resources"
                                        success:^(NSArray *array) {
                                            fetchedArray = array;
                                        } error:^(NSError *error) {
                                            fetchError = error;
                                        }];
            });

            itShouldBehaveLike(@"making the request", ^(NSMutableDictionary *dict){
                dict[@"scheme"] = [TestConfiguration scheme];
                dict[@"host"] = [TestConfiguration host];
                dict[@"port"] = [TestConfiguration port];
            });
        });

        context(@"with no configuration", ^{
            beforeEach(^{
                [restClientEmptyConfiguration getResourcesForPath:@"/path/to/resources" success:nil error:nil];
            });

            itShouldBehaveLike(@"making the request", ^(NSMutableDictionary *dict){
                dict[@"scheme"] = @"http";
                dict[@"host"] = @"localhost";
                dict[@"port"] = @3000;
            });
        });
    });
});

SPEC_END
