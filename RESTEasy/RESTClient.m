#import "RESTClient.h"

@interface RESTClient ()
@property (nonatomic, strong) Class<RESTEasyConfiguration> configuration;
@property (nonatomic, strong) NSURLComponents *urlComponents;
@end

@implementation RESTClient

- (instancetype)initWithConfiguration:(Class<RESTEasyConfiguration>)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
    }
    return self;
}

- (void)getResourcesForPath:(NSString *)path
                    success:(RESTEasyArraySuccessBlock)successBlock
                      error:(RESTEasyErrorBlock)errorBlock {
    self.urlComponents.path = path;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.urlComponents.URL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                           }];
}

#pragma mark - Private

- (NSURLComponents *)urlComponents {
    if (!_urlComponents) {
        _urlComponents = [[NSURLComponents alloc] init];
        _urlComponents.scheme = @"http";
        _urlComponents.host = @"localhost";
        _urlComponents.port = @3000;

        if (self.configuration) {
            _urlComponents.scheme = [self.configuration scheme] ?: @"http";
            _urlComponents.host = [self.configuration host] ?: @"localhost";
            _urlComponents.port = [self.configuration port] ?: @3000;
        }
    }
    return _urlComponents;
}

@end
