import Cocoa
import WebKit



open class ListOrganisedViewController: NSViewController {
 
  
  // data.
  
  public var itemModels: [GenericCollectionItemModel] = [] {
    didSet {
      sidebarCollectionViewController.itemModels = self.itemModels
      
      // select the first one by default.
      if self.selectedItemModels.isEmpty,
        let firstItemModel = self.itemModels.first {
        self.selectedItemModels = [ firstItemModel ]
      }
    }
  }
  
  public var selectedItemModels: [GenericCollectionItemModel] {
    get {
      return sidebarCollectionViewController.selectedItemModels
    }
    set {
      sidebarCollectionViewController.selectedItemModels = newValue
    }
  }
  
  
  // collection view config.
  
  public var onSelect: ((_ models: [GenericCollectionItemModel], _ viewController: GenericCollectionViewController) -> ())?
  
  public var onDoubleClick: ((_ model: GenericCollectionItemModel, _ viewController: GenericCollectionViewController) -> ())?

  lazy public var collectionItemNib: NSNib? = {
    return NSNib(nibNamed: NSNib.Name.init("SidebarItem"), bundle: Bundle(for: type(of: self)))  // usage-example
  }()

  public var itemHeight: CGFloat = 80 {
    didSet {
      sidebarCollectionViewController.itemHeight = self.itemHeight
    }
  }
  
  
  // split view config.
  
  public var listWidth: CGFloat = 20
  
  
  @IBOutlet weak var splitView: NSSplitView!
  
  
  // MARK: -
  
  open override func viewWillAppear() {
    super.viewWillAppear()
    
    setup(sidebarVc: sidebarCollectionViewController)
    setup(splitView: splitView)
  }
  
  func setup(splitView: NSSplitView) {
    splitView.setPosition(self.listWidth, ofDividerAt: 0)
  }
  
  func setup(sidebarVc: GenericCollectionViewController) {
    sidebarVc.collectionItemNib = self.collectionItemNib
    sidebarVc.onSelect = self.onSelect
    sidebarVc.onDoubleClick = self.onDoubleClick
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
  
  
  var sidebarCollectionViewController: GenericCollectionViewController!
  
  var contentViewController: ContentViewController {
    return self.childViewControllers.compactMap {
      $0 as? ContentViewController
      }
      .last!
  }
  
  open override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    if let vc = segue.destinationController as? GenericCollectionViewController {
      self.sidebarCollectionViewController = vc
    }
    
    super.prepare(for: segue, sender: sender)
  }
}


extension ListOrganisedViewController: NSSplitViewDelegate {
 
  public func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
    if view === sidebarCollectionViewController.view.superview {
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
