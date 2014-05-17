%%
%% Author:
%%     Francois Fonteyn, 2014
%%

functor
import
   Application
   OS
   Tester at 'Tester.ozf'
define
   local
      Browse = Tester.browse
      Pid = {OS.getPID}
      proc {PreLevel ?Result}
         local
            Next1 Next2
         in
            Result = '#'(1:Next1 a:Next2)
            {Level1 1 '#'(1:Next1 a:Next2)}
         end
      end
      %% level 1
      proc {Level1 A ?Result}
         if A<CA then
            if A>4 then
               {Level2 2*A A Result}
            else
               {Level1 A+1 Result}
            end
         else
            Result.1 = nil
            Result.a = nil
         end
      end
      %% level 2
      proc {Level2 B A ?Result}
         if B=<CB then
            if A+B>5 then
               local
                  Rec = 1#2#3#4#5#6#7#8#9#10
               in
                  {Level3 record({Arity Rec} Rec) B A Result}
               end
            else
               {Level2 B+2 A Result}
            end
         else
            {Level1 A+1 Result}
         end
      end
      %% level 3
      proc {Level3 record(Arity1At3 Record1At3) B A ?Result}
         if Arity1At3 \= nil then
            local
               C = Record1At3.(Arity1At3.1)
            in
               local
                  Next
               in
                  if C == 3 then
                     local
                        Next1 Next2
                     in
                        Result.1 = A+B|Next1
                        Result.a = A|Next2
                        Next = '#'(1:Next1 a:Next2)
                     end
                  else
                     Next = Result
                  end
                  {Level3 record(Arity1At3.2 Record1At3) B A Next}
               end
            end
         else
            {Level2 B+2 A Result}
         end
      end
      CA = 100
      CB = 600
      fun {Measure LC}
         local M1 M2 L in
            if LC then
               %% LC
               M1 = {Tester.memory Pid} div 1000000
               L = [A+B a:A if A>0 suchthat A in 1 ; A<CA ; A+1 if A>4 suchthat B in 2*A..CB ; 2 if A+B>5 suchthat _:C in 1#2#3#4#5#6#7#8#9#10 if C == 3]
               M2 = {Tester.memory Pid} div 1000000
               {Browse {VirtualString.toAtom 'List comprehension added '#M2-M1#' extra MB'}}
            else
               %% Eq
               M1 = {Tester.memory Pid} div 1000000
               L = {PreLevel}
               M2 = {Tester.memory Pid} div 1000000
               {Browse {VirtualString.toAtom 'Equivalent         added '#M2-M1#' extra MB'}}
            end
            M2-M1
         end
      end
      proc {Apply}
         if @EQnocc == 10 then
            LCnocc := @LCnocc + 1
            LCtime := @LCtime + {Measure true}
         elseif @LCnocc == 10 then
            EQnocc := @EQnocc + 1
            EQtime := @EQtime + {Measure false}
         else
            if {OS.rand} mod 2 == 0 then
               LCnocc := @LCnocc + 1
               LCtime := @LCtime + {Measure true}
            else
               EQnocc := @EQnocc + 1
               EQtime := @EQtime + {Measure false}
            end
         end
      end
      LCtime = {NewCell 0}
      LCnocc = {NewCell 0}
      EQtime = {NewCell 0}
      EQnocc = {NewCell 0}
   in
      {Browse 'Each technique will be tried 10 times in a random order'}
      for _ in 1..20 do {Apply} end
      {Browse {VirtualString.toAtom 'List comprehensions added '#@LCtime#' extra MB in total'}}
      {Browse {VirtualString.toAtom 'Equivalents         added '#@EQtime#' extra MB in total'}}
      {Browse {VirtualString.toAtom 'The total memory taken at the end is '
               #{Tester.memory Pid} div 1000000#' MB'}}
      {Application.exit 0}
   end
end

