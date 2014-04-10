%% Big local
local
   %% pre level
   proc {PreLevel ?Result}
      %% return one record when one output with no feature
      if {{ ReturnOneRecord }} then
         {Level {{ Initiator_Record }} '#'(1:Result)}
      else %% return record of records
         %% create the tuple of outputs
         local
            {{ Next_1 ... Next_N }}
         in
            Result = {{ '#'(field1:Next1 ... fieldN:NextN) }}
            %% call level with initiators and with the tuple
            {Level {{ Initiator_Record }} '#'(field1:Next1 ... fieldN:NextN)}
         end
      end
   end
   %% Level
   proc {Level Rec ?Result}
      local
         Ari = {Arity Rec}
         Lbl = {Label Rec}
         AriFull
         AriBool
      in
         {For1 Ari Rec AriFull AriBool}
         {{ ForAll Features F }}
            Result.F = {Record.make Lbl AriFull}
         {{ end ForAll }}
         {For2 Rec AriFull AriBool Result}
      end
   end
   %% For 1
   proc {For1 Ari Rec ?AriFull ?AriBool}
      if Ari \= nil then
         local
            {{ Feature Given By User Or New One }} = Ari.1
            {{ Value Given By User Or New One }} = Rec.{{ Feature Given By User Or New One }}
            NextFull
            NextBool
         in
            AriBool = {{ Filter }}|NextBool
            AriFull = if AriBool.1 then {{ Feature Given By User Or New One }}|NextFull
                      else NextFull
                      end
            {For1 Ari.2 Rec NextFull NextBool}
         end
      else
         AriFull = nil
         AriBool = nil
      end
   end
   %% For 2
   proc {For2 Rec AriFull AriBool ?Result}
      if AriFull \= nil then
         if AriBool.1 then
            local
               {{ Feature Given By User Or New One }} = AriFull.1
               {{ Value Given By User Or New One }} = Rec.{{ Feature Given By User Or New One }}
            in
               if {IsRecord {{ Value Given By User Or New One }}} andthen {{ Decider }} then
                  {Level {{ Value Given By User Or New One }}
                   '#'( {{ ForAll Feature F }}
                        F:Result.F.{{ Feature Given By User Or New One }}
                        {{ end ForAll }}
                      )
               else
                  {{ ForAll Feature F }}
                     Result.F.{{ Feature Given By User Or New One }} = {{ Output Expression F }}
                  {{ end ForAll }}
               end
            end
            {For2 Rec AriFull.2 AriBool.2 Result}
         else
            {For2 Rec AriFull   AriBool.2 Result}
         end 
      end
   end
end