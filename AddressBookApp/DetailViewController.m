//
//  DetailViewController.m
//  AddressBookApp
//
//  Created by Anushree Kala on 2016-01-17.
//  Copyright © 2016 Kinectic_Cafe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
static dispatch_queue_t imageQueue;
NSData *_imageData;
NSString *_emailString;
NSString* _cellphone;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageQueue = dispatch_queue_create("com.company.app.imageQueue", NULL);
    
    //set all fields to display selected contact from ContactListViewController
    //Name
    NSString* firstName = [[[[self.userInfo objectForKey:@"user"] objectForKey:@"name"] objectForKey:@"first"] capitalizedString];
    NSString* lastName = [[[[self.userInfo objectForKey:@"user"] objectForKey:@"name"] objectForKey:@"last"] capitalizedString];
    NSString* fullName = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", lastName]];
    _personName.text = fullName;
    
    // Address
    NSString* street = [[[[self.userInfo objectForKey:@"user"] objectForKey:@"location"] objectForKey:@"street"] capitalizedString];
    NSString* cityName = [[[[self.userInfo objectForKey:@"user"] objectForKey:@"location"] objectForKey:@"city"] capitalizedString];
    NSString* address = [street stringByAppendingString:[NSString stringWithFormat:@", %@", cityName]];
    _address.text = address;
    
    //Address2
     NSString* state = [[[[self.userInfo objectForKey:@"user"] objectForKey:@"location"] objectForKey:@"state"] capitalizedString];
    NSString* zipCode = [[[self.userInfo objectForKey:@"user"] objectForKey:@"location"] objectForKey:@"zip"];
    NSString* address2 = [state stringByAppendingString:[NSString stringWithFormat:@", %@", zipCode]];
    _address2.text = address2;
    
    
    // phone numbers
    _cellphone = [[[self.userInfo objectForKey:@"user"] objectForKey:@"cell"] capitalizedString];
    _cellNumber.text= _cellphone;
    NSString* phone = [[[self.userInfo objectForKey:@"user"] objectForKey:@"phone"] capitalizedString];
    _phoneNumber.text = phone;
    
    //Email
    _emailString = [[self.userInfo objectForKey:@"user"] objectForKey:@"email"];
    _email.text = _emailString;
    
    //Date of birth
    NSNumber *dob = [[self.userInfo objectForKey:@"user"] objectForKey:@"dob"];
    NSInteger value = [dob integerValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:value];
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *dateString = [dateformater stringFromDate:date];
    _dateOfBirth.text = dateString;
    
    
    // picture
    NSString* picURL = [[[self.userInfo objectForKey:@"user"] objectForKey:@"picture"] objectForKey:@"large"];
    //Set person image
    dispatch_async(imageQueue, ^{
        _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _personImageView.image = [UIImage imageWithData:(NSData *)_imageData];
        });
    });
    
}

// This method is used to send SMS but it will not work on simulator.
- (IBAction)sendSMS:(UIButton *)sender {
    [self sendSMS:@"Body of SMS..." recipientList:[NSArray arrayWithObjects:_cellphone, nil]];
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

// Delegate function of MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else 
                NSLog(@"Message failed");
        }

// This method is used to call user but it will not work on simulator.
- (IBAction)callUser:(UIButton *)sender {
    
    NSString* phone = [[[self.userInfo objectForKey:@"user"] objectForKey:@"cell"] capitalizedString];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phone]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Call facility is not available!!!"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"ok"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}

// This method is used to send email but it will not work on simulator.But working correctly on device.
- (IBAction)sendEmail:(UIButton *)sender {
    
    // if mailComposer can send mail else it will show alert view that "E-mail facility is not available".
    if ([MFMailComposeViewController canSendMail])
    {
        // customizing navigation bar
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        //set delegate
        controller.mailComposeDelegate = self;
        //set background image
        [controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
        controller.navigationBar.tintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        //set subject
        [controller setSubject:@""];
        //set message body to be sent
        [controller setMessageBody:@"" isHTML:NO];
        // set To recipient. we can send email to multiple email address by mentioning it in arrayWithObjects
        [controller setToRecipients:[NSArray arrayWithObjects:_emailString,nil]];
        //Attach file
        [controller addAttachmentData:_imageData mimeType:@"image/jpg" fileName:@"Sms"];
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"E-mail facility is not available!!!"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"ok"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

// Delegate method of mailComposeController. It runs after sending it successfully or in case of failure
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
                default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
