//
//  Utility.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 06/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation
import UIKit

enum SuccessMessage {
    case success200
    case success204
}

enum FailureError:Error {
    case fileSaveError
    case coreDataSaveError
    case attachmentSaveError
}


class Utility {
    static var shared = Utility()
    
//    func saveNote(image:UIImage, forName name:String) -> Result<SuccessMessage, FailureError>? {
//        if let pngRepresentation = image.pngData() {
//
//            if let filePath = self.imageFilePath(forKey: name) {
//                do  {
//                    try pngRepresentation.write(to: filePath, options: .atomic)
//                    print(filePath)
//                    return .success(.success200)
//                } catch let err {
//                    print("Saving file resulted in error: ", err)
//                    return .failure(.fileSaveError)
//                }
//            }
//        }
//        return nil
//    }
    
//    func viewNote(forName name: String) -> UIImage {
//        if let filePath = self.imageFilePath(forKey: name),
//            let fileData = FileManager.default.contents(atPath: filePath.path),
//            let image = UIImage(data: fileData) {
//            return image
//        }
//        return UIImage()
//    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func imageFilePath(forKey key: String) -> URL? {
        let filename = key + ".png"
        let imagePath = getDocumentsDirectory().appendingPathComponent(filename)
        print("imagePath :", imagePath)
        return imagePath
    }
    
    func videoFilePath(forKey key: String) -> URL? {
        let filename = key + ".mp4"
        let videoPath = getDocumentsDirectory().appendingPathComponent(filename)
        print("videoPath :", videoPath)
        return videoPath
    }
    
//    func saveNote(str:String, forName name:String) -> Result<SuccessMessage, FailureError>? {
//
//        let filename = getDocumentsDirectory()?.appendingPathComponent(name + ".txt")
//
//        do {
//            try str.write(to: filename!, atomically: true, encoding: .utf8)
//            print(filename!)
//            return .success(.success200)
//        } catch let fileWriteError {
//            print("Saving file resulted in error: ", fileWriteError)
//            return .failure(.fileSaveError)
//        }
//    }
    
    func canOpenURL(ofString string: String?) -> Bool {
        if let url = NSURL(string: string!) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    func trim(str:String) -> String? {
        let trimmedStr = str.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr
    }
    
    func getCurrentDate(withFormat format:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        let myString = formatter.string(from: Date())
        let formattedDate = formatter.date(from: myString)
//        print(formattedDate!)
        
        return formattedDate!
    }
    
}
