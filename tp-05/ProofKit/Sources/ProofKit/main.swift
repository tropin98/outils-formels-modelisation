import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"


//

// etape 1
let f = a => b

// etape 2
let g = !(!a)
let h = !(a && b)
let i = !(a || b)

// etape 3
let q = a || (b && c)
let qq = (b && c) || a

let qqq = !(a || b) && (!c || !d)
let qqqq = a && b && c && d
let qqqqq = (a && b) || (c && d)

let dnf1 = a && (b || c)
let dnf2 = (b || c) && a


print(f, " ==> CNF ==> ", f.cnf)
print(g, " ==> CNF ==> ", g.cnf)
print(h, " ==> CNF ==> ", h.cnf)
print(i, " ==> CNF ==> ", i.cnf)
print(q, " ==> CNF ==> ", q.cnf)
print(qq, " ==> CNF ==> ", qq.cnf)
print(qqq, " ==> CNF ==> ", qqq.cnf)
print(qqqq, " ==> CNF ==> ", qqqq.cnf)
print(qqqqq, " ==> CNF ==> ", qqqqq.cnf)

print("------------------------------")

print(f, " ==> DNF ==> ", f.dnf)
print(g, " ==> DNF ==> ", g.dnf)
print(h, " ==> DNF ==> ", h.dnf)
print(i, " ==> DNF ==> ", i.dnf)
print(q, " ==> DNF ==> ", q.dnf)
print(qq, " ==> DNF ==> ", qq.dnf)
print(qqq, " ==> DNF ==> ", qqq.dnf)
print(qqqq, " ==> DNF ==> ", qqqq.dnf)
print(qqqqq, " ==> DNF ==> ", qqqqq.dnf)
print(dnf1, " ==> DNF ==> ", dnf1.dnf)
print(dnf2, " ==> DNF ==> ", dnf2.dnf)
