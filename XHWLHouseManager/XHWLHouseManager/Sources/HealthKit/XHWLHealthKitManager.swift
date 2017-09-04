//
//  XHWLHealthKitManager.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/31.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import HealthKit


//class XHWLHealthKitManager: NSObject {
//
//    let healthStore:HKHealthStore?
//    let HKVersion:Double = UIDevice.current.systemVersion as! Double
//    let CustomHealthErrorDomain:String = "com.sdqt.healthError"
//    
//    // 单例
//    class var sharedInstance: XHWLHealthKitManager {
//        struct Static {
//            static let instance = XHWLHealthKitManager()
//        }
//        return Static.instance
//    }
//    
////    (4)检查是否支持获取健康数据
//    /*
//     *  @brief  检查是否支持获取健康数据
//     */
//    func authorizeHealthKit(completion:((_ success:Bool, _ error:NSError)->())) {
//
//        if HKVersion >= 8.0 {
//            
//            if (! HKHealthStore.isHealthDataAvailable()) {
////                let error:NSError = NSError
//                
////                NSError *error = [NSError errorWithDomain: @"com.raywenderlich.tutorials.healthkit" code: 2 userInfo: [NSDictionary dictionaryWithObject:@"HealthKit is not available in th is Device"                                                                      forKey:NSLocalizedDescriptionKey]];
//                if (completion != nil) {
////                    completion(false, error);
//                }
//                return;
//            }
//            
//            
//            if (HKHealthStore.isHealthDataAvailable()) {
//                if(self.healthStore == nil) {
//                    self.healthStore = HKHealthStore()
//                }
//                /*
//                 组装需要读写的数据类型
//                 */
//                let writeDataTypes:NSSet = self.dataTypesToWrite()
//                let readDataTypes:NSSet = self.dataTypesRead()
//                
//                /*
//                 注册需要读写的数据类型，也可以在“健康”APP中重新修改
//                 */
//                self.healthStore?.requestAuthorization(toShare: writeDataTypes as! Set<HKSampleType>, read: readDataTypes as! Set<HKObjectType>, completion: { (success, error) in
//                    if completion != nil {
//                        
//                        NSLog(@"error->%@", error.localizedDescription);
//                        compltion (success, error);
//                    }
//                })
//            }
//        } else {
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:"iOS 系统低于8.0"                                                                      forKey:NSLocalizedDescriptionKey];
//            NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
//            compltion(0,aError);
//        }
//    }
//    
//    /*!
//     *  @brief  写权限
//     *  @return 集合
//     */
//    func dataTypesToWrite() -> NSSet {
//        
//        HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//        HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//        HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//        HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
//        
//        return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
//    }
//    
//    /*!
//     *  @brief  读权限
//     *  @return 集合
//     */
//    func dataTypesRead() -> NSSet {
//        
//        HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//        HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//        HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//        HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
//        HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
//        HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//        HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//        HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
//        
//        return [NSSet setWithObjects:heightType, temperatureType,birthdayType,sexType,weightType,stepCountType, distance, activeEnergyType,nil];
//    }
//    
//    
//    
//}
