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
      %% pre level
      proc {PreLevel ?Result}
         Result = {Record.make '#' [2 1 3]}
         local
            Record1At1 = 10#20
         in
            {Level1 stacks({Arity Record1At1} {Record.toList Record1At1}) ?Result}
         end
      end
      %% level 1
      proc {Level1 record(Arity1At1 Record1At1) ?Result}
         if Arity1At1 \= nil then
            local
               FA = Arity1At1.1
               A = Record1At1.FA
            in
               local
                  Record1At2 = Rec
               in
                  {Level2 record({Arity Record1At2} Record1At2) FA A record(Arity1At1 Record1At1) Result}
               end
            end
         else
            Result.2 = nil
            Result.1 = nil
            Result.3 = nil
         end
      end
      %% level 2
      proc {Level2 record(Arity1At2 Record1At2) FA A record(Arity1At1 Record1At1) ?Result}
         if Arity1At2 \= nil then
            local
               B = Record1At2.(Arity1At2.1)
            in
               local
                  Next
               in
                  local
                     Next1 Next2 Next3
                  in
                     Result.2 = if A>10 then (FA#A)|Next1 else Next1 end
                     Result.1 = B|Next2
                     Result.3 = A#B|Next3
                     Next = '#'(2:Next1 1:Next2 3:Next3)
                  end
                  {Level2 record(Arity1At2.2 Record1At2) FA A record(Arity1At1 Record1At1) Next}
               end
            end
         else
            {Level1 record(Arity1At1.2 Record1At1) Result}
         end
      end
      Lim = 80000
      Rec = {Record.make label [A suchthat A in 1..Lim]}
      for I in 1..Lim do
         Rec.I = I
      end
      fun {Measure LC}
         local M1 M2 L in
            if LC then
               %% LC
               M1 = {Tester.memory Pid} div 1000000
               L = [FA#A if A>10 1:B A#B suchthat FA:A in 10#20 suchthat _:B in Rec]
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