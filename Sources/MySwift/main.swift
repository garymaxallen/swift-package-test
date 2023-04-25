import Foundation
import MyC

func func1() {
  print("++++++++++++++++++ Hello, world +++++++++++++++++++++++++")

  let p1 = tty(num1: 3, num2: 8)
  print("Hello, world!", p1.num1, p1.num2)
}

// func1()

func func2() {
  let t = tty(num1: 3, num2: 8)
  my_c_func3(t)
  print("t.num1: ", t.num1)
}

// func2()

func func3() {
  var t = tty(num1: 3, num2: 8)
  my_c_func2(&t)
  print("t.num1: ", t.num1)
}

// func3()

func func4() {
  print()
  print("func4()")
  let pp = UnsafeMutablePointer<UnsafeMutablePointer<tty>?>.allocate(capacity: 1)
  // must print pp here, very strange
  // print("pp: ", pp)
  // print("pp.pointee: ", pp.pointee!)
  // print("pp.pointee?.pointee: ", (pp.pointee?.pointee)!)
  // pp.pointee?.initialize(to: tty(num1: 3, num2: 8))
  pp.initialize(to: UnsafeMutablePointer<tty>.allocate(capacity: 1))
  // print("pp: ", pp)

  // print("pp.pointee address: ", Unmanaged<AnyObject>.passUnretained(pp.pointee as AnyObject).toOpaque())
  // print("pp address: ", Unmanaged<AnyObject>.passUnretained(pp as AnyObject).toOpaque())

  createPseudoTerminal(pp)

  print("pp.pointee?.pointee.num1: ", (pp.pointee?.pointee.num1)!)
  print("pp.pointee?.pointee.num2: ", (pp.pointee?.pointee.num2)!)
}

// func4()

func func6() {
  print()
  print("func6()")
  var str: String = "foo"
  // withUnsafePointer(to: &str) { NSLog("\($0)") }
  withUnsafePointer(to: &str) { print("&str:", "\($0)") }
  withUnsafePointer(to: &str) { print("\($0)") }
  withUnsafePointer(to: &str) { print("\($0)") }
}

// func6()

// my_c_func1()

func func5() {
  print()
  print("func5()")
  let arr = [1, 5, 7, 8]

  let pointer = UnsafeMutablePointer<[Int]>.allocate(capacity: 4)
  print("pointer: ", pointer)
  print(
    "pointer.pointee address: ",
    Unmanaged<AnyObject>.passUnretained(pointer.pointee as AnyObject).toOpaque())
  print("arr address: ", Unmanaged<AnyObject>.passUnretained(arr as AnyObject).toOpaque())
  pointer.initialize(to: arr)
  print("pointer: ", pointer)

  for item in pointer.pointee {
    print("item: ", item)
    print("item address: ", Unmanaged<AnyObject>.passUnretained(item as AnyObject).toOpaque())
  }

  // pointer.deinitialize(count: 1)
  pointer.deallocate()

  class A {
    var x: String?

    convenience init(_ x: String) {
      self.init()
      self.x = x
    }

    func description() -> String {
      return x ?? ""
    }
  }

  print()
  let arr2 = [A("OK"), A("OK 2")]
  let pointer2 = UnsafeMutablePointer<[A]>.allocate(capacity: 2)
  print("pointer2: ", pointer2)
  pointer2.initialize(to: arr2)

  for item in pointer2.pointee {
    print("item: ", item.description())
  }

  // pointer2.deinitialize(count: 1)
  pointer2.deallocate()
}

// func5()

// my_c_func4()

func func7() {
  let ptr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
  print("ptr: ", ptr)
  print(
    "UnsafeMutablePointer<Int>.allocate(capacity: 1): ",
    UnsafeMutablePointer<Int>.allocate(capacity: 1))

  let ptr2 = UnsafePointer<Int>.init(bitPattern: 1)
  print("ptr2: ", ptr2!)

  let ptr3 = UnsafePointer<fd>.init(bitPattern: 1)
  print("ptr3: ", ptr3!)
}

// func7()

func regextest() {
  // if #available(macOS 13.0, *) {
  //   let keyAndValue = #/(.+?): (.+)/#
  //   // let simpleDigits = try? Regex("[0-9]+")
  //   let setting = "color: 161 103 230"
  //   // if setting.contains(simpleDigits!) {
  //   //   print("'\(setting)' contains some digits.")
  //   // }
  //   if let match = setting.firstMatch(of: keyAndValue) {
  //     print("Key: \(match.1)")
  //     print("Value: \(match.2)")
  //   }
  // } else {
  //   // Fallback on earlier versions
  // }

  if #available(macOS 13.0, *) {
    let url = URL(filePath: "/Users/pcl/Documents/tmp/swift-package-test/yt.txt")
    let text = try? String(
      contentsOf: url,
      encoding: String.Encoding.utf8)
    // print("text: ", text!)
    // let regex = #/"videoId":"ticu81_VQ0Q"/#
    let regex = #/("videoId":".+?")/#
    let matches = text!.matches(of: regex)
    var myset = Set<String>()
    for i in (0...matches.count - 1) {
      let str = matches[i].0
      myset.insert(String(str))
      // print("matches[%d].0: ", i, str)
    }
    print("myset.count: ", myset.count)
    for item in myset {
      print("item: ", item)
    }
  }
}

regextest()
