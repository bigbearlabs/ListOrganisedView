import Cocoa



extension NSView {
  
  var onDoubleClick: (() -> ())? {
    get {
      let rs = self.gestureRecognizers.compactMap { $0 as? DoubleClickGestureRecognizer }
      if let r = rs.first {
        return r.closureHolder.onAction
      }
      return nil
    }
    set {
      guard let onDoubleClick = newValue else { return }
      
      let recogniser = DoubleClickGestureRecognizer(onAction: onDoubleClick)
      
      self.gestureRecognizers =
        self.gestureRecognizers.filter { !($0 is DoubleClickGestureRecognizer) }
        + [ recogniser ]
    }
  }
  
  
  class DoubleClickGestureRecognizer: NSClickGestureRecognizer {
    
    let closureHolder: ClosureHolder
    
    init(onAction: @escaping () -> ()) {
      let closureHolder = ClosureHolder(onAction: onAction)
      self.closureHolder = closureHolder
      super.init(target: nil, action: #selector(actionInvoked(_:)))
      
      self.numberOfClicksRequired = 1
      self.delaysPrimaryMouseButtonEvents = false
    }
    
    override func mouseDown(with event: NSEvent) {
      super.mouseDown(with: event)
      
      if event.clickCount == 2 {
        self.closureHolder.onAction()
      }
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction
    private func actionInvoked(_ sender: Any?) {
      // this is a stub;
      // in order to handle double clicks we needed to override #mouseDown.
    }
    
    
    class ClosureHolder {
      
      let onAction:  () -> ()
      
      init(onAction: @escaping () -> ()) {
        self.onAction = onAction
      }
      
    }
    
  }
  
}
