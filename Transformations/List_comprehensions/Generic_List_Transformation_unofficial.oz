%% Big local
local
   %% Collectors and cells
   {{ ForAll I in Collectors }}
      Cell_I = {NewCell _}
      proc {I X} N in {Exchange Cell_I X|N N} end
   {{ end ForAll }}
   %% pre level
   proc {PreLevel ?Result}
      %% return list when one output with no feature
      if {{ ReturnList }} then
         if {{ Bounded_Buffer }} then
            %% create buffers
            local
               Range1At1 = List_1
               End1At1 = thread {List.drop Range1At1 Buffer} end
            in
               %% call next level with buffers
               {Level1 {{ Initiators_For_Next_Level }} '#'(1:Result)}
            end
         else %% no buffers
            {Level1 {{ Initiators_For_Next_Level }} '#'(1:Result)}
         end
      else %% return record
         %% create the tuple of outputs
         local
            {{ Next_1 ... Next_N }}
         in
            Result = {{ '#'(field1:Next1 ... fieldCollect1:@Cell1 ... fieldN:NextN) }}
            if {{ Bounded_Buffer }} then
               %% create buffers
               local
                  {{ ForAll I with Bounded Buffer }}
                     RangeIAt1 = List_I
                     EndIAt1 = thread {List.drop RangeIAt1 Buffer} end
                  {{ End ForAll }}
               in
                  %% call next level with buffers
                  {Level1 {{ Initiators_For_Next_Level }} '#'(field1:Next1 ... fieldN:NextN)}
               end
            else %% no buffers
               %% call level 1 with its initiators and with the tuple
               {Level1 {{ Initiators_For_Next_Level }} '#'(field1:Next1 ... fieldN:NextN)}
            end
         end
      end
   end
   %% previous level number: X (if exists)
   %% current  level number: Y
   %% next     level number: Z (if exists)
   proc {LevelY {{ This_Level_Arguments }} {{ Previous_Levels_Arguments }} {{ Previous_List_Ranges_And_Stacks }} ?Result}
      %% handle lazy if needed
      if {{ Is_Lazy }} then
         if {{ Multi_Output }}
            %% wait for need of any output
            local
               LazyVar
            in
               {{ Forall I in Fields_Name }}
                  thread
                     if {{ I is Collector }} then
                        {WaitNeeded @Cell_I}
                     else
                        {WaitNeeded Result.I}
                     end
                     LazyVar = unit
                  end
               {{ end Forall }}
               %% LazyVar is assigned (to unit) as soon as any output is needed
               {Wait LazyVar}
            end
         else
            %% one output, so just wait for it to be needed
            if {{ I is Collector }} then
               {WaitNeeded @Cell_1}
            else
               {WaitNeeded Result.{{ Fields_Name.1 }}}
            end
         end
      end %% end of handle laziness
      %% test if no more iterations
      if {{ Ranges_Conditions_For_This_Level }} then
         %% still at least one iteration
         local
            %% local needed iff generatorList or forRecord in ranges of this level
            {{ Forall generatorList GL }}
               {{ Range_For_GL }} = {{ GL_Argument }}.1
            {{ end Forall }}
            {{ Forall forRecord FR }}
               {{ FR_Feature }} = {{ FR_Features }}.1
               {{ FR_Range }} = {{ FR_Record }}.{{ FR_Feature }}
            {{ end Forall }}
         in
            if {{ Last_Level }} then
               local
                  Next
               in
                  if {{ This_Level_Condition }} then
                     %% last level, level condition true
                     local
                        {{ Next_1 ... Next_N }}
                     in
                        if {{ Is_Body }} then {{ Body }} end
                        {{ Forall I in Fields_Name }}
                           %% append to result iff optional condition given by user for output I is fulfilled
                           %% no condition given is equivalent to true
                           Result.I = if {{ Condition.I }} then Expression.I|Next_I else Next_I end
                        {{ end Forall }}
                        Next = {{ '#'(field1:Next1 ... fieldN:NextN) }}
                     end
                  else
                     %% last level, level condition false
                     Next = Result
                  end
                  {LevelY
                   if {{ Bounded_Buffer }} then
                      {{ Next_Iteration_For_The_Ranges_Of_This_Level_With_Buffer }}
                   else
                      {{ Next_Iteration_For_The_Ranges_Of_This_Level }}
                   end
                   {{ Previous_Levels_Arguments }}
                   {{ Previous_List_Ranges }}
                   Next}
               end
            else
               %% not last level
               if {{ This_Level_Condition }} then
                  %% not last level, level condition fulfilled, call next level
                  {LevelZ
                   if {{ Bounded_Buffer }} then
                      local
                         {{ ForAll I with Bounded Buffer }}
                            RangeIAtZ = List_I
                            EndIAtZ = thread {List.drop RangeIAtZ Buffer} end
                         {{ End ForAll }}
                      in
                         {{ Initiators_For_Next_Level_With_Buffers }}
                      end
                   else
                      {{ Initiators_For_Next_Level }}
                   end
                   {{ This_Level_Ranges }} % may contain buffers
                   {{ Previous_Levels_Arguments }}
                   {{ List_Arguments }}
                   {{ Previous_List_Ranges }}
                   Result}
                     else
                  %% not last level, level condition not fulfilled, call next iteration
                  {LevelY
                   if {{ Bounded_Buffer }} then
                      {{ Next_Iteration_For_The_Ranges_Of_This_Level_With_Buffer }}
                   else
                      {{ Next_Iteration_For_The_Ranges_Of_This_Level }}
                   end
                   {{ Previous_Levels_Arguments }}
                   {{ Previous_List_Ranges }}
                   Result}
               end
            end
         end
      else
         %% no more iterations for this level, call previous one
         if {{ First_Level }} then
            %% no previous level, end output-s by appending nil
            if {{ Multi_Output }} then
               {{ Forall I in Fields_Name }}
                  if {{ Output I is Collector }} then
                     {Exchange Cell_I nil _}
                  else
                     Result.I = nil
                  end
               {{ end Forall }}
            else
               if {{ Output 1 is Collector }} then
                  {Exchange Cell_1 nil _}
               else
                  Result.1 = nil
               end
            end
         else
            %% call previous level X
            %% same as lines 143 to 152 of previous level X
            {{ Call_Previous_Level_With_Next_Iteration }}
         end
      end
   end
in
   %% actually call the cascade of procedures
   {PreLevel}
end


fun {{ Next_Iteration_For_The_Ranges_Of_This_Level_With_Buffer }}
   case Ranges
   of nil then nil
   [] H|T then
      case H
      of RangeIAtX#EndIAtX then %% buffer is here
         (RangeIAtX.2#thread if EndIAtX == nil then EndIAtX
                             else EndIAtX.2
                             end)|{... T}
      else H|{... T}
      end
   end
end




