//
//  Extensions.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/3/24.
//

import UIKit

// MARK: - UIColor
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

// MARK: - UIView
extension UIView {
    func addDropShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
        clipsToBounds = false
    }
}

// MARK: - UITableView
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type) -> T {
        let nibName = String(describing: cellClass)
        return dequeueReusableCell(withIdentifier: nibName) as? T ?? T()
    }
    
    func register(cells classArray: [UITableViewCell.Type]) {
        for cellClass in classArray {
            register(cellClass: cellClass)
        }
    }
    
    func register<T>(cellClass: T.Type) {
        let nibName = String(describing: cellClass)
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}

extension UITableView {
    func dequeueReusableHeaderFooterView<T: UIView>(cellClass: T.Type) -> T {
        let nibName = String(describing: cellClass)
        return dequeueReusableHeaderFooterView(withIdentifier: nibName) as? T ?? T()
    }
    
    func register(headerFooterViews: [UITableViewHeaderFooterView.Type]) {
        for headerFooterView in headerFooterViews {
            register(headerFooterViewClass: headerFooterView)
        }
    }
    
    func register<T: AnyObject>(headerFooterViewClass: T.Type) {
        let nibName = String(describing: headerFooterViewClass)
        let bundle = Bundle(for: headerFooterViewClass)
        
        if bundle.path(forResource: nibName, ofType: "nib") == nil {
            register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: nibName)
        } else {
            register(UINib(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: nibName)
        }
    }
}

// MARK: - UINavigationController
extension UINavigationController {

    func popViewController(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

// MARK: - UIColor
extension UIColor {
    var rgba: RGBColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return RGBColor(r: Int(red*255), g: Int(green*255), b: Int(blue*255))
    }
}

// MARK: - NSNotification
extension Notification.Name {
    static let updateCharacteristics = Notification.Name("CB.Characteristic.Update")
}
