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

var hi = AppC(f: NumC(n: 5), args: [NumC(n: 10)])
print((hi.f as! NumC).n)