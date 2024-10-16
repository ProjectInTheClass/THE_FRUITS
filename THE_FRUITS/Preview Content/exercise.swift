//
//  exercise.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/15/24.



func missionFn1(arg1:String, label arg2:Int)->String{
    return "mission success"
}//클로저 표현식으로

let missionFn1={(arg1:String,arg2:Int)-> String in
 "mission success"
}

func missionFn2(fn:(String,Int)->Int){
    let ret = fn("a",3)
    print("ret: ",ret)
}
//missionFn2 호출하는 코드

func paramFn0(arg1:String,arg2:Int)->Int{
    return 0
}

//missionFn2(fn:paramFn0)

func fn112(arg:(Int)->Int){
    let ret=arg(100)
    print(ret)
}

func param(arg:Int)->Int{
    return arg*2
}
//fn112(arg:param)

func run(){
    
    let mission1={(arg1:String,arg2:Int)->Int in
        return arg2+2
    }
    missionFn2(fn: mission1)
    
    let mission2={(arg:Int)->Int in
            return 2*arg
    }
    fn112(arg: mission2)
    
}
