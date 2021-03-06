%% L1 = L2 = [A suchthat A in 1..3 do {Delay 1000}]
declare L1 L2 in
%% Big local
thread L2 =
   local
      %% pre level
      proc {PreLevel ?Result}
         {Level1 1 '#'(1:Result)}
      end
      %% level 1
      proc {Level1 A ?Result}
         if A =< 3 then
            local
               Next
            in
               local
                  Next1
               in
                  {Delay 1000}
                  Result.1 = A|Next1
                  Next = '#'(1:Next1)
               end
               {Level1 A+1 Next}
            end
         else
            Result.1 = nil
         end
      end
   in
      {PreLevel}
   end
end
{Browse 'ListComprehension'}{Browse L1}
{Browse 'Equivalent'}{Browse L2}
thread L1 = [A suchthat A in 1..3 do {Delay 1000}] end