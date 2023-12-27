//
//  UtilitiesFunction.swift
//  LoyalInfo Loyalhospitality
//
//  Created by DREAMWORLD on 21/03/22.
//  Copyright © 2022 iMac. All rights reserved.
//

import Foundation

func checkDateValid(selectedDate: Date, arrTimeSlot: [String], maximumDaySelection: Int) -> Bool {
    if arrTimeSlot.count > 0 {
        for day in 0..<maximumDaySelection+3 {
            for item in arrTimeSlot {
                let temp = item.split(separator: "-")
                let strFrom = "\(Date().addDay(numnerOfDay: day).getFormattedString(format: "dd-MM-yyyy")) \(temp[0].trimmingCharacters(in: .whitespacesAndNewlines))"
                let firstDate = strFrom.getDateFromString(format: "dd-MM-yyyy h:mm a")
                let strTo = "\(Date().addDay(numnerOfDay: day).getFormattedString(format: "dd-MM-yyyy")) \(temp[1].trimmingCharacters(in: .whitespacesAndNewlines))"
                var secondDate = strTo.getDateFromString(format: "dd-MM-yyyy h:mm a")
                print(firstDate)
                print(secondDate)
                if firstDate > secondDate {
                    secondDate = secondDate.addDay(numnerOfDay: 1)
                }
                if selectedDate.isBetween(firstDate, and: secondDate) {
                    print("Yes")
                    return true
                }
                else {
                    print("No")
                }
            }
            
        }
    }
    return false
    //"Minimum scheduled time is \(self.modelBrandDetail?.scheduleMinHours ?? "") hours and Maximum scheduled days are \(self.modelBrandDetail?.scheduleMaxDays ?? "") hours. Please change the time."
}

func getPercentageOutOf60(strMinutes: String) -> Float {
    let floatValue = Float(strMinutes) ?? Float()
    let per = ((floatValue*100)/60)*0.01
    return per
}

func getPercentageOutOfCount(count: Int, totalCount: Int) -> Float {
    let floatValue = Float(count) 
    let per = ((floatValue*100)/Float(totalCount))*0.01
    return per
}

func checkIsFile(urlString: String) -> Bool {
    if let url = URL(string: urlString) {
        let extensions = [".docx",".doc",".odt",".pdf",".rtf",".tex",".txt",".wpd",".atio"]
        
        for item in extensions {
            if url.lastPathComponent.contains(item)  {
                return true
            }
        }
    }
    return false
}

func getTimeDifferenceBetweenTwoTimeStamp(fromTime: String, toTime: String) -> String {
    let requestTime = Date(timeIntervalSince1970: TimeInterval(fromTime) ?? 0).localDate()
    let closedTime = Date(timeIntervalSince1970: TimeInterval(toTime) ?? 0).localDate()
    let calendar = Calendar.current
    let timeComponents = calendar.dateComponents([.day ,.hour, .minute, .second], from: requestTime)
    let nowComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: closedTime)
    let difference = calendar.dateComponents([.day, .hour, .minute, .second], from: timeComponents, to: nowComponents)
    return "\(difference.day ?? 0)d \(difference.hour ?? 0)h \(difference.minute ?? 0)m \(difference.second ?? 0)s"
}


func getTimeDifferenceFromCurrentTimeStamp(fromTime: String) -> String {
    let requestTime = Date(timeIntervalSince1970: TimeInterval(fromTime) ?? 0).localDate()
    let calendar = Calendar.current
    let timeComponents = calendar.dateComponents([.day ,.hour, .minute, .second], from: requestTime)
    let nowComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: Date().localDate())
    let difference = calendar.dateComponents([.day, .hour, .minute, .second], from: timeComponents, to: nowComponents)
    return "\(difference.day ?? 0)d \(difference.hour ?? 0)h \(difference.minute ?? 0)m \(difference.second ?? 0)s"
}

func coutDays(from start: Date, to end: Date) -> (weekendDays: [Date], workingDays: [Date]) {
    guard start < end else { return ([Date](),[Date]()) }
    var weekendDays = [Date]()
    var workingDays = [Date]()
    var date = start.noon
    repeat {
        if date.isDateInWeekend {
            weekendDays.append(date)
        } else {
            workingDays.append(date)
        }
        date = date.tomorrow
    } while date < end
    return (weekendDays, workingDays)
}

func dictionaryOfFilteredBy(dict: NSDictionary) -> NSDictionary {
    
    let replaced: NSMutableDictionary = NSMutableDictionary(dictionary : dict)
    let blank: String = ""
    
    for (key, _) in dict
    {
        let object = dict[key] as AnyObject
        
        if (object.isKind(of: NSNull.self))
        {
            replaced[key] = blank as AnyObject?
        }
        else if (object is [AnyHashable: AnyObject])
        {
            replaced[key] = dictionaryOfFilteredBy(dict: object as! NSDictionary)
        }
        else if (object is [AnyObject])
        {
            replaced[key] = arrayOfFilteredBy(arr: object as! NSArray)
        }
        else
        {
            replaced[key] = "\(object)" as AnyObject?
        }
    }
    return replaced
}


func arrayOfFilteredBy(arr: NSArray) -> NSArray {
    
    let replaced: NSMutableArray = NSMutableArray(array: arr)
    let blank: String = ""
    
    for i in 0..<arr.count
    {
        let object = arr[i] as AnyObject
        
        if (object.isKind(of: NSNull.self))
        {
            replaced[i] = blank as AnyObject
        }
        else if (object is [AnyHashable: AnyObject])
        {
            replaced[i] = dictionaryOfFilteredBy(dict: arr[i] as! NSDictionary)
        }
        else if (object is [AnyObject])
        {
            replaced[i] = arrayOfFilteredBy(arr: arr[i] as! NSArray)
        }
        else
        {
            replaced[i] = "\(object)" as AnyObject
        }
        
    }
    return replaced
}

func duplicateFileToDouments(fileDate: NSData, fileName: String) {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let videoURL = documentsURL.appendingPathComponent(fileName)
    
    do {
        try fileDate.write(to: videoURL)
    } catch {
        print("Couldn't create document directory")
    }
}

func getFileFromDocuments(fileName: String) -> URL?{
    
    let fileManager = FileManager.default
    let videoPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
    if fileManager.fileExists(atPath: videoPath){
        return URL(fileURLWithPath: videoPath)
    }else{
        print("No Video")
    }
    return nil
}
