import BitcoinCore
import HsToolKit
import HdWalletKit

class Configuration {
    static let shared = Configuration()

    let enableLogger = false
    let testNet = false
    let purpose = Purpose.bip84
    let defaultWords = [
//        "current force clump paper shrug extra zebra employ prefer upon mobile hire",
        "lock basket subject color juice subject glide robot diet point note episode",
    ]

}
