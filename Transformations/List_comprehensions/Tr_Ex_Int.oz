%% L1 = L2 = [A+B a:B-A if A > 0 for A in 1..3 for lazy B in 4..8 ; 2 if A+B > 4]
declare L1 L2 in
%% Big local
thread L2 =
   local
      %% pre level
      proc {PreLevel ?Result}
         local
            Next1 Next2
         in
            Result = '#'(1:Next1 a:Next2)
            {Level1 1 '#'(1:Next1 a:Next2)}
         end
      end
      %% level 1
      proc {Level1 A ?Result}
         if A =< 3 then
            {Level2 4 A Result}
         else
            Result.1 = nil
            Result.a = nil
         end
      end
      %% level 2
      proc {Level2 B A Result}
         local
            LazyVar
         in
            thread {WaitNeeded Result.1} LazyVar = unit end
            thread {WaitNeeded Result.a} LazyVar = unit end
            {Wait LazyVar}
         end
         if B =< 8 then
            if A+B > 4 then
               local
                  Next1 Next2
               in
                  Result.1 = A+B|Next1
                  Result.a = if A > 0 then B-A|Next2 else Next2 end
                  {Level2 B+2 A '#'(1:Next1 a:Next2)}
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
thread L1 = [A+B a:B-A if A > 0 for A in 1..3 for lazy B in 4..8 ; 2 if A+B > 4] end

%% because lazy
{Value.makeNeeded L1.a.2.2.2.2.2.2.2.2.2}
{Value.makeNeeded L2.a.2.2.2.2.2.2.2.2.2}

