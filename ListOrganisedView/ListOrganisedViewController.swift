import Cocoa
import WebKit



open class ListOrganisedViewController: NSViewController {
 
  public var itemModels: [GenericCollectionItemModel] = []
  
  
  public var onSelect: ((_ model: GenericCollectionItemModel, _ viewController: GenericCollectionViewController) -> ())?
  

  public var listWidth: CGFloat = 20
  
  lazy public var collectionItemNib: NSNib? = {
    return NSNib(nibNamed: NSNib.Name.init("SidebarItem"), bundle: Bundle(for: type(of: self)))  // usage-example
  }()
  
  @IBOutlet weak var splitView: NSSplitView!
  
  
  open override func viewWillAppear() {
    super.viewWillAppear()
    
    setup(sidebarVc: sidebarVc)
    setup(splitView: splitView)
  }
  
  func setup(splitView: NSSplitView) {
    splitView.setPosition(self.listWidth, ofDividerAt: 0)
  }
  
  func setup(sidebarVc: GenericCollectionViewController) {
    sidebarVc.collectionItemNib = self.collectionItemNib
    sidebarVc.onSelect = self.onSelect
    sidebarVc.itemModels = self.itemModels
  }
  
  
  public func showViewFor(
    modelObject: GenericCollectionItemModel,
    initialiseViewControllerForModel: () -> NSViewController,
    completionHandler: (NSViewController) -> ()) {
    
    self.contentViewController.showViewFor(
      modelObject: modelObject,
      initialiseViewControllerForModel: initialiseViewControllerForModel,
      completionHandler: completionHandler)
  }
    
  var contentViewController: ContentViewController {
    return self.childViewControllers.compactMap {
      $0 as? ContentViewController
      }
      .last!
  }
  
  var sidebarVc: GenericCollectionViewController {
    return self.childViewControllers.compactMap {
      $0 as? GenericCollectionViewController
      }
      .last!
  }
}


extension ListOrganisedViewController: NSSplitViewDelegate {
 
  public func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
    if view === sidebarVc.view.superview {
      return false
    }
    
    return true
  }
  
  public func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
    return true
  }
  
  public func splitView(_ splitView: NSSplitView, constrainSplitPosition proposedPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
    return self.listWidth
  }
  
}
