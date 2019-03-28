import Cocoa
import FlexibleDiff


public protocol GenericCollectionItemModel {
  var id: String { get }
  var title: String? { get }
  var tooltipText: String? { get }

  var dictionaryRepresentation: [String : Any?] { get }
  
  func isEqual(to: GenericCollectionItemModel) -> Bool
}


public class GenericCollectionViewController: NSViewController {

  public var itemModels: [GenericCollectionItemModel] = [] {
    didSet {
      (collectionView?.dataSource as? GenericCollectionViewDataSource)?.itemModels = self.itemModels

      if oldValue.isEmpty {
        // first load
        collectionView?.reloadData()
        return
      }

      refreshCollectionViewWithData(from: oldValue, to: self.itemModels)
    }
  }

  func refreshCollectionViewWithData(from: [GenericCollectionItemModel], to: [GenericCollectionItemModel]) {

    let changeset = Changeset(
      previous: from,
      current: to,
      identifier: { model in model.id },
      areEqual: { a, b in
        return "\(a.dictionaryRepresentation)" == "\(b.dictionaryRepresentation)"
      })
    
    collectionView?.performBatchUpdates({
      collectionView?.insertItems(
        at: Set(changeset.inserts.map { IndexPath(item: $0, section: 0) }))
      
      collectionView?.deleteItems(
        at: Set(changeset.removals.map { IndexPath(item: $0, section: 0) }))
      
      for move in changeset.moves {
        collectionView?.moveItem( at: IndexPath(item: move.source, section: 0), to: IndexPath(item: move.destination, section: 0))
      }
      
      collectionView?.reloadItems(
        at: Set(changeset.mutations.map { IndexPath(item: $0, section: 0) }))

    }, completionHandler: { finished in
    })
    

  }


  public var collectionItemNib: NSNib? {
    didSet {
      self.collectionView?.register(
        collectionItemNib!,
        forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DefaultCollectionViewItem")
      )
    }
  }

  public var onSelect: ((_ modelObjects: [GenericCollectionItemModel], _ vc: GenericCollectionViewController) -> ())? {
    didSet {
      if self.selectedItemModels.count > 0 {
        self.onSelect?(self.selectedItemModels, self)
      }
    }
  }

  public var onDoubleClick: ((_ modelObject: GenericCollectionItemModel, _ vc: GenericCollectionViewController) -> ())?

  public var itemHeight: CGFloat = 80  // reasonable default.



  public var selectedItemModels: [GenericCollectionItemModel] {
    get {
      let indexes = self.collectionView!.selectionIndexPaths
      let models = indexes.map {
        (self.collectionView!.dataSource as! GenericCollectionViewDataSource).viewModel(indexPath: $0)
      }

      return models
    }
    set {
      let collectionView = self.collectionView!
      let models = (collectionView.dataSource as! GenericCollectionViewDataSource).itemModels!
      
      let selectionIndices = newValue.compactMap { selectedModel in
        models.index {
          $0.isEqual(to: selectedModel)
        }
      }
      
      let indexPaths = selectionIndices.map {
        IndexPath(item: $0, section: 0)
      }

      collectionView.selectionIndexPaths = Set(indexPaths)

      // call the handler.
      self.onSelect?(newValue, self)
    }
  }


  @IBOutlet
  weak var collectionView: NSCollectionView?

  @IBOutlet
  var collectionViewDataSource: GenericCollectionViewDataSource?

  override public func viewWillAppear() {
    super.viewWillAppear()

    // trigger the didSets.

    let items = self.itemModels
    self.itemModels = items

    let nib = self.collectionItemNib
    self.collectionItemNib = nib!
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


// MARK: - delegate

extension GenericCollectionViewController: NSCollectionViewDelegate {

  public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    let modelObjects = self.selectedItemModels
    self.onSelect?(modelObjects, self)
  }

  public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
    let modelObjects = self.selectedItemModels
    self.onSelect?(modelObjects, self)
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

    let viewModel = self.viewModel(indexPath: indexPath)

    // precondition: nib registered with same item id.
    let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SidebarItem"), for: indexPath)
    item.representedObject = viewModel.dictionaryRepresentation

    item.view.onDoubleClick = {
      let vc = collectionView.delegate as! GenericCollectionViewController
      if let handler = vc.onDoubleClick {
        handler(viewModel, vc)
      } else {
        print("WARN: no double click handler for \((vc, viewModel))")
      }
    }
    // improve: potentially a lot of transient closures are inited here.
    // consider assigning a longer-lived double-click handler with e.g. selected model param obtained from the view's state instead.

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

