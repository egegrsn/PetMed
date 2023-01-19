//
//  Extensions.swift
//  PetMed
//
//  Created by Ege Girsen on 7.01.2023.
//

import UIKit

extension UIView {

    /// Adds a drop shasow with default values
      func addDefaultDropShadow() {
          self.addShadow(opacity: 0.25, shadowRadius: 3)
      }
      
      /// Adds a drop shadow to the UIView
      /// - Parameter opacity: Opacity value
      /// - Parameter shadowRadius: Size of the shadow
      /// - Parameter offset: Offset of the shadow
      func addShadow(opacity: Float, shadowRadius: CGFloat, offset: CGSize = .zero) {
          layer.masksToBounds = shadowRadius == 0
          layer.shadowColor = UIColor.black.cgColor
          layer.shadowOpacity = opacity
          layer.shadowOffset = offset
          layer.shadowRadius = shadowRadius
      }
    
    func addCornerRadius(){
        layer.cornerRadius = 5;
        layer.masksToBounds = true;
    }
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension VaccinationViewModel{
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
}

extension UIImageView {
    
    func makeRounded() {
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

extension UIImage {
    public func resized(target: CGSize) -> UIImage {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let new = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}

extension UIViewController{
    
    func showAlert(title: String,message: String,actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getTodaysDate() -> String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: currentDateTime)
        return dateString
    }
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage, _ name: String) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let filename = name
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
            return String.init("/Documents/\(filename)")
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    
    func loadImageWithPath(path: String) -> UIImage?{
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first
            {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(path)")
                    let image    = UIImage(contentsOfFile: imageURL.path)
                    if let image = image {
                        return image
                    }
            }
        return nil
    }
}
