#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate,
                                              UIImagePickerControllerDelegate,
                                              UIBarPositioning>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (IBAction)showImagePickerButtonPressed;
- (IBAction)tweetButtonPressed;

@end