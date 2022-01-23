//
//  MyCodableViewController.swift
//  SwiftUnderTheHood
//
//  Created by Ilya Cherkasov on 22.01.2022.
//

import UIKit

final class MyCodableViewController: UIViewController {
    
    var testClass = Test()
    
    var testClassPointer: UnsafeMutableRawPointer {
        Unmanaged.passUnretained(testClass).toOpaque()
    }
    
    // Указатель на метаданные
    var metaPointer: UnsafeMutableRawPointer {
        let address = testClassPointer.load(as: Int.self)
        return swiftIntToPointer(Int64(address))!
        //или unsafeBitCast(Test.self, to: UnsafeMutableRawPointer.self))
    }
    
    //Счетчик ссылок
    var referenceCounter: Int {
        let ptr = testClassPointer + 8
        return ptr.load(as: Int.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ptr = testClassPointer + 16
        let metaClass = MyClassMetadata(ptr: metaPointer)
        metaClass.descriptor.fieldDescriptor.records.forEach { field in
            switch field.mangledTypeName {
            case "Si":
                typealias T = Int
                print("\(field.name): \(Int.self) = \(ptr.load(as: Int.self))")
            case "SS":
                print("\(field.name): \(String.self) = \(ptr.load(as: String.self))")
                ptr += 8
            case "Sd":
                print("\(field.name): \(Double.self) = \(ptr.load(as: Double.self))")
            case "Sf":
                print("\(field.name): \(Float.self) = \(ptr.load(as: Float.self))")
            default:
                break
            }
            ptr += 8
        }
        
        print("Битовое поле счетчика ссылок: \(referenceCounter)")
        
    }
    
    func adress(of object: UnsafeRawPointer) {
        print(String(format: "%p", Int(bitPattern: object)))
    }
    
}

