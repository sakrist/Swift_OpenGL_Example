//
//  String_extention.swift
//  OpenGL_example
//
//  Created by Volodymyr Boichentsov on 01/01/2016.
//
//

public extension String {
    func rangesOfString(findStr:String) -> [Range<String.Index>] {
        var arr = [Range<String.Index>]()
        var startInd = self.startIndex
        // check first that the first character of search string exists
        if self.characters.contains(findStr.characters.first!) {
            // if so set this as the place to start searching
            startInd = self.characters.indexOf(findStr.characters.first!)!
        }
        else {
            // if not return empty array
            return arr
        }
        var i = self.startIndex.distanceTo(startInd)
        while i<=self.characters.count-findStr.characters.count {
            if self[self.startIndex.advancedBy(i)..<self.startIndex.advancedBy(i+findStr.characters.count)] == findStr {
                arr.append(Range(start:self.startIndex.advancedBy(i),end:self.startIndex.advancedBy(i+findStr.characters.count)))
                i = i+findStr.characters.count
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
            ucstring_ = ucstring_.advancedBy(1)
        }
        array.append(Int8(0))
        let newstring = String.fromCString(array)
        return newstring!
    }
    
    static func fromCString(string:UnsafeMutablePointer<Int8>)  -> String {
        var array : [Int8] = []
        var string_ = string
        while (UInt8(string_[0]) != UInt8(ascii:"\0")){
            array.append(Int8(string_[0]))
            string_ = string_.advancedBy(1)
        }
        array.append(Int8(0))
        let newstring = String.fromCString(array)
        return newstring!
    }
    
}
