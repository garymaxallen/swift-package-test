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

func3()

func func4() {
    //   var t:<UnsafeMutablePointer<tty>>?
    //   createPseudoTerminal(t)
    //   print("t.num1: ", t.num1)
}

// func4()

// my_c_func1()
