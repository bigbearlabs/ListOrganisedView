import Cocoa
import ListOrganisedView
import WebKit



class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    self.listOrganisedViewController.listWidth =
//      self.listOrganisedViewController.view.frame.size.width
      80
    
    self.listOrganisedViewController.itemModels = [
      {
        let o = GenericCollectionItemModel()
        o.id = "Google"
        o.title = "Google"
        return o
      }(),
      {
        let o = GenericCollectionItemModel()
        o.id = "GitHub"
        o.title = "GitHub"
        return o
      }(),
      {
        let o = GenericCollectionItemModel()
        o.id = "Twitter"
        o.title = "Twitter"
        return o
      }(),
      {
        let o = GenericCollectionItemModel()
        o.id = "MacRumors"
        o.title = "MacRumors"
        return o
      }(),
    ]
    
    self.listOrganisedViewController.onSelect = { [unowned self] model, viewController in
      self.onSelect(model, viewController)
    }
  }

  func onSelect(_ model: GenericCollectionItemModel, _ viewController: GenericCollectionViewController) {
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
      let url = self.url(model: model)
      webView.load(URLRequest(url: url))
      
    }
  }
  
  func url(model: GenericCollectionItemModel) -> URL {
    return URL(string: "https://google.com")!  // stub!
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
