%%
%% Author:
%%     Francois Fonteyn, 2014
%%

functor

import
   System(showInfo:Info)

export
   Return

define
   Return =
   listComprehensions([
      collect(proc{$}
         fun {Ext C B} {C 1} B end
      in
         [c:collect:C suchthat A in 1..2 do {C A}] = '#'(c:[1 2])

         [c:collect:C suchthat A in 1..2 if A == 1 do {C A}{C A+1}] = '#'(c:[1 2])

         [c:collect:C suchthat _ in 1..1 A from fun{$}1 end do {C A}{C A+1}] = '#'(c:[1 2])

         [c:collect:C suchthat _:A in r(r(r(1) r(2))) do {C A}] = '#'(c:[1 2])

         [c:collect:C suchthat A in 1..2 suchthat B in 3..4 do {C A+B}{C A*B}] = '#'(c:[4 3 5 4 5 6 6 8])

         [1:collect:C1 2:collect:C2 suchthat A in 1..2 do {C1 A}{C1 A*A}{C2 A+1}] = ([1 1 2 4]#[2 3])

         [1:collect:C1 2:A+1 suchthat A in 1..2 do {C1 A}{C1 A*A}] = ([1 1 2 4]#[2 3])

         [c:collect:C suchthat A in 1..3 if local skip in {C A} 0 == 1 end] = '#'(c:[1 2 3])

         [c:collect:C suchthat A in 1..3 if {Ext C false} do {C A}] = '#'(c:[1 1 1])

         [c:collect:C suchthat A in 1..3 if {Ext C true} do {C A}] = '#'(c:[1 1 1 2 1 3])
      end
      keys:[listComprehensions collect])

      collectLazy(proc{$}
         fun {LazyAssert TestResult Expected Batch}
            N = {Length Expected}
            NB = N div Batch
            Okay
         in
            for I in 1..NB break:B do
               if {IsDet {Nth TestResult I*Batch}} then
                  {Info 'Lazy error'}
                  Okay = unit
                  {B}
               end
               for J in 1+(I-1)*Batch..I*Batch do
                  Exp1 = {Nth TestResult J}
                  Exp2 = {Nth Expected J}
               in
                  Exp1 = Exp2
               end
            end
            {Not {IsDet Okay}}
         end
         L1 = thread [c:collect:C suchthat lazy A in 1..2 do {C A}] end
         L2 = thread [c:collect:C suchthat lazy A in 1..2 do {C A}{C A+1}] end
         L3a = thread [1:collect:C1 2:collect:C2 suchthat lazy A in 1..2 do {C1 A}{C2 A+1}] end
         L3b = thread [1:collect:C1 2:collect:C2 suchthat lazy A in 1..2 do {C1 A}{C2 A+1}] end
         L4 = thread [c:collect:C suchthat lazy A in 1..2 suchthat B in 3..4 do {C A+B}] end
         L5 = thread [c:collect:C suchthat A in 1..2 suchthat lazy B in 3..4 do {C A+B}] end
         L6a = thread [1:collect:C1 2:collect:C2 suchthat lazy A in 1..2 suchthat B in 3..4 do {C1 A}{C2 B}] end
         L6b = thread [1:collect:C1 2:collect:C2 suchthat lazy A in 1..2 suchthat B in 3..4 do {C1 A}{C2 B}] end
         L7a = thread [1:collect:C1 2:collect:C2 suchthat lazy A in 1..2 suchthat lazy B in 3..4 do {C1 A}{C2 B}] end
         L7b = thread [1:collect:C1 2:collect:C2 suchthat lazy A in 1..2 suchthat lazy B in 3..4 do {C1 A}{C2 B}] end
         C = {NewCell _}
      in
         {Delay 50}
         if {LazyAssert L1.c [1 2] 1} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L2.c [1 2 2 3] 2} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L3a.1 [1 2] 1} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L3b.2 [2 3] 1} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L4.c [4 5 5 6] 2} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L5.c [4 5 5 6] 1} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L6a.1 [1 1 2 2] 2} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L6b.2 [3 4 3 4] 2} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L7a.1 [1 1 2 2] 1} then C := 1 else C := 0 end @C = 1
         if {LazyAssert L7b.2 [3 4 3 4] 1} then C := 1 else C := 0 end @C = 1
      end
      keys:[listComprehensions collectLazy])
   ])
end
