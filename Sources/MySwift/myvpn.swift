import Foundation
import NetworkExtension

final class VPNHandler {

  let vpnManager = NEVPNManager.shared()

  func initVPNTunnelProviderManager() {

    print("CALL LOAD TO PREFERENCES...")
    self.vpnManager.loadFromPreferences { (error) -> Void in

      if (error) != nil {

        print("VPN Preferences error: 1")
      } else {

        let IKEv2Protocol = NEVPNProtocolIKEv2()

        IKEv2Protocol.username = "vpnUser.username"
        IKEv2Protocol.serverAddress = "vpnServer.serverID"  //server tunneling Address
        IKEv2Protocol.remoteIdentifier = "vpnServer.remoteID"  //Remote id
        IKEv2Protocol.localIdentifier = "vpnUser.localID"  //Local id

        IKEv2Protocol.deadPeerDetectionRate = NEVPNIKEv2DeadPeerDetectionRate.low
        IKEv2Protocol.authenticationMethod = NEVPNIKEAuthenticationMethod.none
        IKEv2Protocol.useExtendedAuthentication = true  //if you are using sharedSecret method then make it false
        IKEv2Protocol.disconnectOnSleep = false

        //Set IKE SA (Security Association) Params...
        IKEv2Protocol.ikeSecurityAssociationParameters.encryptionAlgorithm =
          NEVPNIKEv2EncryptionAlgorithm.algorithmAES256
        IKEv2Protocol.ikeSecurityAssociationParameters.integrityAlgorithm =
          NEVPNIKEv2IntegrityAlgorithm.SHA256
        IKEv2Protocol.ikeSecurityAssociationParameters.diffieHellmanGroup =
          NEVPNIKEv2DiffieHellmanGroup.group14
        IKEv2Protocol.ikeSecurityAssociationParameters.lifetimeMinutes = 1440
        //IKEv2Protocol.ikeSecurityAssociationParameters.isProxy() = false

        //Set CHILD SA (Security Association) Params...
        IKEv2Protocol.childSecurityAssociationParameters.encryptionAlgorithm =
          NEVPNIKEv2EncryptionAlgorithm.algorithmAES256
        IKEv2Protocol.childSecurityAssociationParameters.integrityAlgorithm =
          NEVPNIKEv2IntegrityAlgorithm.SHA256
        IKEv2Protocol.childSecurityAssociationParameters.diffieHellmanGroup =
          NEVPNIKEv2DiffieHellmanGroup.group14
        IKEv2Protocol.childSecurityAssociationParameters.lifetimeMinutes = 1440

        let kcs = KeychainService()
        //Save password in keychain...
        kcs.save(key: "VPN_PASSWORD", value: "vpnUser.password")
        //Load password from keychain...
        IKEv2Protocol.passwordReference = kcs.load(key: "VPN_PASSWORD")

        self.vpnManager.protocolConfiguration = IKEv2Protocol
        self.vpnManager.localizedDescription = "Safe Login Configuration"
        self.vpnManager.isEnabled = true

        self.vpnManager.isOnDemandEnabled = true
        //print(IKEv2Protocol)

        //Set rules
        var rules = [NEOnDemandRule]()
        let rule = NEOnDemandRuleConnect()
        rule.interfaceTypeMatch = NEOnDemandRuleInterfaceType.any
        rules.append(rule)

        print("SAVE TO PREFERENCES...")
        //SAVE TO PREFERENCES...
        self.vpnManager.saveToPreferences(completionHandler: { (error) -> Void in
          if (error) != nil {

            print("VPN Preferences error: 2")
          } else {

            print("CALL LOAD TO PREFERENCES AGAIN...")
            //CALL LOAD TO PREFERENCES AGAIN...
            self.vpnManager.loadFromPreferences(completionHandler: { (error) in
              if (error) != nil {
                print("VPN Preferences error: 2")
              } else {
                var startError: NSError?
                do {
                  //START THE CONNECTION...
                  try self.vpnManager.connection.startVPNTunnel()
                } catch let error as NSError {

                  startError = error
                  print(startError.debugDescription)
                } catch {

                  print("Fatal Error")
                  fatalError()
                }
                if (startError) != nil {
                  print("VPN Preferences error: 3")

                  //Show alert here
                  print(
                    "title: Oops.., message: Something went wrong while connecting to the VPN. Please try again."
                  )

                  print(startError.debugDescription)
                } else {
                  //self.VPNStatusDidChange(nil)
                  print("Starting VPN...")
                }
              }
            })
          }
        })
      }
    }  //END OF .loadFromPreferences //

  }

