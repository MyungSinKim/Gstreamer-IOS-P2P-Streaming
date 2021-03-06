//
//  Login_ViewController.m
//  GStreamer iOS Tutorials
//
//  Created by cxphong on 9/4/14.
//
//

#import "Login_ViewController.h"
#import "Gstreamer_ViewController.h"
#include "login.h"

#define LOGIN_WRONG_USERINPUT 0x00
#define LOGIN_SERVER_UNREACHABLE 0x01
#define LOGIN_SUCCESSED 0x02

@ interface Login_ViewController()

 @ end @ implementation Login_ViewController - (id) initWithNibName:(NSString *)
nibNameOrNil bundle:(NSBundle *) nibBundleOrNil
{
 self =[super initWithNibName: nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

-(void)viewDidLoad {
	puts("viewDidLoad of login");
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

 -(IBAction) textFieldReturn:(id) sender {
	[sender resignFirstResponder];
}

 -(IBAction) login_to_server:(id) sender {
	int ret = login_to_server([usernameTF.text UTF8String],
				  [passwordTF.text UTF8String]);

	switch (ret) {
	case LOGIN_SUCCESSED:{
			/* List available session */
			puts("Login success");

			/* Get username */
			username = (char *)calloc(100, sizeof(char));
			strncpy(username,[usernameTF.text UTF8String], strlen([usernameTF.text UTF8String]));
			puts(username);

			char *result;
			char *sessionId;
			char *peerId;

			result = list_available_session();
			printf("session info = %s\n", result);

			/* Get Session id 
			 * Suppose has 1 session
			 */
			sessionId = strtok(result, ";");
			sessionId = strtok(result, ",");
			sessionId = strtok(NULL, ",");
			puts(sessionId);

			/* Join into session */
			/* Suppose just 1 session */
			/* Suppose just 1 level */
			result = join_into_session(sessionId);
			peerId = strtok(result, ",");
			printf("peerId = \"%s\"\n", peerId);

			/* Go to display video viewcontroller */
 UIStoryboard *storyboard =[UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle:nil];
 Gstreamer_ViewController *viewController = (Gstreamer_ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"gstreamerView"];
 [self presentViewController: viewController animated: YES completion:nil];

			break;
		}

	case LOGIN_WRONG_USERINPUT:{
			/*
			 * Couldn't connect to server because wrong input or
			 * server failed.
			 */
 UIAlertView *alert =[[UIAlertView alloc] initWithTitle: @"Incorrect usename or password" message: @"" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles:nil];
			[alert show];
			break;
		}

	case LOGIN_SERVER_UNREACHABLE:{
			/*
			 * Server was unreachable
			 */
			puts("Server was unreachable");
 UIAlertView *alert =[[UIAlertView alloc] initWithTitle: @"Could not connect to server" message: @"" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles:nil];
			[alert show];
			break;
		}

	default:
		break;
	}

	puts("exit view login");
}

@end
