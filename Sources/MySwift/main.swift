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
  // "https://www.youtube.com/channel/UCYfdidRxbB8Qhf0Nx7ioOYw"
  if #available(macOS 13.0, *) {
    let url = URL(filePath: "/Users/pcl/Documents/tmp/swift-package-test/yt.txt")
    let text = try? String(
      contentsOf: url,
      encoding: String.Encoding.utf8)
    // print("text: ", text!)
    // grep -shoP '\"videoId\":\".*?\"'
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
      print("item: ", item.components(separatedBy: "\"")[3])
    }
  }
}

func regextest2() {
  // "https://www.youtube.com/channel/UCYfdidRxbB8Qhf0Nx7ioOYw"
  if #available(macOS 13.0, *) {
    let url = URL(filePath: "/Users/pcl/Documents/tmp/swift-package-test/lW29PUBv4xE.txt")
    let text = try? String(
      contentsOf: url,
      encoding: String.Encoding.utf8)
    // grep -shoP '\\\"videoTitle\\\":\\\".*?\\\"'
    let regex = #/(\\"videoTitle\\":\\".*?\\")/#
    let matches = text!.matches(of: regex)
    print("matches.count: ", matches.count)
    print("matches[0].0: ", matches[0].0)
    let str1 = String(matches[0].0).components(separatedBy: "\\\"")[3]
    print("str1: ", str1)
  }
}

func regextest3() {
  // "https://www.youtube.com/channel/UCYfdidRxbB8Qhf0Nx7ioOYw"
  if #available(macOS 13.0, *) {
    let url = URL(
      filePath: "/Users/pcl/Documents/tmp/swift-package-test/UCYfdidRxbB8Qhf0Nx7ioOYw.txt")
    let text = try? String(
      contentsOf: url,
      encoding: String.Encoding.utf8)
    // grep -shoP '\"videoId\":\".*?\",\"thumbnail\".*?\"title\":{\"runs\":\[{\"text\":\".*?\"'
    let regex = #/("videoId":".*?","thumbnail".*?"title":\{"runs":\[\{"text":".*?")/#
    let matches = text!.matches(of: regex)
    print("matches.count: ", matches.count)
    // print("matches[0].0: ", matches[0].0)
    for item in matches {
      let videoId = String(item.0).components(separatedBy: "\",\"")[0].components(
        separatedBy: "\"videoId\":\"")[1]
      let title = String(item.0).components(separatedBy: "\"text\":\"")[1].dropLast()
      print("videoId: ", videoId)
      print("title: ", title)
    }
  }
}

func getJson2() {
  if #available(macOS 13.0, *) {
    let url = URL(
      filePath: "/Users/pcl/Documents/tmp/swift-package-test/UCYfdidRxbB8Qhf0Nx7ioOYw.txt")
    let text = try? String(
      contentsOf: url,
      encoding: String.Encoding.utf8)

    let json1 = text!.components(
      separatedBy: ">var ytInitialData = ")[1].components(
        separatedBy: ";</script><script nonce=\"")[0]
    let json2 = try? JSONSerialization.jsonObject(
      with: (json1.data(using: String.Encoding.utf8))!, options: [])
    let json3 =
      (((((json2 as! [String: Any])["contents"] as! [String: Any])[
        "twoColumnBrowseResultsRenderer"]
      as! [String: Any])["tabs"] as! [Any])[0] as! [String: Any])["tabRenderer"] as! [String: Any]
    // print("title: ", json3["title"]!)

    let contents =
      (((((((json3["content"] as! [String: Any])["richGridRenderer"] as! [String: Any])[
        "contents"]
      as! [Any])[0] as! [String: Any])["richSectionRenderer"] as! [String: Any])["content"]
      as! [String: Any])["richShelfRenderer"] as! [String: Any])["contents"] as! [Any]
    for item in contents {
      let json =
        (((item as! [String: Any])["richItemRenderer"] as! [String: Any])["content"]
        as! [String: Any])["videoRenderer"] as! [String: Any]
      print("videoId: ", json["videoId"]!)
      print(
        "title: ",
        (((json["title"] as! [String: Any])["runs"] as! [Any])[0] as! [String: Any])["text"]
          as! String)
    }
  }
}

