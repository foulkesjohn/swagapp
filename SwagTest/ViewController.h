#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (IBAction)showImagePickerButtonPressed;
- (IBAction)tweetButtonPressed;

@end