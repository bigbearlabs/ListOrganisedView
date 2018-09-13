import Cocoa
import ListOrganisedView

import WebKit


struct CollectionItemModel: GenericCollectionItemModel, Codable, Equatable {
  
  func isEqual(to: GenericCollectionItemModel) -> Bool {
    if let other = to as? CollectionItemModel {
      return self == other
    }
    return false
  }
  
  var id: String = "stub-id"
  
  var url: URL
  
  var title: String? = nil
  
  var tooltipText: String? = nil
  
  
  init(id: String, url: URL, title: String? = nil, tooltipText: String? = nil) {
    self.id = id
    self.url = url
    self.title = title
    self.tooltipText = tooltipText
  }
  
  
  var dictionaryRepresentation: [String : Any?] {
    return
      try! JSONSerialization.jsonObject(
        with: try! JSONEncoder().encode(self),
        options: []) as! [String : Any?]
  }

}

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    self.listOrganisedViewController.listWidth =
//      self.listOrganisedViewController.view.frame.size.width
      80
    
    self.listOrganisedViewController.itemModels = [
      {
        let o = CollectionItemModel(
          id: "google",
          url: URL(string: "https://google.com")!,
          title: "Google")
        return o
      }(),
      {
        let o = CollectionItemModel(
          id: "GitHub",
          url: URL(string: "https://github.com")!,
          title: "GitHub")
        return o
      }(),
      {
        let o = CollectionItemModel(
          id: "Twitter",
          url: URL(string: "https://twitter.com")!,
          title: "Twitter")
        return o
      }(),
      {
        let o = CollectionItemModel(
          id: "MacRumors",
          url: URL(string: "https://macrumors.com")!,
          title: "MacRumors")
        return o
      }(),
    ]
    
    self.listOrganisedViewController.onSelect = { [unowned self] models, viewController in
      self.onSelect(models, viewController)
    }
  }

  func onSelect(_ models: [GenericCollectionItemModel], _ viewController: GenericCollectionViewController) {
    guard models.count < 2 else { fatalError() }
    guard let model = models.first as? CollectionItemModel else { return }
    
    self.listOrganisedViewController.showViewFor(
      modelObject: model,
      initialiseViewControllerForModel: {
        let viewControllerForModel = controllerFromStoryboard(
          name: "WebView",
          bundle: Bundle(for: type(of: self))
          ) as! NSViewController
        return viewControllerForModel
    }
    ) { viewControllerForModel in
      // instruct the vc.
      
      let webView = viewControllerForModel.view as! WKWebView
      let url = model.url
      webView.load(URLRequest(url: url))
      
    }
  }
  

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  var listOrganisedViewController: ListOrganisedViewController {
    return self.childViewControllers.compactMap { $0 as? ListOrganisedViewController}.last!
  }
}



func controllerFromStoryboard(name: String, bundle: Bundle? = nil) -> Any? {
  let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: name), bundle: bundle)
  return storyboard.instantiateInitialController()
}
