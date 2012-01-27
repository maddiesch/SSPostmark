### SSPostmark

> [Postamrk](http://postmarkapp.com/) removes the headaches of delivering and parsing transactional email for webapps with minimal setup time and zero maintenance. We have years of experience getting email to the inbox, so you can work and rest easier.

This is a simple Objective-C class to send email using the Postmark API.

***

#### How To Use It

1. Add `SSPostmark.h` and `SSPostmark.m` to your project, then `#import "SSPostmark.h"`

2. In `SSPostmark.h` change `#define pm_YOUR_API_KEY @"POSTMARK_API_TEST"` to `#define pm_YOUR_API_KEY @"< Whatever your private API key is >"`

3. Call `SSPostmark* postmark = [[SSPostmark alloc]init];`.  This gives you the postmark instance to work with.

4. At the very least make sure your usage class implements `-(void)postmark:(id)postmark returnedMessage:(NSDictionary *)message withStatusCode:(NSUInteger)code`

5. Set the QSPostmark delegate `postmark.delegate = self;`.  This allows us to receive the messages back from the service.

6. Pass an NSDictionary containing the following keys to `[postmark sendEmailWithParamaters:<NSDictionary> asynchronously:<BOOL>];`
	- `kSSPostmarkHTMLBody` : `NSString`
	- `kSSPostmarkTextBody` : `NSString`
	- `kSSPostmarkFrom` : `NSString`
	- `kSSPostmarkTo` : `NSString`
	- `kSSPostmarkCC` : `NSString` :: OPTIONAL
	- `kSSPostmarkBCC` : `NSString` :: OPTIONAL
	- `kSSPostmarkSubject` : `NSString`
	- `kSSPostmarkTag` : `NSString`
	- `kSSPostmarkReplyTo` : `NSString`
	- `kSSPostmarkHeaders` : `NSString` :: OPTIONAL
	
7. Wait for the response from the server.

***

- The delegate methods are always called on the main thread even if the request is made asynchronously.

- Passing `NO` to `[postmark sendEmailWithParamaters:<NSDictionary> asynchronously:<BOOL>]` in the asynchronously param will block the main thread.

***

Questions or comments please [email me](mailto:ss@schipp.co) or [tweet me](http://twitter.com/skylarsch)