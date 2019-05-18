//
//  String_extention.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 01/01/2016.
//
//

public extension String {
    func rangesOfString(_ findStr:String) -> [Range<String.Index>] {
        var arr = [Range<String.Index>]()
        var startInd = self.startIndex
        // check first that the first character of search string exists
        if self.contains(findStr.first!) {
            // if so set this as the place to start searching
            startInd = self.firstIndex(of:findStr.first!)!
        }
        else {
            // if not return empty array
            return arr
        }
        var i = distance(from:self.startIndex, to:startInd)
        while i<=self.count-findStr.count {
            if self[self.index(self.startIndex, offsetBy:i)..<self.index(self.startIndex, offsetBy:i+findStr.count)] == findStr {
                let r = self.index(self.startIndex, offsetBy:i) ..< self.index(self.startIndex, offsetBy: i+findStr.count)
                arr.append(r)
                i = i+findStr.count
            }
            else {
                i += 1
            }
        }
        return arr
    }
    
    static func fromCString(ucstring:UnsafePointer<UInt8>) -> String {
        var ucstring_ = ucstring;
        var array : [Int8] = []
        while (ucstring_[0] != UInt8(ascii:"\0")){
            array.append(Int8(ucstring_[0]))
            ucstring_ = ucstring_.advanced(by:1)
        }
        array.append(Int8(0))
        let newstring = String(validatingUTF8:array)
        return newstring!
    }
    
    static func fromCString(string:UnsafeMutablePointer<Int8>)  -> String {
        var array : [Int8] = []
        var string_ = string
        while (UInt8(string_[0]) != UInt8(ascii:"\0")){
            array.append(Int8(string_[0]))
            string_ = string_.advanced(by:1)
        }
        array.append(Int8(0))
        let newstring = String(validatingUTF8:array)
        return newstring!
    }
    
}
