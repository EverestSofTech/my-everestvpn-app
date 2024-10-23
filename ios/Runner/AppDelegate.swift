import Flutter
import TunnelKitOpenVPNAppExtension
import NetworkExtension
import TunnelKitCore
import TunnelKitManager
import TunnelKitOpenVPN
import UIKit
 


//import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  static var utils: VPNUtils! = VPNUtils()
  private var status: FlutterEventSink!
  private var stage: FlutterEventSink!
  private var initialized: Bool = false

  private var EVENT_CHANNEL_VPN_STAGE: String = "com.griddownllc.tunnelvpn/vpnstage"
  private var METHOD_CHANNEL_VPN_CONTROL: String = "com.griddownllc.tunnelvpn/vpncontrol"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //     if #available(iOS 10.0, *) {
    //   UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    // }
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let vpnControlM = FlutterMethodChannel(
      name: METHOD_CHANNEL_VPN_CONTROL, binaryMessenger: controller.binaryMessenger)
    let vpnStageE = FlutterEventChannel(
      name: EVENT_CHANNEL_VPN_STAGE, binaryMessenger: controller.binaryMessenger)
    vpnStageE.setStreamHandler(VPNConnectionHandler())
    vpnControlM.setMethodCallHandler({
      [self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "stage":
        result(AppDelegate.utils.currentStatus())
        break
      case "initialize":
        let providerBundleIdentifier: String? =
          (call.arguments as? [String: Any])?["providerBundleIdentifier"] as? String
        let localizedDescription: String? =
          (call.arguments as? [String: Any])?["localizedDescription"] as? String
        let groupIdentifier: String? =
          (call.arguments as? [String: Any])?["groupIdentifier"] as? String
        if providerBundleIdentifier == nil {
          result(
            FlutterError(
              code: "-2", message: "providerBundleIdentifier content empty or null", details: nil))
          return
        }
        if localizedDescription == nil {
          result(
            FlutterError(
              code: "-3", message: "localizedDescription content empty or null", details: nil))
          return
        }
        if groupIdentifier == nil {
          result(
            FlutterError(code: "-4", message: "groupIdentifier content empty or null", details: nil)
          )
          return
        }
        AppDelegate.utils.groupIdentifier = groupIdentifier
        AppDelegate.utils.localizedDescription = localizedDescription
        AppDelegate.utils.providerBundleIdentifier = providerBundleIdentifier
        AppDelegate.utils.loadProviderManager { (err: Error?) in
          if err == nil {
            result(AppDelegate.utils.currentStatus())
          } else {
            result(
              FlutterError(
                code: "-4", message: err.debugDescription, details: err?.localizedDescription))
          }
        }
        self.initialized = true
      case "stop":
        AppDelegate.utils.stopVPN()
        break
      case "start":
        let config: String? = (call.arguments as? [String: Any])?["config"] as? String
        let username: String? = (call.arguments as? [String: Any])?["username"] as? String
        let password: String? = (call.arguments as? [String: Any])?["password"] as? String
        if config == nil {
          result(
            FlutterError(
              code: "-1", message: "Config is empty or nulled", details: "Config can't be nulled"))
          return
        }

        AppDelegate.utils.configureVPN(
          config: config, username: username, password: password,
          completion: { (success: Error?) -> Void in
            if success == nil {
              result(nil)
            } else {
                result(
                    FlutterError(
                        code: "-5", message: success?.localizedDescription,
                        details: success.debugDescription))
            }
          })

        break
      case "dispose":
        self.initialized = false
      default:
        break

      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
 


  class VPNConnectionHandler: NSObject, FlutterStreamHandler {
    private var vpnConnection: FlutterEventSink?
    private var vpnConnectionObserver: NSObjectProtocol?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
      -> FlutterError?
    {
      // Remove existing observer if any
      if let observer = vpnConnectionObserver {
        NotificationCenter.default.removeObserver(observer)
      }

      vpnConnectionObserver = NotificationCenter.default.addObserver(
        forName: NSNotification.Name.NEVPNStatusDidChange, object: nil, queue: nil
      ) { [weak self] notification in
        guard let self = self, let connection = self.vpnConnection else {
          // Check if self or connection is nil and return early if that's the case
          return
        }

        let nevpnconn = notification.object as! NEVPNConnection
        let status = nevpnconn.status

        // Send the event using the eventSink closure
        connection(AppDelegate.utils.onVpnStatusChangedString(notification: status))
      }

      // Assign the eventSink closure to the vpnConnection variable
      self.vpnConnection = events

      NETunnelProviderManager.loadAllFromPreferences { managers, error in
        events(
          AppDelegate.utils.onVpnStatusChangedString(
            notification: managers?.first?.connection.status))
      }

      return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
      if let observer = vpnConnectionObserver {
        NotificationCenter.default.removeObserver(observer)
      }
      vpnConnection = nil

      return nil
    }
  }

}

@available(iOS 9.0, *)
class VPNUtils {
  var providerManager: NETunnelProviderManager!
  var providerBundleIdentifier: String?
  var localizedDescription: String?
  var groupIdentifier: String?
  var stage: FlutterEventSink!
  var status : FlutterEventSink!
  var vpnStatus: VPNStatus = .disconnected
  let keychain = Keychain(group: "group.com.griddownllc.tunnelvpn")
  var cfg: OpenVPN.ProviderConfiguration?
  let vpn = NetworkExtensionVPN()
  func loadProviderManager(completion: @escaping (_ error: Error?) -> Void) {
    NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
      if error == nil {
        self.providerManager = managers?.first ?? NETunnelProviderManager()
        completion(nil)
      } else {
        completion(error)
      }
    }
  }

  func onVpnStatusChanged(notification: VPNStatus) {
    switch notification {
    case VPNStatus.connected:
      stage?("connected")
      break
    case VPNStatus.connecting:
      stage?("connecting")
      break
    case VPNStatus.disconnected:
      stage?("disconnected")
      break
    case VPNStatus.disconnecting:
      stage?("disconnecting")
      break

    }
  }

  func onVpnStatusChangedString(notification: NEVPNStatus?) -> String? {
    if notification == nil {
      return "disconnected"
    }
    switch notification! {
    case NEVPNStatus.connected:
      return "connected"
    case NEVPNStatus.connecting:
      return "connecting"
    case NEVPNStatus.disconnected:
      return "disconnected"
    case NEVPNStatus.disconnecting:
      return "disconnecting"
    case NEVPNStatus.invalid:
      return "invalid"
    case NEVPNStatus.reasserting:
      return "reasserting"
    default:
      return ""
    }
  }

  func currentStatus() -> String? {
    if self.providerManager != nil {
      return onVpnStatusChangedString(notification: self.providerManager.connection.status)
    } else {
      return "disconnected"
    }
    //        return "DISCONNECTED"
  }

  func configureVPN(
    config: String?, username: String?, password: String?,
    completion: @escaping (_ error: Error?) -> Void
  ) {
      NotificationCenter.default.addObserver(  // Add notification observers to VPN manager
        self,
        selector: #selector(VPNStatusDidChange(notification:)),
        name: VPNNotification.didChangeStatus,
        object: nil
      )
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(VPNDidFail(notification:)),
        name: VPNNotification.didFail,
        object: nil
      )
      Task {
            await vpn.prepare()
      }
      
    self.providerManager?.loadFromPreferences { [self] error in
      if error == nil {
        let credentials = OpenVPN.Credentials(username!, password!)

        let result = try? OpenVPN.ConfigurationParser.parsed(fromContents: config!)
        if let config = result?.configuration {
          cfg = OpenVPN.ProviderConfiguration(
            localizedDescription!, appGroup: groupIdentifier!, configuration: config)
          cfg?.shouldDebug = true
          cfg?.debugLogPath = localizedDescription

        }
        let passwordReference: Data
        do {
          passwordReference = try keychain.set(
            password: credentials.password, for: credentials.username, context: providerBundleIdentifier!)
          cfg?.username = credentials.username
        } catch {
          print("Keychain failure: \(error)")
          return
        }
        if let config = cfg {
          Task {
            var extra = NetworkExtensionExtra()
            extra.passwordReference = passwordReference
            extra.disconnectsOnSleep = false
            try await vpn.reconnect(
            providerBundleIdentifier!,
              configuration: config,
              extra: extra,
              after: .seconds(2)
            )
          }

        }
        
      }
    }
  }
  @objc private func VPNStatusDidChange(notification: Notification) {
    vpnStatus = notification.vpnStatus
    print("VPNStatusDidChange: \(vpnStatus)")
      
    onVpnStatusChanged(notification: vpnStatus)
  }

  @objc private func VPNDidFail(notification: Notification) {
    print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
  }
  func stopVPN() {
    Task {
      await vpn.disconnect()
    }
  }
   
}
