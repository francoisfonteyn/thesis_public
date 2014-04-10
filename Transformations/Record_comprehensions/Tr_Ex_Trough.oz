declare R1 R2 in
%% Big local
R2 =
local
   %% pre level
   proc {PreLevel ?Result}
      local
         Next1 Next2 Next3
      in
         Result = '#'(2:Next1 1:Next2 3:Next3)
         {Level r(r1(1 2 3) r2(4 5 6)) '#'(2:Next1 1:Next2 3:Next3)}
      end
   end
   %% for2
   proc {For2 Rec AriFull AriBool ?Result}
      if AriFull \= nil then
         if AriBool.1 then
            local
               Feat = AriFull.1
               Val = Rec.Feat
            in
               if {IsRecord Val} andthen true then
                  {Level Val '#'(2:Result.2.Feat 1:Result.1.Feat 3:Result.3.Feat)}
               else
                  Result.2.Feat = Val + 2
                  Result.1.Feat = Val + 1
                  Result.3.Feat = Val + 3
               end
            end
            {For2 Rec AriFull.2 AriBool.2 Result}
         else
            {For2 Rec AriFull   AriBool.2 Result}
         end 
      end
   end
   %% for1
   proc {For1 Ari Rec ?AriFull ?AriBool}
      if Ari \= nil then
         local
            Feat = Ari.1
            Val = Rec.Feat
            NextFull
            NextBool
         in
            AriBool = ({Not {IsRecord Val}} orelse {Label Val} \= r1)|NextBool
            AriFull = if AriBool.1 then Feat|NextFull else NextFull end
            {For1 Ari.2 Rec NextFull NextBool}
         end
      else
         AriFull = nil
         AriBool = nil
      end
   end
   %% level
   proc {Level Rec ?Result}
      local
         Ari = {Arity Rec}
         Lbl = {Label Rec}
         AriFull
         AriBool
      in
         {For1 Ari Rec AriFull AriBool}
         Result.2 = {Record.make Lbl AriFull}
         Result.1 = {Record.make Lbl AriFull}
         Result.3 = {Record.make Lbl AriFull}
         {For2 Rec AriFull AriBool Result}
      end
   end
in
   {PreLevel}
end
{Browse 'RecordComprehension'}{Browse R1}
{Browse 'Equivalent'}{Browse R2}
R1 = [2:A+2 1:A+1 3:A+3 for A through r(r1(1 2 3) r2(4 5 6)) if {Not {IsRecord A}} orelse {Label A} \= r1 of true]
