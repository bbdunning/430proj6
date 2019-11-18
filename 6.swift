//All Core Types are Subclasses of ExprC class
class ExprC {}

class NumC : ExprC {
    var n: Float
    init(n: Float) {
        self.n = n
    }
}

class StrC : ExprC {
    var s: String
    init(s: String) {
        self.s = s
    }
}

class IfC : ExprC {
    var test: ExprC
    var then: ExprC
    var els: ExprC

    init(test: ExprC, then: ExprC, els: ExprC) {
        self.test = test
        self.then = then
        self.els = els
    }
}

class IdC : ExprC {
    var s: String

    init(s: String) {
        self.s = s
    }
}

class AppC : ExprC {
    var f: ExprC
    var args: [ExprC]

    init(f: ExprC, args: [ExprC]) {
        self.f = f
        self.args = args
    }
}

class LamC : ExprC {
    var params: [ExprC]
    var body: ExprC

    init(params: [ExprC], body: ExprC) {
        self.params = params
        self.body = body
    }
}

//all Values are subclasses of Value type
class Value {}

class NumV : Value {
    var n : Float

    init(n: Float) {
        self.n = n
    }
}

class BoolV : Value {
    var b : Bool

    init(b: Bool) {
        self.b = b
    }
}

class StrV : Value {
    var s : String

    init(s: String) {
        self.s = s
    }
}

class CloV : Value {
    var params : [String]
    var body : ExprC
    var env : EnV

    init(params: [String], body: ExprC, env: EnV) {
    self.params = params
    self.body = body
    self.env = env
    }
}

class EnV {
    var l : [Binding]

    init(l: [Binding]) {
        self.l = l
    }
}

class Binding {
    var name : String
    var val : Value

    init(name: String, val: Value) {
        self.name = name
        self.val = val
    }
}

var hi = AppC(f: NumC(n: 5), args: [NumC(n: 10)])
print((hi.f as! NumC).n)