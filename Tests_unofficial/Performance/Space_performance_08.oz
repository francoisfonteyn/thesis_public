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
      %% Equivalent
      proc {PreLevel ?Result}
         local
            Next1 Next2 Next3
         in
            Result = '#'(2:Next1 1:Next2 3:Next3)
            local
               Record = Rec
            in
               {Level {Arity Record}#Record '#'(2:Next1 1:Next2 3:Next3)}
            end
         end
      end
      %% for2
      proc {For2 Ari Rec Result AriBool}
         if Ari \= nil then
            if AriBool.1 then
               local
                  Feat = Ari.1
                  Field = Rec.Feat
               in
                  if {IsRecord Field} andthen {Arity Field} \= nil then
                     {Level {Arity Field}#Field '#'(2:Result.2.Feat 1:Result.1.Feat 3:Result.3.Feat)}
                  else
                     Result.2.Feat = Field + 2
                     Result.1.Feat = Field + 1
                     Result.3.Feat = Field + 3
                  end
               end
               {For2 Ari.2 Rec Result AriBool.2}
            else
               {For2 Ari Rec Result AriBool.2}
            end
         end
      end
      %% for1
      proc {For1 Ari Rec AriFull AriBool}
         if Ari \= nil then
            local
               Feat = Ari.1
               Field = Rec.Feat
               NextFull
               NextBool
            in
               AriBool = (Field>0)|NextBool
               AriFull = if AriBool.1 then Feat|NextFull else NextFull end
               {For1 Ari.2 Rec NextFull NextBool}
            end
         else
            AriFull = nil
            AriBool = nil
         end
      end
      %% level
      proc {Level Ari#Rec ?Result}
         local
            Lbl = {Label Rec}
            AriFull
            AriBool
         in
            {For1 Ari Rec AriFull AriBool}
            Result.2 = {Record.make Lbl AriFull}
            Result.1 = {Record.make Lbl AriFull}
            Result.3 = {Record.make Lbl AriFull}
            {For2 AriFull Rec Result AriBool}
         end
      end
      Lim = 100000
      Rec = {Record.make label [A suchthat A in 1..Lim]}
      for I in 1..Lim do
         Rec.I = I
      end
      fun {Measure LC}
         local M1 M2 L in
            if LC then
               %% LC
               M1 = {Tester.memory Pid} div 1000000
               L = (2:A+2 1:A+1 3:A+3 suchthat F:A in Rec if F > 0)
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
