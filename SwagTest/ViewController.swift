import Foundation
import UIKit
import Social

class SwagViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var imageView: UIImageView?
  
  @IBAction func showImage() {
    let imageController = UIImagePickerController()
    imageController.sourceType = .PhotoLibrary
    imageController.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
    imageController.delegate = self
    imageController.allowsEditing = true
    self.presentViewController(imageController, animated: true, completion: nil)
  }
  
  @IBAction func tweetButtonPressed() {
    self.sendTweet("SWAGALICIOUS", image: imageView!.image!)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image = info[UIImagePickerControllerEditedImage] as UIImage
    let sunglassesImage = self.imageByAddingGlasses(image)
    imageView?.image = self.imageByAddingText("SWAG", image: sunglassesImage)
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func sendTweet(message: String, image: UIImage) {
    let controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
    controller.setInitialText(message)
    controller.addImage(image)
    self.presentViewController(controller, animated: true, completion: nil)
  }
  
  func imageByAddingGlasses(image: UIImage) -> UIImage {
    let sunglassesPoint = self.eyePosition(image)
    let sunglassesImage = UIImage(named: "sunglasses")
    
    UIGraphicsBeginImageContext(image.size)
    image.drawInRect(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    sunglassesImage?.drawInRect(CGRect(x: sunglassesPoint.x, y: sunglassesPoint.y, width: image.size.width / 2, height: 50))
    let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return combinedImage
  }
  
  func imageByAddingEyeIndicators(image: UIImage) -> UIImage {
    let faceFeature = self.faceFeature(image)
    let rightEyePosition = self.translate(faceFeature.rightEyePosition, image: image)
    let leftEyePosition = self.translate(faceFeature.leftEyePosition, image: image)
    let leftImage = self.imageByDrawingBox(image, position: leftEyePosition)
    return self.imageByDrawingBox(leftImage, position: rightEyePosition)
  }
  
  func imageByAddingText(text: NSString, image: UIImage) -> UIImage {
    let font = UIFont.systemFontOfSize(200)
    UIGraphicsBeginImageContext(image.size)
    let attributes = [NSFontAttributeName: font,
                      NSForegroundColorAttributeName: UIColor.whiteColor()]
    image.drawInRect(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    text.drawInRect(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), withAttributes: attributes)
    let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return combinedImage
  }
  
  func imageByDrawingBox(image: UIImage, position: CGPoint) -> UIImage {
    UIGraphicsBeginImageContext(image.size)
    image.drawInRect(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width))
    UIColor.redColor().set()
    UIRectFill(CGRect(x: position.x, y: position.y, width: 50, height: 50))
    let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return combinedImage
  }
  
  func features(image: UIImage) -> [CIFeature] {
    let coreImage = CIImage(image: image)
    let opts = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
    let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: opts)
    let options = [CIDetectorImageOrientation: image.imageOrientation]
    return detector.featuresInImage(coreImage) as [CIFeature]
  }
  
  func faceFeature(image: UIImage) -> CIFaceFeature {
    return features(image).first as CIFaceFeature
  }
  
  func eyePosition(image: UIImage) -> CGPoint {
    let faceFeature = self.faceFeature(image)
    let rightEyePosition = self.translate(faceFeature.rightEyePosition, image: image)
    let leftEyePosition = self.translate(faceFeature.leftEyePosition, image: image)
    let position = leftEyePosition.x - rightEyePosition.x
    return CGPoint(x: position, y: rightEyePosition.y)
  }
  
  func translate(point: CGPoint, image: UIImage) -> CGPoint {
    return CGPoint(x: image.size.width - point.x, y: image.size.width - point.y)
  }
  
}