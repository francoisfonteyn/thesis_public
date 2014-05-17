%% UNOFFICIAL

%% L1 = L2 = [1:collect:C2 2:collect:C2 suchthat lazy A in 1..3 do {C1 A}{C1 A+1}{C2 yes}{C2 no}]
declare L1 L2 in
%% Big local
thread L2 =
   local
      Cell1 = {NewCell _}
      Cell2 = {NewCell _}
      %%
      proc {C1 X} N in {Exchange Cell1 X|N N} end
      proc {C2 X} N in {Exchange Cell2 X|N N} end
      %% pre level
      proc {PreLevel ?Result}
         Result = '#'(1:@Cell1 2:@Cell2)
         {Level1 1 '#'()}
      end
      %% level 1
      proc {Level1 A ?Result}
         local
            LazyVar
         in
            thread {WaitNeeded @Cell1} LazyVar = unit end
            thread {WaitNeeded @Cell2} LazyVar = unit end
            {Wait LazyVar}
         end
         if A =< 3 then
            local
               Next
            in
               {C1 A}{C1 A+1}{C2 yes}{C2 no}
               Next = '#'()
               {Level1 A+1 Next}
            end
         else
            {Exchange Cell1 nil _}
            {Exchange Cell2 nil _}
         end
      end
   in
      {PreLevel}
   end
end
{Browse 'ListComprehension'}{Browse L1}
{Browse 'Equivalent'}{Browse L2}
thread L1 =  [1:collect:C1 2:collect:C2 suchthat lazy A in 1..3 do {C1 A}{C1 A+1}{C2 yes}{C2 no}] end

{Value.makeNeeded L1.2.2.2.2.2.2.2}
{Value.makeNeeded L2.1.2.2.2.2.2.2}