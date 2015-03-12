#import "ViewController.h"
#import <ImageIO/CGImageProperties.h>

@import CoreImage;
@import Twitter;

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)showImagePickerButtonPressed
{
  UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
  imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imageController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  imageController.delegate = self;
  imageController.allowsEditing = TRUE;
  [self presentViewController:imageController
                     animated:TRUE
                   completion:nil];
}

- (void)tweetButtonPressed
{
  [self sendTweetWithMessage:@"SWAGALICIOUS"
                    andImage:self.imageView.image];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = info[UIImagePickerControllerEditedImage];
  UIImage *sunglassesImage = [self imageByAddingGlassesToImage:image];
  self.imageView.image = [self imageByAddingText:@"SWAG"
                                         toImage:sunglassesImage];
  [picker dismissViewControllerAnimated:TRUE
                             completion:nil];
}

- (void)sendTweetWithMessage:(NSString *)message
                    andImage:(UIImage *)image
{
  SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
  [controller setInitialText:message];
  [controller addImage:image];
  [self presentViewController:controller
                     animated:TRUE
                   completion:nil];
}

- (UIImage *)imageByAddingGlassesToImage:(UIImage *)image
{
  CGPoint sunglassesPosition = [self eyePositionForImage:image];
  UIImage *sunglassesImage = [UIImage imageNamed:@"sunglasses"];
  
  UIGraphicsBeginImageContext(image.size);
  [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
  [sunglassesImage drawInRect:CGRectMake(sunglassesPosition.x,
                                         sunglassesPosition.y,
                                         image.size.width / 2,
                                         50)];
  UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return combinedImage;
}

- (UIImage *)imageByAddingEyeIndicatorsToImage:(UIImage *)image
{
  CIFaceFeature *faceFeature = [self faceFeatureForImage:image];
  CGPoint rightEyePosition = [self translatedPoint:faceFeature.rightEyePosition
                                           inImage:image];
  CGPoint leftEyePosition = [self translatedPoint:faceFeature.leftEyePosition
                                          inImage:image];
  
  UIImage *leftImage = [self imageByDrawingBoxInImage:image
                                           atPosition:leftEyePosition];
  return [self imageByDrawingBoxInImage:leftImage
                             atPosition:rightEyePosition];
}

- (UIImage *)imageByAddingText:(NSString *)text
                       toImage:(UIImage *)image
{
  UIFont *font = [UIFont systemFontOfSize:200];
  UIGraphicsBeginImageContext(image.size);
  
  NSDictionary *attributes = @{ NSFontAttributeName: font,
                                NSForegroundColorAttributeName: [UIColor whiteColor] };
  [image drawInRect:CGRectMake(0,
                               0,
                               image.size.width,
                               image.size.height)];
  [text drawInRect:CGRectMake(0,
                              0,
                              image.size.width,
                              image.size.height) withAttributes:attributes];
  UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return combinedImage;
}

- (UIImage *)imageByDrawingBoxInImage:(UIImage *)image
                           atPosition:(CGPoint)position
{
  UIGraphicsBeginImageContext(image.size);
  [image drawInRect:CGRectMake(0,
                               0,
                               image.size.width,
                               image.size.height)];
  [[UIColor redColor] set];
  UIRectFrame(CGRectMake(position.x,
                         position.y,
                         50,
                         50));
  UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return combinedImage;
}

- (NSArray *)featuresFromImage:(UIImage *)image
{
  CIImage *coreImage = [[CIImage alloc] initWithImage:image];
  NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
  CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                            context:nil
                                            options:opts];
  
  NSDictionary *options = @{ CIDetectorImageOrientation: @(image.imageOrientation + 1) };
  return [detector featuresInImage:coreImage
                           options:options];
}

- (CIFaceFeature *)faceFeatureForImage:(UIImage *)image
{
  NSArray *features = [self featuresFromImage:image];
  return features.firstObject;
}

- (CGPoint)eyePositionForImage:(UIImage *)image
{
  CIFaceFeature *faceFeature = [self faceFeatureForImage:image];

  CGPoint rightEyePosition = [self translatedPoint:faceFeature.rightEyePosition
                                           inImage:image];
  CGPoint leftEyePosition = [self translatedPoint:faceFeature.leftEyePosition
                                          inImage:image];
  
  CGFloat position = leftEyePosition.x - rightEyePosition.x;
  return CGPointMake(position, rightEyePosition.y);
}

- (CGPoint)translatedPoint:(CGPoint)point
                   inImage:(UIImage *)image
{
  return CGPointMake(image.size.width - point.x,
                     image.size.height - point.y);
}

- (UIBarPosition)barPosition
{
  return UIBarPositionTopAttached;
}

@end