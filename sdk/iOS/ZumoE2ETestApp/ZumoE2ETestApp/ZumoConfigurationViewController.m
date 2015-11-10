// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------

#import "ZumoConfigurationViewController.h"
#import "ZumoMainTableViewController.h"
#import "ZumoTestStore.h"
#import "ZumoTestGlobals.h"

@interface ZumoConfigurationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *appUrl;
@property (weak, nonatomic) IBOutlet UITextField *storageURL;
@property (weak, nonatomic) IBOutlet UITextField *storageToken;

@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIView *validationView;

@end


@implementation ZumoConfigurationViewController

- (IBAction)BeginTests:(UIButton *)sender {
    // Load app info before continuing...
    if (![self validateAppInfo]) {
        return;
    }
    
    // Automatically add azure-mobile.net if not specified for convenience
    NSString *appUrl = self.appUrl.text;
    if (![appUrl hasPrefix:@"https://"] && ![appUrl hasPrefix:@"http://"]) {
        appUrl = [NSString stringWithFormat:@"https://%@.azure-mobile.net", appUrl];
    }
    
    // Build the client object
    ZumoTestGlobals *globals = [ZumoTestGlobals sharedInstance];
    [globals initializeClientWithAppUrl:appUrl andGatewayURL:nil];
    [globals saveAppInfo:appUrl key:nil];
    
    NSMutableDictionary *globalTestParams = globals.globalTestParameters;
    globalTestParams[RUNTIME_VERSION_TAG] = @"DotNet-App";

    [self performSegueWithIdentifier:@"BeginTests" sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.appUrl.delegate = self;
    self.storageURL.delegate = self;
    self.storageToken.delegate = self;

    NSArray *lastUsedApp = [[ZumoTestGlobals sharedInstance] loadAppInfo];
    if (lastUsedApp) {
        self.appUrl.text = [lastUsedApp objectAtIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BeginTests"]) {
        ZumoMainTableViewController *mainController = (ZumoMainTableViewController *)segue.destinationViewController;
        
        mainController.testGroups = [ZumoTestStore createTests];
        
        NSString *appUrl = self.appUrl.text;
        if (![appUrl hasPrefix:@"https://"] && ![appUrl hasPrefix:@"http://"]) {
            appUrl = [NSString stringWithFormat:@"https://%@.azure-mobile.net", appUrl];
        }
        
        ZumoTestGlobals *globals = [ZumoTestGlobals sharedInstance];
        [globals initializeClientWithAppUrl:appUrl andGatewayURL:nil];
        [globals saveAppInfo:appUrl key:nil];

        if (self.storageToken.text && self.storageURL.text) {
            globals.storageURL = self.storageURL.text;
            globals.storageToken = self.storageToken.text;
        }
        
        self.validationView.hidden = YES;
    }
}

- (BOOL) validateAppInfo {
    
    if ([self.appUrl.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please set the application URL and key before proceeding" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
 }


# pragma mark UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // todo: adjust view on switch from app fields to reporting ones
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