func getYoutube() {
  let request = URLRequest(
    url: URL(string: "https://www.youtube.com/channel/UCYfdidRxbB8Qhf0Nx7ioOYw")!)
  let semaphore = DispatchSemaphore(value: 0)
  URLSession.shared.dataTask(with: request) { data, response, error in
    let htmlStr = String(data: data!, encoding: String.Encoding.utf8)!.replacingOccurrences(
      of: "\\x22", with: "\""
    ).replacingOccurrences(
      of: "\\x7b", with: "{"
    ).replacingOccurrences(of: "\\x7d", with: "}").replacingOccurrences(of: "\\x5b", with: "[")
      .replacingOccurrences(of: "\\x5d", with: "]").replacingOccurrences(of: "\\x3d", with: "=")
      .replacingOccurrences(of: "\\x27", with: "'").replacingOccurrences(of: "\\\\", with: "\\")
    // print("htmlStr: ", htmlStr)

    let json1 = htmlStr.components(
      separatedBy: ">var ytInitialData = ")[1].components(
        separatedBy: ";</script><script nonce=\"")[0]
    let json11 = String(String(json1.dropFirst()).dropLast())
    // print("json1: ", json11)

    if #available(macOS 13.0, *) {
      try? json11.write(
        to: URL(
          filePath: "/Users/pcl/Documents/tmp/swift-package-test/json11.json"),
        atomically: true, encoding: String.Encoding.utf8)
    } else {
      // Fallback on earlier versions
    }

    do {
      let json2 = try JSONSerialization.jsonObject(
        with: (json11.data(using: String.Encoding.utf8))!, options: [])

      let json3 =
        (((((json2 as! [String: Any])["contents"] as! [String: Any])[
          "singleColumnBrowseResultsRenderer"]
        as! [String: Any])["tabs"] as! [Any])[0] as! [String: Any])["tabRenderer"] as! [String: Any]
      print("title: ", json3["title"]!)

      let contents =
        (((((((json3["content"] as! [String: Any])["richGridRenderer"] as! [String: Any])[
          "contents"]
        as! [Any])[0] as! [String: Any])["richSectionRenderer"] as! [String: Any])["content"]
        as! [String: Any])["richShelfRenderer"] as! [String: Any])["contents"] as! [Any]
      for item in contents {
        let json =
          (((item as! [String: Any])["richItemRenderer"] as! [String: Any])["content"]
          as! [String: Any])["videoWithContextRenderer"] as! [String: Any]
        print("videoId: ", json["videoId"]!)
        print(
          "title: ",
          (((json["headline"] as! [String: Any])["runs"] as! [Any])[0] as! [String: Any])["text"]
            as! String)
      }

    } catch {
      print("error: ", error)
    }

    // singleColumnBrowseResultsRenderer, twoColumnBrowseResultsRenderer
    // videoWithContextRenderer, videoRenderer
    // headline, title

    semaphore.signal()
  }.resume()
  semaphore.wait()
}

func getAP() {
  let request = URLRequest(
    url: URL(string: "https://apnews.com/hub/ap-top-news")!)
  let semaphore = DispatchSemaphore(value: 0)
  URLSession.shared.dataTask(with: request) { data, response, error in
    let htmlStr = String(data: data!, encoding: String.Encoding.utf8)!.components(
      separatedBy: "window['titanium-state'] = ")[1].components(
        separatedBy: "window['titanium-cacheConfig']")[0]
    // print("htmlStr: ", htmlStr)

    // if #available(macOS 13.0, *) {
    //   try? htmlStr.write(
    //     to: URL(
    //       filePath: "/Users/pcl/Documents/tmp/swift-package-test/ap.json"),
    //     atomically: true, encoding: String.Encoding.utf8)
    // }

    let json2 = try! JSONSerialization.jsonObject(
      with: (htmlStr.data(using: String.Encoding.utf8))!, options: [])
    // print("json2: ", json2)

    let json3 =
      ((((json2 as! [String: Any])["hub"] as! [String: Any])["data"] as! [String: Any])[
        "/ap-top-news"] as! [String: Any])["cards"] as! [Any]
    // print("json3: ", json3)

    for item in json3 {
      print("publishedDate: ", (item as! [String: Any])["publishedDate"] as! String)
      print(
        "headline: ",
        (((item as! [String: Any])["contents"] as! [Any])[0] as! [String: Any])["headline"]
          as! String)
      print(
        "storyHTML: ",
        (((item as! [String: Any])["contents"] as! [Any])[0] as! [String: Any])["storyHTML"]
          as! String)
    }

    semaphore.signal()
  }.resume()
  semaphore.wait()
}

getAP()
