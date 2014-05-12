%% L1 = L2 = [A+B suchthat lazy A in 1 ; A<10 ; A+1 if A<4 suchthat lazy B in 2*A ; B<20 ; B+2 if A+B>4]
declare L1 L2 in
%% Big local
thread L2 =
   local
      proc {PreLevel ?Result}
         {Level1 1 '#'(1:Result)}
      end
      %% level 1
      proc {Level1 A ?Result}
         {WaitNeeded Result.1}
         if A<10 then
            if A<4 then
               {Level2 2*A A Result}
            else
               {Level1 A+1 Result}
            end
         else
            Result = nil
         end
      end
      %% level 2
      proc {Level2 B A ?Result}
         {WaitNeeded Result.1}
         if B<20 then
            if A+B > 4 then
               local
                  Next1
               in
                  Result.1 = A+B|Next1
                  {Level2 B+2 A '#'(1:Next1)}
               end
            else
               {Level2 B+2 A Result}
            end
         else
            {Level1 A+1 Result}
         end
      end
   in
      {PreLevel}
   end
end
{Browse 'ListComprehension'}{Browse L1}
{Browse 'Equivalent'}{Browse L2}
thread L1 = [A+B suchthat lazy A in 1 ; A<10 ; A+1 if A<4 suchthat lazy B in 2*A ; B<20 ; B+2 if A+B>4] end

%% because lazy
{Value.makeNeeded L1.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2}
{Value.makeNeeded L2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2}