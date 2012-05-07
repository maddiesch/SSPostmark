### SSPostmark

> [Postmark](http://postmarkapp.com/) removes the headaches of delivering and parsing transactional email for webapps with minimal setup time and zero maintenance. We have years of experience getting email to the inbox, so you can work and rest easier.

This is a simple Objective-C class to send email using the Postmark API.

Works on both Mac OS X 10.7 & iOS 5

***

#### How To Use It

1. Add `SSPostmark.h` and `SSPostmark.m` to your project, then `#import "SSPostmark.h"`

2. In `SSPostmark.h` change `#define pm_YOUR_API_KEY @"POSTMARK_API_TEST"` to `#define pm_YOUR_API_KEY @"< Whatever your private API key is >"`

3. Call `SSPostmark *postmark = [[SSPostmark alloc] init];`.  This gives you the postmark instance to work with.

4. At the very least make sure your usage class implements `- (void)postmark:(id)postmark returnedMessage:(NSDictionary *)message withStatusCode:(NSUInteger)code` or responds to `pm_POSTMARK_NOTIFICATION` with `NSNotificationCenter`
	
	- If you want to receive notifications be sure to register and listen for notifications named `#define pm_POSTMARK_NOTIFICATION`

5. Set the QSPostmark delegate `postmark.delegate = self;`.  This allows us to receive the messages back from the service.

6. Create an instance of SSPostmarkMessage

		SSPostmarkMessage *mail = [SSPostmarkMessage new]
		mail.to = @"test.email@domain.com";
		mail.subject = @"Testing The Mailtoobz";
		mail.textBody = @"Test Email";
		mail.tag = @"ObjectCTest";
		mail.fromEmail = @"test.email.sender@domain.com";
		mail.replyTo = @"test.email.sender@domain.com";
	
7. Call `sendEmail:`
	
8. Wait for the response from the server on delegate or notification listener.

***

- Sending bulk messages.  Just call `sendBatchMessages:` on your SSPostmark instance and pass in a `NSSArray` of `SSPostmarkMessage`s

	- You will get individual callbacks for each successful email sent.
	
	- Also see the rules on [Batch Messaging](http://developer.postmarkapp.com/developer-build.html#batching-messages)


***

- `[postmark sendEmailWithParamaters:<NSDictionary> asynchronously:<BOOL>]` Will be deprecated.

***

Questions or comments please [email me](mailto:ss@schipp.co) or [tweet me](http://twitter.com/skylarsch)