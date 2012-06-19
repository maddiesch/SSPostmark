### SSPostmark

> [Postmark](http://postmarkapp.com/) removes the headaches of delivering and parsing transactional email for webapps with minimal setup time and zero maintenance. We have years of experience getting email to the inbox, so you can work and rest easier.

This is a simple Objective-C class to send email using the Postmark API.

Works on both Mac OS X 10.7 & iOS 5

***

#### How To Use It

1. Add `SSPostmark.h` and `SSPostmark.m` to your project, then `#import "SSPostmark.h"`

3. Call `SSPostmark *postmark = [[SSPostmark alloc] initWithApiKey:@"YOUR_API_KEY"];`.  This gives you the postmark instance to work with.

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
	
7. Call `[postmark sendEmail:mail]`
	
8. Wait for the response from the server on delegate or notification listener.

***

#### Batch emails.

- Sending bulk messages.  Just call `sendBatchMessages:` on your SSPostmark instance and pass in a `NSSArray` of `SSPostmarkMessage`s

	- You will get individual callbacks for each successful email sent.
	
	- Also see the rules on [Batch Messaging](http://developer.postmarkapp.com/developer-build.html#batching-messages)


***

#### Attachments 

SSPostmarkAttachment

- `name` : String with the name of the file.
- `contentType` : MIME Type of the file.
- `content` : base64 encoded file.

The best way to set the content is to call `addData:` and pass in a NSData object.  We'll handle the encoding for you. 

***

### Putting it all together

	// Create the message
	SSPostmarkMessage *mail = [SSPostmarkMessage new];
    mail.to = @"test@domain.com";
    mail.subject = @"Testing The Mailtoobz";
    mail.textBody = @"Test Email";
    mail.tag = @"ObjectCTest";
    // Sender Info
    mail.fromEmail = @"test.sender@domain.com";
    mail.replyTo = @"test.sender@domain.com";
    
    // If you're using the UIImage helper method we'll automaticaly add .png to the end of name if it's not there.
    SSPostmarkAttachment *att = [SSPostmarkAttachment attachmentWithImage:[UIImage imageNamed:@"happy-panda.jpg"] named:@"happy-panda"];
    // Add an attachemnt to the array.
    [mail addAttachment:att];
    
    // Send
    SSPostmark* postmark = [[SSPostmark alloc] initWithApiKey:@"POSTMARK_API_TEST"];
    postmark.delegate = self;
    [postmark sendEmail:mail];

***

#### SSPostmarkViewController

More info coming soon...

***

Questions or comments please [email me](mailto:ss@schipp.co) or [tweet me](http://twitter.com/skylarsch)