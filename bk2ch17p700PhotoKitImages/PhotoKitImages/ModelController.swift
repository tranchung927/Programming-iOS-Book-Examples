

import UIKit
import Photos

class ModelController: NSObject {
    
    var recentAlbums : PHFetchResult!
    var photos : PHFetchResult!
    
    func tryToGetStarted() {
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            .SmartAlbum, subtype: .SmartAlbumRecentlyAdded, options: nil)
        self.recentAlbums = result
        let rec = result.firstObject as PHAssetCollection!
        if rec == nil {
            return
        }
        let options = PHFetchOptions() // photos only, please
        let pred = NSPredicate(format: "mediaType = %@", NSNumber(
            integer:PHAssetMediaType.Image.toRaw()))
        options.predicate = pred
        let result2 = PHAsset.fetchAssetsInAssetCollection(rec, options: options)
        self.photos = result2
    }

    override init() {
        super.init()
        self.tryToGetStarted()
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        if self.photos == nil || self.photos.count == 0 || index >= self.photos.count {
            return nil
        }
        let dvc = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as DataViewController
        dvc.dataObject = self.photos[index]
        dvc.index = index
        return dvc
    }
    

    func indexOfViewController(dvc: DataViewController) -> Int {
        return dvc.index
    }
}

extension ModelController : UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as DataViewController)
        if ix == 0 {
            return nil
        }
        return self.viewControllerAtIndex(ix-1, storyboard:viewController.storyboard)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as DataViewController)
        if ix + 1 >= self.photos.count {
            return nil
        }
        return self.viewControllerAtIndex(ix+1, storyboard:viewController.storyboard)
    }


}
