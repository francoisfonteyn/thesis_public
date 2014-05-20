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
      %% Equivalent
      proc {PreLevel ?Result}
         Result = {Record.make '#' [2 1 3]}
         local
            R = Rec
         in
            {Level {Label R} {Arity R} R ?Result}
         end
      end
      %% for2
      proc {For2 Ari Rec arities(2:Ari2 1:Ari1 3:Ari3) ?Result}
         if Ari \= nil then
            local
               F = Ari.1
               A = Rec.F
               Next1 Next2 Next3
            in
               if Ari2 \= nil andthen F == Ari2.1 then
                  Result.2.F = A+2
                  Next2 = Ari2.2
               else
                  Next2 = Ari2
               end
               if Ari1 \= nil andthen F == Ari1.1 then
                  Result.1.F = A+1
                  Next1 = Ari1.2
               else
                  Next1 = Ari1
               end
               if Ari3 \= nil andthen F == Ari3.1 then
                  Result.3.F = A+3
                  Next3 = Ari3.2
               else
                  Next3 = Ari3
               end
               {For2 Ari.2 Rec arities(2:Next2 1:Next1 3:Next3) ?Result}
            end
         end
      end
      %% for1
      proc {For1 Ari Rec ?NewAri ?arities(1:Ari1 2:Ari2 3:Ari3)}
         if Ari \= nil then
            local
               F = Ari.1
               A = Rec.F
               Next
               Next1 Next2 Next3
            in
               if F > 0 then
                  Ari1 = F|Next1
                  Ari2 = F|Next2
                  Ari3 = F|Next3
                  NewAri = F|Next
               else
                  Ari1 = Next1
                  Ari2 = Next2
                  Ari3 = Next3
                  NewAri = Next
               end
               {For1 Ari.2 Rec ?Next ?arities(1:Next1 2:Next2 3:Next3)}
            end
         else
            Ari1 = nil
            Ari2 = nil
            Ari3 = nil
            NewAri = nil
         end
      end
      %% level
      proc {Level Lbl Ari Rec ?Result}
         local
            Aris
            NewAri
            Next1 Next2 Next3
         in
            Aris = arities(1:Next1 2:Next2 3:Next3)
            {For1 Ari Rec ?NewAri ?Aris}
            Result.1 = {Record.make Lbl Next1}
            Result.2 = {Record.make Lbl Next2}
            Result.3 = {Record.make Lbl Next3}
            {For2 NewAri Rec Aris Result}
         end
      end
      Lim = 300000
      Rec = {Record.make label [A suchthat A in 1..Lim]}
      for I in 1..Lim do
         Rec.I = I
      end
      fun {Measure LC}
         local T1 T2 L in
            if LC then
               %% LC
               T1 = {Time.time}
               L = (2:A+2 1:A+1 3:A+3 suchthat F:A in Rec if F > 0)
               T2 = {Time.time}
               {Browse {VirtualString.toAtom 'List comprehension took '#T2-T1#' seconds'}}
            else
               %% Eq
               T1 = {Time.time}
               L = {PreLevel}
               T2 = {Time.time}
               {Browse {VirtualString.toAtom 'Equivalent         took '#T2-T1#' seconds'}}
            end
            T2-T1
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
      {Browse {VirtualString.toAtom 'List comprehensions took '#@LCtime#' seconds in total'}}
      {Browse {VirtualString.toAtom 'Equivalents         took '#@EQtime#' seconds in total'}}
      {Application.exit 0}
   end
end

