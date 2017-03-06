//
//  SNViewController.m
//  SnazzleClient
//
//  Created by Carl Bolstad on 3/5/17.
//  Copyright © 2017 Carl Bolstad. All rights reserved.
//

#import "SNViewController.h"

@interface SNViewController ()

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) NSMutableArray <NSNetService*>*services;
@property (nonatomic, strong) NSNetServiceBrowser *serviceBrowser;
@property (nonatomic, strong) NSTimer *searchTimer;

@property (nonatomic, strong) UITableView *serviceTableView;
@property (nonatomic, strong) UIRefreshControl *serviceRefreshControl;
@end

@interface SNViewController(NSNetServiceBrowserDelegate) <NSNetServiceBrowserDelegate> @end
@interface SNViewController(UITableViewDataSource) <UITableViewDataSource> @end

@implementation SNViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   // Do any additional setup after loading the view, typically from a nib.
   self.view.backgroundColor = [UIColor whiteColor];
   
   [self searchForServices];
}


- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (void)searchForServices
{
   [self.serviceBrowser stop];
   self.serviceBrowser = nil;
   [self.services removeAllObjects];
   [self.serviceTableView reloadData];
   
   NSNetServiceBrowser *nsb = [[NSNetServiceBrowser alloc] init];
   nsb.includesPeerToPeer = YES;
   nsb.delegate = self;
   self.serviceBrowser = nsb;
   
   //[nsb searchForRegistrationDomains];
   //[nsb searchForBrowsableDomains];
   [self.serviceBrowser searchForServicesOfType:@"_snazzle._tcp" inDomain:@"local."];
   
   self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
      [self.serviceBrowser stop];
      self.isSearching = NO;
      [timer invalidate];
   }];
   
}

- (NSMutableArray *) services
{
   if (_services == nil)
   {
      _services = [[NSMutableArray alloc] init];
   }
   return _services;
}

- (UITableView *) serviceTableView
{
   if (_serviceTableView == nil)
   {
      _serviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100.0, self.view.frame.size.width, self.view.frame.size.height)];
      _serviceTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      _serviceTableView.dataSource = self;
      _serviceTableView.refreshControl = self.serviceRefreshControl;
      [self.view addSubview:_serviceTableView];
   }
   return _serviceTableView;
}

- (UIRefreshControl *) serviceRefreshControl
{
   if (_serviceRefreshControl == nil)
   {
      _serviceRefreshControl = [[UIRefreshControl alloc] init];
      [_serviceRefreshControl addTarget:self action:@selector(searchForServices) forControlEvents:UIControlEventValueChanged];
   }
   return _serviceRefreshControl;
}

- (void) setIsSearching:(BOOL)isSearching
{
   _isSearching = isSearching;
   if(!isSearching)
   {
      [self.serviceRefreshControl endRefreshing];
   }
}
@end

@implementation SNViewController(NSNetServiceBrowserDelegate)

/* Sent to the NSNetServiceBrowser instance's delegate before the instance begins a search. The delegate will not receive this message if the instance is unable to begin a search. Instead, the delegate will receive the -netServiceBrowser:didNotSearch: message.
 */
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
   NSLog(@"will search");
   self.isSearching = YES;
}

/* Sent to the NSNetServiceBrowser instance's delegate when the instance's previous running search request has stopped.
 */
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
   NSLog(@"stopped search");
   self.isSearching = NO;
}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict
{
   NSLog(@"didn't search");
   self.isSearching = NO;
}

/* Sent to the NSNetServiceBrowser instance's delegate for each domain discovered. If there are more domains, moreComing will be YES. If for some reason handling discovered domains requires significant processing, accumulating domains until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
   NSLog(@"didfind domain");
}

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
   NSLog(@"adding service %@", service.name);
   
   [self.services addObject:service];
   if (moreComing == NO)
   {
      self.isSearching = NO;
      [self.serviceTableView reloadData];
   }
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered domain is no longer available.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
   NSLog(@"did remove domain");
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing
{
   NSLog(@"did remove service");
   [self searchForServices];
}

@end

@implementation SNViewController(UITableViewDataSource)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.services count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [[UITableViewCell alloc] init];
   cell.textLabel.text = [self.services objectAtIndex:indexPath.row].name;
   return cell;
}


@end