  //MARK:- Connect VPN
  static func connectVPN() {
    VPNHandler().initVPNTunnelProviderManager()
  }

  //MARK:- Disconnect VPN
  static func disconnectVPN() {
    VPNHandler().vpnManager.connection.stopVPNTunnel()
  }

  //MARK:- check connection staatus
  static func checkStatus() {

    let status = VPNHandler().vpnManager.connection.status
    print("VPN connection status = \(status.rawValue)")

    switch status {
    case NEVPNStatus.connected:

      print("Connected")

    case NEVPNStatus.invalid, NEVPNStatus.disconnected:

      print("Disconnected")

    case NEVPNStatus.connecting, NEVPNStatus.reasserting:

      print("Connecting")

    case NEVPNStatus.disconnecting:

      print("Disconnecting")

    default:
      print("Unknown VPN connection status")
    }
  }
}

//MARK:- Variables for keychain access

// Identifiers
let serviceIdentifier = "MySerivice"
let userAccount = "authenticatedUser"
let accessGroup = "MySerivice"

// Arguments for the keychain queries
var kSecAttrAccessGroupSwift = NSString(format: kSecClass)

let kSecClassValue = kSecClass as CFString
let kSecAttrAccountValue = kSecAttrAccount as CFString
let kSecValueDataValue = kSecValueData as CFString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as CFString
let kSecAttrServiceValue = kSecAttrService as CFString
let kSecMatchLimitValue = kSecMatchLimit as CFString
let kSecReturnDataValue = kSecReturnData as CFString
let kSecMatchLimitOneValue = kSecMatchLimitOne as CFString
let kSecAttrGenericValue = kSecAttrGeneric as CFString
let kSecAttrAccessibleValue = kSecAttrAccessible as CFString

class KeychainService: NSObject {

  func save(key: String, value: String) {

    let keyData: Data = key.data(
      using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
    let valueData: Data = value.data(
      using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!

    let keychainQuery = NSMutableDictionary()

    keychainQuery[kSecClassValue as! NSCopying] = kSecClassGenericPasswordValue
    keychainQuery[kSecAttrGenericValue as! NSCopying] = keyData
    keychainQuery[kSecAttrAccountValue as! NSCopying] = keyData
    keychainQuery[kSecAttrServiceValue as! NSCopying] = "VPN"
    keychainQuery[kSecAttrAccessibleValue as! NSCopying] = kSecAttrAccessibleAlwaysThisDeviceOnly
    keychainQuery[kSecValueData as! NSCopying] = valueData

    // Delete any existing items
    SecItemDelete(keychainQuery as CFDictionary)

    SecItemAdd(keychainQuery as CFDictionary, nil)
  }

  func load(key: String) -> Data {

    let keyData: Data = key.data(
      using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!

    let keychainQuery = NSMutableDictionary()

    keychainQuery[kSecClassValue as! NSCopying] = kSecClassGenericPasswordValue
    keychainQuery[kSecAttrGenericValue as! NSCopying] = keyData
    keychainQuery[kSecAttrAccountValue as! NSCopying] = keyData
    keychainQuery[kSecAttrServiceValue as! NSCopying] = "VPN"
    keychainQuery[kSecAttrAccessibleValue as! NSCopying] = kSecAttrAccessibleAlwaysThisDeviceOnly
    keychainQuery[kSecMatchLimit] = kSecMatchLimitOne
    keychainQuery[kSecReturnPersistentRef] = kCFBooleanTrue

    var result: AnyObject?

    let status = withUnsafeMutablePointer(to: &result) {
      SecItemCopyMatching(keychainQuery, UnsafeMutablePointer($0))
    }

    if status == errSecSuccess {

      if let data = result as! NSData? {

        if let value = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
          print(value)
        }
        return data as Data
      }
    }
    return "".data(using: .utf8)!
  }
}
