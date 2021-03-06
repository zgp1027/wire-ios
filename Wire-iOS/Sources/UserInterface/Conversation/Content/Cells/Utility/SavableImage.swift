//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//


import AssetsLibrary

@objc final public class SavableImage: NSObject {

    public typealias ImageSaveCompletion = () -> Void
    
    fileprivate let imageData: Data
    fileprivate let imageOrientation: UIImageOrientation
    fileprivate let library = ALAssetsLibrary()
    fileprivate var writeInProgess = false

    init(data: Data, orientation: UIImageOrientation) {
        imageData = data
        imageOrientation = orientation
        super.init()
    }
    
    public func saveToLibrary(withCompletion completion: ImageSaveCompletion?) {
        guard !writeInProgess else { return }
        writeInProgess = true

        let metadata: [String: NSObject] = [ALAssetPropertyOrientation: imageOrientation.exifOrientiation as NSObject]
        library.writeImageData(toSavedPhotosAlbum: imageData, metadata: metadata) { [weak self] _, _ in
            guard let `self` = self else { return }
            self.writeInProgess = false
            completion?()
        }
    }

}

extension UIImageOrientation {
    var exifOrientiation: UInt {
        switch self {
        case .up: return 1
        case .down: return 3
        case .left: return 8
        case .right: return 6
        case .upMirrored: return 2
        case .downMirrored: return 4
        case .leftMirrored: return 5
        case .rightMirrored: return 7
        }
    }
}
