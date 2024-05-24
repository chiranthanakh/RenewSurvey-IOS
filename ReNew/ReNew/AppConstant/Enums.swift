//
//  Enums.swift
//  Kitchens@ Business
//
//  Created by Loyal Hospitality on 18/10/22.
//

import UIKit

class Enums: NSObject {

}


enum UserRole {
    case User
    case Member
}

enum OrderCancellationType {
    case Aggregator
    case Merchant
}

enum TimeDuration {
    case Today
    case Yesterday
    case Daywise
    case Weekwise
    case Monthly
    case Days30
    case Days7
    case Datewise
}

enum DeliveryType {
    case All
    case HD
    case TA
}



enum SideMenuOption {
    case Profile
    case Notification
    case Sync
    case AddNewProject
    case ChangePassword
    case LogOut
    
    var strTitle : String {
        switch self {
        case .Profile:
            return "Profile"
        case .Notification:
            return "Notification"
        case .AddNewProject:
            return "Add New Project"
        case .ChangePassword:
            return "Change Password"
        case .LogOut:
            return "Logout"
        case .Sync:
            return "Sync"
        }
    }
    
    var igmIcon : UIImage {
        switch self {
        case .Profile:
            return UIImage(systemName: "person.crop.circle")!
        case .Notification:
            return UIImage(systemName: "bell.fill")!
        case .AddNewProject:
            return UIImage(systemName: "person.fill.badge.plus")!
        case .ChangePassword:
            return UIImage(systemName: "lock.fill")!
        case .LogOut:
            return UIImage(named: "ic_LogOut")!
        case .Sync:
            return UIImage(systemName: "arrow.triangle.2.circlepath")!
        }
    }
    
}

enum SortingType {
    case Ascending
    case Descending
}

enum CompanySelectionType {
    case HourlyC
    case MWC
}

/*enum WeekDays {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var index : Int {
        switch self {
        case .Sunday :
            return 0
        case .Monday :
            return 1
        case .Tuesday :
            return 2
        case .Wednesday :
            return 3
        case .Thursday :
            return 4
        case .Friday :
            return 5
        case .Saturday :
            return 6
        }
    }
    
    var title : String {
        switch self {
        case .Sunday :
            return "Sunday"
        case .Monday :
            return "Monday"
        case .Tuesday :
            return "Tuesday"
        case .Wednesday :
            return "Wednesday"
        case .Thursday :
            return "Thursday"
        case .Friday :
            return "Friday"
        case .Saturday :
            return "Saturday"
        }
    }
}*/


enum ChartType {
    case Count
    case Amount
    case Percentage
    case Unit
    case ConsKG
    case Consumption
}

enum WatertType {
    case Ro
    case Normal
}

enum TextfeildPickerView {
    case TWC
    case DWC
    case MWC
    case HourlyC
}

enum BrandType {
    case Cok
    case Bok
    case All
    
    var strValue : String {
        switch self {
        case .All :
            return "all"
        case .Cok :
            return "cok"
        case .Bok:
            return "bok"
        }
    }
    
    var intValue : Int {
        switch self {
        case .All :
            return 0
        case .Cok :
            return 1
        case .Bok:
            return 2
        }
    }
    
}

enum OrderStatus {
    case Running
    case FoodCourt
    case Deliverd
}

enum AggregatorType {
    case All
    case Kitchens
    case Zomato
    case Dunzo
    case Swiggy
    case Amazon
    case Dot
    case Tipplr
    case PickUp
    
    var strValue : String {
        switch self {
        case .All :
            return "all"
        case .Kitchens :
            return "kitchens"
        case .Zomato:
            return "zomato"
        case .Dunzo :
            return "dunzo"
        case .Swiggy:
            return "swiggy"
        case .Amazon :
            return "amazon"
        case .Dot:
            return "dot"
        case .Tipplr:
            return "Tipplr"
        case .PickUp:
            return "pickup"
        }
    }
    
}

enum CompanyFilter {
    case Entitywise
    case Brandwise
}

enum FreezedType {
    case Outlet
    case Brand
}

enum CFMSApproveType {
    case Expense
    case Income
    case BankTransfer
}

enum OperationalType {
    case All
    case Operational
    case NotOperational
}

enum AttendanceReportType {
    case Report
    case CheckInReport
    case Approval
    case TeamAttendance
    case AttRegularizationApproval
    case MarkAttendance
    case MarkAttendanceReportingManager
    case AttendanceForMonthReport
   
    
    var strValue : String {
        switch self {
        case .Report:
            return "REPORT"
        case .CheckInReport:
            return "CHECK IN REPORT"
        case .Approval:
            return "APPROVAL"
        case .TeamAttendance:
            return "TEAM ATTENDANCE"
        case .AttRegularizationApproval:
            return "ATT. REGULARIZATION APPROVAL"
        case .MarkAttendance:
            return "MARK ATTENDANCE"
        case .MarkAttendanceReportingManager:
            return "MARK ATTENDANCE REOPRTING MANAGER"
        case .AttendanceForMonthReport:
            return "ATTENDANCE FOR MONTH REPORT"
        }
    }
    
}

enum ProfileDetail {
    case Mobile
    case DOB
    case CelebratingDOB
    case Email
    case OfficialEmail
    case FatherName
    case Address
    case PinCode
    case PresentAddress
    case PresentPinCode
    case PanNo
    case AdhaarCard
    case Uan
    case BankName
    case AccountNo
    case IFSC
    case Insurance
    case PfNumber

    
    var strValue : String {
        switch self {
        case .Mobile:
            return "Mobile"
        case .DOB:
            return "Date Of Birth"
        case .CelebratingDOB:
            return "Celebrating Date Of Birth"
        case .Email:
            return "Email"
        case .OfficialEmail:
            return "Official Email"
        case .FatherName:
            return "Father Name"
        case .Address:
            return "Address"
        case .PinCode:
            return "Pin Code"
        case .PresentAddress:
            return "Present Address"
        case .PresentPinCode:
            return "Present Pin Code"
        case .PanNo:
            return "Pan No"
        case .AdhaarCard:
            return "Adhaar Card"
        case .Uan:
            return "Uan"
        case .BankName:
            return "Bank Name"
        case .AccountNo:
            return "Account No"
        case .IFSC:
            return "IFSC"
        case .Insurance:
            return "Insurance"
        case .PfNumber:
            return "PF Numnber"
        }
    }
    
}

enum TaskType {
    case Created
    case Assigned
    case Finished
}

enum ReimbursementCategoryType {
    case Section
    case Category
    case Subcategory
}

enum TicketStatusType {
    case Close
    case Resolve
    case Reopening
    case Verify
    case Acknowledge
}
