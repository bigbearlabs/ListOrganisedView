import Cocoa



open class GenericCollectionItemModel: NSObject {
  @objc dynamic
  public var id: String = "stub-id"
  @objc dynamic
  public var title: String = "stub-title"
  //  @objc dynamic
  //  var icon: NSImage! = nil
  public var tooltipText: String = "stub-tooltip-text"
}



public class GenericCollectionViewController: NSViewController {
  
  
  var itemModels: [GenericCollectionItemModel]! {
    didSet {
      (collectionView?.dataSource as? GenericCollectionViewDataSource)?.itemModels = self.itemModels
      collectionView?.reloadData()
    }
  }
  
  var collectionItemNib: NSNib? {
    didSet {
      self.collectionView?.register(
        collectionItemNib!,
        forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DefaultCollectionViewItem")
      )
    }
  }
  
  var onSelect: ((_ modelObject: GenericCollectionItemModel, _ vc: GenericCollectionViewController) -> ())?
  
  var itemHeight: CGFloat = 80  // reasonable default.
  
  
  @IBOutlet weak var collectionView: NSCollectionView?
  
  
  override public func viewWillAppear() {
    super.viewWillAppear()
    
//    guard collectionItemNib != nil,
//      onSelect != nil,
//      itemModels != nil
//    else {
//      fatalError("\(self) not fully set up.")
//    }
    
    // trigger the didSets.
    if let items = self.itemModels {
      self.itemModels = items
    }
    if let nib = self.collectionItemNib {
      self.collectionItemNib = nib
    }
    
  }

  @IBAction func action_addListItem(_ sender: Any) {
    // present 'add item' scene.
  }
  

  @IBAction func action_editListItem(_ sender: Any) {
    // present 'edit item' scene.
  }
  
  
  // confirm add
  
  // confirm edit
  
  // confirm delete
  
  // cancel
  
  
  // further down the line: re-order
  
  // further down the line: drag-drop
}


extension GenericCollectionViewController: NSCollectionViewDelegate {
  
  // MARK: - delegate
  
  public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    
    guard indexPaths.count == 1,
      let indexPath = indexPaths.reversed().first
      else { fatalError() }
    
    // find the view model object for the list item.
    let selectedItem = collectionView.item(at: indexPath)
    let modelObject = selectedItem!.representedObject as! GenericCollectionItemModel
    
    // invoke its action.
    // invokeAction(object: modelObject)
    
    self.onSelect!(modelObject, self)
  }
  
}

extension GenericCollectionViewController: NSCollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
    return NSSize(width: collectionView.bounds.size.width, height: self.itemHeight)
  }
}

class GenericCollectionViewDataSource: NSObject, NSCollectionViewDataSource {
  
  var itemModels: [GenericCollectionItemModel]!
  
  func viewModel(indexPath: IndexPath) -> GenericCollectionItemModel {
    return itemModels[indexPath.item]
  }
  
  
  // MARK: - NSCollectionViewDataSource
  
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

    // precondition: nib registered with same item id.
    let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DefaultCollectionViewItem"), for: indexPath)
    item.representedObject = viewModel(indexPath: indexPath)
    return item
  }
  
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    // no sections for now.
    return 1
  }
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return itemModels?.count ?? 0
  }
  
}
