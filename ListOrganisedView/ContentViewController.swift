import Cocoa


class ContentViewController: NSViewController {
  
  @IBOutlet var tabView: NSTabView!
  
  
  func showContent(
    modelObject: GenericCollectionItemModel,
    initialiseViewControllerForModel: () -> NSViewController,
    completionHandler: (NSViewController) -> ()) {
    
    let tabViewItem = tabView.tabViewItems.first {
      ($0.identifier as? String) == modelObject.id
      }
      ?? {
        let item = self.tabViewItem(modelObject: modelObject, initialiseViewControllerForModel: initialiseViewControllerForModel)
        tabView.addTabViewItem(item)
        return item
      }()
    
    
    tabView.selectTabViewItem(tabViewItem)
    
    let viewController = tabViewItem.viewController!
    completionHandler(viewController)
  }
  
  
  func tabViewItem(modelObject: GenericCollectionItemModel, initialiseViewControllerForModel: () -> NSViewController) -> NSTabViewItem {
    
    let item = NSTabViewItem(identifier: modelObject.id)
    
    let viewControllerForModel = initialiseViewControllerForModel()
    item.viewController = viewControllerForModel
    item.view = viewControllerForModel.view
    
    return item
  }
}


