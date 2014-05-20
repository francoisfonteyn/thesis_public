%%
%% Author:
%%     Francois Fonteyn, 2014
%%

functor
import
   Application
   Tester at 'Tester.ozf'
define
   local
      Rec = rec(c:c b:b 1:a d:d)
      Tree = tree(tree(leaf(1) leaf(2)) leaf(3))
      OBTree = obtree(key:1 left:leaf right:obtree(key:2 left:leaf right:leaf))
      fun {Treat X} case X of rrr(N) then N*2 else X*2 end end
      fun {Bool X} {Label X} \= rrr end
      C = {NewCell _}
      Tests = [%% each element is [recordComprehension]#[expectedRecord]
               %% add tests from here...
               (A suchthat _:A in Rec)
               # Rec

               (F suchthat F:_ in Rec)
               # rec(1:1 b:b c:c d:d)

               ([F A] suchthat F:A in Rec)
               # rec(1:[1 a] b:[b b] c:[c c] d:[d d])

               (1 suchthat _:A in Rec)
               # rec(1:1 b:1 c:1 d:1)

               (1 suchthat _:_ in r(1 2 rr(3 rrr(4)) 5))
               # r(1 1 rr(1 rrr(1)) 1)

               (1 suchthat _:A in r(1 2 rr(3 rrr(4)) 5) of {Bool A})
               # r(1 1 rr(1 1) 1)

               (1 a:2 suchthat _:A in r(1 2 rr(3 rrr(4)) 5) of {Bool A})
               # '#'(1:r(1 1 rr(1 1) 1) a:r(2 2 rr(2 2) 2))

               (A+1 suchthat _:A in r(1 2 rr(3 rrr(4)) 5))
               # r(2 3 rr(4 rrr(5)) 6)

               (A+1 A-1 suchthat _:A in r(1 2 rr(3 rrr(4)) 5))
               # (r(2 3 rr(4 rrr(5)) 6)#r(0 1 rr(2 rrr(3)) 4))

               (A suchthat _:A in r(1 2 rr(3 rrr(4)) 5) if {Bool A})
               # r(1 2 rr(3) 5)

               ({Treat A} suchthat _:A in r(1 2 rr(3 rrr(4)) 5) of {Bool A})
               # r(2 4 rr(6 8) 10)

               (A suchthat F:A in r(1:bb(w(2)) 2:y(1) 3:w(2) 4:n(0) 5:rr(n(0) 6:w(2) 7:y(1) 8:y(1)) 9:rr(rrr(y(1) n(0))))
               of {Label A} \= bb orelse F > 3
                  if {Label A} \= w)
               # r(1:bb(w(2)) 2:y(1) 4:n(0) 5:rr(1:n(0) 7:y(1) 8:y(1)) 9:rr(rrr(y(1) n(0))))

               (A if A == yes suchthat _:A in rec(a:yes b:no c:yes rec:rec(a:no b:yes)))
               # rec(a:yes c:yes rec:rec(b:yes))

               (A if A > 4 suchthat _:A in r(r1(1 2 3) r2(4 5 6)) if {Label A} == r2)
               # r(2:r2(2:5 3:6))

               (F#A suchthat F:A in [1 2 3])
               # (1#1|1#2|1#3|2#nil)

               (F#A suchthat F:A in [1 2 3] of 1 == 0)
               # '|'(1#1 2#[2 3])

               (A suchthat _:A in Tree)
               # Tree

               (A+1 suchthat _:A in Tree)
               # tree(tree(leaf(2) leaf(3)) leaf(4))

               (F#A suchthat F:A in Tree)
               # tree(tree(leaf(1#1) leaf(1#2)) leaf(1#3))

               (F#A suchthat F:A in Tree of F == 1)
               # tree(tree(leaf(1#1) 2#leaf(2)) 2#leaf(3))

               (A suchthat F:A in Tree if F == 1)
               # tree(tree(leaf(1)))

               (@C suchthat _:A in Tree do C := A)
               # (Tree)

               (if F==key then N+1 else N end suchthat F:N in OBTree of F == left orelse F == right)
               # obtree(key:2 left:leaf right:obtree(key:3 left:leaf right:leaf))
               %% ...to here
              ]
   in
      {Tester.test Tests}
      {Application.exit 0}
   end
end
