%% Big local
local
   %% pre level
   proc {PreLevel ?Result}
      local
         Rec = {{ Initiator_Record }}
      in
         %% return one record when one output with no feature
         if {{ ReturnOneRecord }} then
            {Level {Label Rec} {Arity Rec} Rec '#'(1:Result)}
         else %% return record of records
            %% create the tuple of outputs
            Result = {Record.make '#' [field1 ... fieldN]}
            %% call level with initiators and with the tuple
            {Level {Label Rec} {Arity Rec} Rec Result}
         end
      end
   end
   %% Level
   proc {Level Lbl Ari Rec ?Result}
      local
         Aris
         NewAri
         {{ Next1 ... NextN }}
      in
         Aris = arities({{ 1:Next1 ... N:NextN }})
         {For1 Ari Rec ?NewAri ?Aris}
         {{ ForAll Features F }}
            Result.F = {Record.make Lbl NextF}
         {{ end ForAll }}
         {For2 NewAri Rec Aris Result}
      end
   end
   %% For 1
   proc {For1 Ari Rec ?NewAri ?arities({{ 1:Ari1 ... N:AriN }})}
      if Ari \= nil then
         local
            {{ FeatureGivenByUserOrNewOne }} = Ari.1
            {{ ValueGivenByUserOrNewOne }} = Rec.{{ FeatureGivenByUserOrNewOne }}
            Next
            {{ Next1 ... NextN }}
         in
            if {IsRecord {{ ValueGivenByUserOrNewOne }}}
               andthen {Arity {{ ValueGivenByUserOrNewOne }}} \= nil
               andthen {{ ConditionIfAny }} then
               %% recursive
               if {{ FILTER }} then
                  {{ ForAll Features F }}
                     AriF = {{ FeatureGivenByUserOrNewOne }}|NextF
                  {{ end ForAll }}
                  NewAri = {{ FeatureGivenByUserOrNewOne }}|Next
               else
                  {{ ForAll Features F }}
                     AriF = NextF
                  {{ end ForAll }}
                  NewAri = Next
               end
            else
               %% leaf
               {{ ForAll Features F }}
                  AriF = if {{ ConditionF }} then
                            {{ FeatureGivenByUserOrNewOne }}|NextF
                         else NextF
                         end
               {{ end ForAll }}
               NewAri = {{ FeatureGivenByUserOrNewOne }}|Next
            end
            {For1 Ari.2 Rec ?Next ?arities({{ 1:Next1 ... N:NextN }})}
         end
      else
         {{ ForAll Features F }}
            AriF = nil
         {{ end ForAll }}
         NewAri = nil
      end
   end
   %% For 2
   proc {For2 Ari Rec arities({{ 1:Ari1 ... N:AriN }}) ?Result}
      if Ari \= nil then
         local
            {{ FeatureGivenByUserOrNewOne }} = Ari.1
            {{ ValueGivenByUserOrNewOne }} = Rec.{{ FeatureGivenByUserOrNewOne }}
            {{ Next1 ... NextN }}
         in
            if {IsRecord {{ ValueGivenByUserOrNewOne }}}
               andthen {Arity {{ ValueGivenByUserOrNewOne }}} \= nil
               andthen {{ ConditionIfAny }} then
               %% recursive
               {Level
                {Label {{ ValueGivenByUserOrNewOne }}}
                {Arity {{ ValueGivenByUserOrNewOne }}}
                {{ ValueGivenByUserOrNewOne }}
                '#'({{ 1:Result.1.{{ FeatureGivenByUserOrNewOne }}
                       ... N:Result.N.{{ FeatureGivenByUserOrNewOne }}}})
               }
               {{ ForAll Features F }}
                  NextF = AriF.2
               {{ end ForAll }}
            else
               %% leaf
               {{ BodyIfAny }}
               {{ ForAll Features F }}
                  if AriF \= nil andthen {{ FeatureGivenByUserOrNewOne }} == AriF.1 then
                     Result.F.{{ FeatureGivenByUserOrNewOne }} = {{ ExpressionF }}
                     NextF = AriF.2
                  else
                     NextF = AriF
                  end
               {{ end ForAll }}
            end
            {For2 Ari.2 Rec arities(1:Next1 2:Next2) ?Result}
         end
      end
   end
end
