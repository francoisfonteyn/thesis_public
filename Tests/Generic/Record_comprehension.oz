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
      C = {NewCell _}
      Tests = [%% each element is [recordComprehension]#[expectedRecord]
               %% add tests from here...
               (A suchthat _:A in Rec)     # Rec

               (F suchthat F:_ in Rec)     # rec(1:1 b:b c:c d:d)

               ([F A] suchthat F:A in Rec) # rec(1:[1 a] b:[b b] c:[c c] d:[d d])

               (1 suchthat _:A in Rec)     # rec(1:1 b:1 c:1 d:1)

               (F suchthat F:_ in rec(c:c b:b 1:a d:d)) # rec(1:1 b:b c:c d:d)

               ([F A] suchthat F:A in Rec) # rec(1:[1 a] b:[b b] c:[c c] d:[d d])

               (1 suchthat _:_ in Rec)     # rec(1:1 b:1 c:1 d:1)

               (F#A suchthat F:A in [1 2 3]) # (1#1|2#[2 3])

               (A suchthat _:A in [1 2 3])   # [1 2 3]
               
               (A suchthat _:A in 1#2#(3#4)#5) # (1#2#(3#4)#5)

               (A 1 suchthat _:A in Rec)       #  (Rec#rec(1:1 b:1 c:1 d:1))

               (F A suchthat F:A in Rec) # (rec(1:1 b:b c:c d:d)#Rec)

               (f:F a:A suchthat F:A in Rec) # '#'(f:rec(1:1 b:b c:c d:d) a:Rec)

               (A 1 suchthat _:A in Rec if A == a) # (rec(1:a)#rec(1:1))

               (F A suchthat F:A in Rec if F \= 1) # (rec(b:b c:c d:d)#rec(b:b c:c d:d))

               (A if A == a A if A == b suchthat _:A in Rec) # '#'(1:rec(1:a) 2:rec(b:b))

               (A if A == a A if A == b suchthat F:A in Rec if F == 1) # '#'(1:rec(1:a) 2:rec)

               (@C suchthat _:A in Rec do C := A) # Rec

                %% ...to here
              ]
   in
      {Tester.test Tests}
      {Application.exit 0}
   end
end