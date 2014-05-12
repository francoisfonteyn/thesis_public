%% L1 = L2 = [A+B#AA+BB suchthat A from Fun1 AA in 10..12 suchthat B from Fun2 BB in 10..12]
declare L1 L2 Fun1 Fun2 in
%% functions
fun {Fun1} 1 end
fun {Fun2} 2 end
%% Big local
thread L2 =
   local
      %% pre level
      proc {PreLevel ?Result}
         {Level1 10 {Fun1} '#'(1:Result)}
      end
      %% level 1
      proc {Level1 AA A ?Result}
         if AA =< 12 then
            {Level2 10 {Fun2} AA A Result}
         else
            Result.1 = nil
         end
      end
      %% level 2
      proc {Level2 BB B AA A ?Result}
         if BB =< 12 then
            local
               Next1
            in
               Result.1 = A+B#AA+BB|Next1
               {Level2 BB+1 {Fun2} AA A '#'(1:Next1)}
            end
         else
            {Level1 AA+1 {Fun1} Result}
         end
      end
   in
      {PreLevel}
   end
end
{Browse 'ListComprehension'}{Browse L1}
{Browse 'Equivalent'}{Browse L2}
thread L1 = [A+B#AA+BB suchthat A from Fun1 AA in 10..12 suchthat B from Fun2 BB in 10..12] end

