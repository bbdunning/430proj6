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
    var params: [String]
    var body: ExprC

    init(params: [String], body: ExprC) {
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

class Primop : Value {
    var op : String

    init(op: String) {
        self.op = op
    }
}

typealias EnV = [String:Value]

var topEnv: [String: Value] = 
    ["true": BoolV(b: true), 
     "+" : Primop(op:"+"),
     "-" : Primop(op:"-"),
     "*" : Primop(op:"*"),
     "/" : Primop(op:"/")]

func topInterp(e: ExprC) -> String {
    serialize(v:interp(e: e, env: topEnv))
}

func serialize(v: Value) -> String {
    switch v {
    case is NumV:
        let q = (v as! NumV)
        return String(q.n)
    case is BoolV:
        let q = (v as! BoolV)
        return String(q.b)
    case is StrV:
        let q = (v as! StrV)
        return String(q.s)
    default:
        return "bad"
    }
}

func interp(e: ExprC, env: EnV) -> Value {
    switch e {
    case is NumC:
        let n = (e as! NumC)
        return NumV(n: n.n)
    case is StrC:
        let s = (e as! StrC)
        return StrV(s: s.s)
    case is IdC:
        let i = (e as! IdC)
        return env[i.s]!
    case is LamC:
        let l = (e as! LamC)
        return CloV(params: l.params, body: l.body, env: env)
    case is AppC:
        let r = (e as! AppC)
        let f = interp(e:(e as! AppC).f, env:env)
        switch f {
        case is Primop:
            let p = (f as! Primop)
            let vals = r.args.map {interp(e:$0, env:env)}
            return evalPrimop(op:p.op, args:vals)
        case is CloV:
            let p = (f as! CloV)
            let vals = r.args.map {interp(e:$0, env:env)}
            return interp(e: p.body, 
                env: extendEnV(params:p.params, args: vals, env: env))
        default:
            return NumV(n: -1)
        }
    case is IfC:
        let r = (e as! IfC)
        let res = interp(e:r.test, env: env)
        if ((res is BoolV) && ((res as! BoolV).b)) {
            return interp(e: r.then, env: env)
        } else {
            return interp(e: r.els, env: env)
        }
    default:
        return NumV(n: -1)
    }
}

func extendEnV(params: [String], args: [Value], env: EnV) -> EnV {
    var newEnv = env
    for (param, arg) in zip(params, args) {
        newEnv[param] = arg
    }
    return newEnv
}


func evalPrimop(op: String, args: [Value]) -> Value {
    let a = (args[0] as! NumV).n
    let b = (args[1] as! NumV).n
    switch op {
    case "+":
        return NumV(n:a + b)
    case "*":
        return NumV(n:a * b)
    case "-":
        return NumV(n:a - b)
    case "/":
        return NumV(n:a / b)
    default:
        return NumV(n: -1)
    }
}

print(topInterp(e: (IdC(s:"true"))))
print(topInterp(e: AppC(f:IdC(s:"+"), args:[NumC(n:1), NumC(n:2)])))

print(topInterp(e: NumC(n: 10)))

var hi = AppC(f: NumC(n: 5), args: [NumC(n: 10)])

print(extendEnV(params:["hi"], args:[NumV(n:2)], env: topEnv))