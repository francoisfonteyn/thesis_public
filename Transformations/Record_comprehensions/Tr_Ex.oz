declare R1 R2 in
%% Big local
R2 =
local
   %% pre level
   proc {PreLevel ?Result}
      Result = {Record.make '#' [1 2]}
      local
         Rec = r(a:1 b:2 c:3 d:4 e:5 f:6)
      in
         {Level {Label Rec} {Arity Rec} Rec ?Result}
      end
   end
   %% for2
   proc {For2 Ari Rec arities(1:Ari1 2:Ari2) ?Result}
      if Ari \= nil then
         local
            F = Ari.1
            V = Rec.F
            Next1 Next2
         in
            {Browse body}
            if Ari1 \= nil andthen F == Ari1.1 then
               Result.1.F = V
               Next1 = Ari1.2
            else
               Next1 = Ari1
            end
            if Ari2 \= nil andthen F == Ari2.1 then
               Result.2.F = V
               Next2 = Ari2.2
            else
               Next2 = Ari2
            end
            {For2 Ari.2 Rec arities(1:Next1 2:Next2) ?Result}
         end
      end
   end
   %% for1
   proc {For1 Ari Rec ?NewAri ?arities(1:Ari1 2:Ari2)}
      if Ari \= nil then
         local
            F = Ari.1
            A = Rec.F
            Next
            Next1 Next2
         in
            if F \= f then
               Ari1 = if A =< 3 then F|Next1 else Next1 end
               Ari2 = if A >  3 then F|Next2 else Next2 end
               NewAri = F|Next
            else
               Ari1 = Next1
               Ari2 = Next2
               NewAri = Next
            end
            {For1 Ari.2 Rec ?Next ?arities(1:Next1 2:Next2)}
         end
      else
         Ari1 = nil
         Ari2 = nil
         NewAri = nil
      end
   end
   %% level
   proc {Level Lbl Ari Rec ?Result}
      local
         Aris
         NewAri
         Next1 Next2
      in
         Aris = arities(1:Next1 2:Next2)
         {For1 Ari Rec ?NewAri ?Aris}
         Result.1 = {Record.make Lbl Next1}
         Result.2 = {Record.make Lbl Next2}
         {For2 NewAri Rec Aris Result}
      end
   end
in
   {PreLevel}
end
%{Browse 'RecordComprehension'}{Browse R1}
{Browse 'Equivalent'}{Browse R2}
%R1 = (A if A =< 3 A if A > 3 suchthat F:A in r(a:1 b:2 c:3 d:4 e:5 f:6) if F \= 6 do {Browse body})
