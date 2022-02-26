//
//  StatistikViewController.swift
//  Schuhe-der-Zukunft
//
//  Created by JS on 22.10.21.
//

import UIKit
import Shiny
import CoreBluetooth

class StatistikViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    

    
    @IBOutlet weak var containerView: ContainerView! {
        didSet {
            containerView.layer.shadowOpacity = 0.6
            containerView.layer.shadowColor = UIColor.gray.cgColor
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowRadius = 14
            containerView.layer.cornerRadius = 20
            containerView.addParallax()
        }
    }
    var schritteArduino : Int!
    var anzahlDerSchritte : Int = 0
    @IBOutlet weak var schritteLabel: UILabel! {
        didSet {
            
            
            if schritteArduino == nil {
                anzahlDerSchritte = 0
                
            } else {
                
                anzahlDerSchritte = schritteArduino
                
            }
            
            schritteLabel.attributedText = {
                let string = NSMutableAttributedString(string: "\(anzahlDerSchritte)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)])
                string.append(NSAttributedString(string: "  ", attributes: [.font: UIFont.systemFont(ofSize: 10)]))
                string.append(NSAttributedString(string: "Schritte", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
                return string
            }()
        }
    }
    
    
    @IBOutlet var SchrittlängeLabel: UILabel!{
        didSet {
    
            var schrittLängeArduino : Int!
            var schrittLänge : Int = 0
            
            if schrittLängeArduino == nil {
                schrittLänge = 0
            }
                else {
                    
                    schrittLängeArduino = schrittLänge
                         
            }
                
            
        
            SchrittlängeLabel.attributedText = {
                let string = NSMutableAttributedString(string: "\(schrittLänge) cm", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)])
                string.append(NSAttributedString(string: "  ", attributes: [.font: UIFont.systemFont(ofSize: 10)]))
                string.append(NSAttributedString(string: "Schrittlänge", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
                return string
            }()
        
        
        
        
        }
    }
    @IBOutlet weak var shinyView: ShinyView! {
        didSet {
            shinyView.layer.cornerRadius = 20
            shinyView.layer.masksToBounds = true
            shinyView.colors = [UIColor.brown, UIColor.gray, UIColor.gray, UIColor.brown].map { $0.withAlphaComponent(0.9) }
            shinyView.startUpdates()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
            imageView.tintColor = .background
        }
    }
    
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            
            let now = Date()
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let datetime = formatter.string(from: now)
            
            textLabel.attributedText = {
                let string = NSMutableAttributedString(string: "Heute,", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)])
                string.append(NSAttributedString(string: "  ", attributes: [.font: UIFont.systemFont(ofSize: 10)]))
                string.append(NSAttributedString(string: "\(datetime)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
                return string
            }()
        }
    }
    
 
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            
            print("Central is scanning for", serviceUUID)
            centralManager.scanForPeripherals(withServices: [serviceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
        
    }
    
    // The handler if we do connect succesfully
            func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
                if peripheral == self.peripheral {
                    print("Connected to your Particle Board")
                    peripheral.discoverServices([serviceUUID])
                }
            }
    
    // Handles discovery event
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let services = peripheral.services {
                for service in services {
                    if service.uuid == serviceUUID {
                        print("LED service found")
                        //Now kick off discovery of characteristics
                        peripheral.discoverCharacteristics([characteristicUUID], for: service)
                        return
                    }
                }
            }
        }
    
    // Handling discovery of characteristics
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.uuid == characteristicUUID {
                        print("ESP gefunden")
                        sendeCharakteristik = characteristic
                        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                            self.writeLEDValueToChar(withCharacteristic: self.sendeCharakteristik!, withValue: Data("Guten Morgen".utf8))
                        })
                    }
                }
            }
        }
    
    private func writeLEDValueToChar( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {

                // Check if it has the write property
                if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {

                    peripheral.writeValue(value, for: characteristic, type: .withoutResponse)

                }

            }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil
        // Start scanning again
                       print("Central scanning for", serviceUUID);
                       centralManager.scanForPeripherals(withServices: [serviceUUID],
                                                         options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    
    }
    
    private var serviceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    private var characteristicUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    private var sendeCharakteristik: CBCharacteristic?
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!



}



