import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var fileTrashChannel: FlutterMethodChannel?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    fileTrashChannel = FlutterMethodChannel(
      name: "xji_footage_toolbox/file_trash",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    fileTrashChannel?.setMethodCallHandler { call, result in
      guard call.method == "moveToTrash" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let arguments = call.arguments as? [String: Any],
        let path = arguments["path"] as? String,
        !path.isEmpty
      else {
        result(FlutterError(
          code: "invalid_path",
          message: "A non-empty file path is required.",
          details: nil))
        return
      }

      do {
        var trashedURL: NSURL?
        try FileManager.default.trashItem(
          at: URL(fileURLWithPath: path),
          resultingItemURL: &trashedURL)
        result(nil)
      } catch let error as NSError {
        result(FlutterError(
          code: "trash_failed",
          message: error.localizedDescription,
          details: error.code))
      }
    }

    super.awakeFromNib()
  }
}
