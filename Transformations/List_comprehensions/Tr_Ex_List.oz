%% L1 = L2 = [A if A>1 1:B A+B suchthat A in [1 2 3] suchthat B in [4 5 6 7 8 9 10]]
declare L1 L2 in
%% Big local
thread L2 =
   local
      %% pre level
      proc {PreLevel ?Result}
         Result = {Record.make '#' [2 1 3]}
         {Level1 [1 2 3] ?Result}
      end
      %% level 1
      proc {Level1 Range1At1 ?Result}
         if Range1At1 \= nil then
            local
               A = Range1At1.1
            in
               {Level2 [4 5 6 7 8 9 10] A Range1At1 Result}
            end
         else
            Result.2 = nil
            Result.1 = nil
            Result.3 = nil
         end
      end
      %% level 2
      proc {Level2 Range1At2 A Range1At1 ?Result}
         if Range1At2 \= nil then
            local
               B = Range1At2.1
            in
               local
                  Next
               in
                  local
                     Next1 Next2 Next3
                  in
                     Result.2 = if A>1 then A|Next1 else Next1 end
                     Result.1 = B|Next2
                     Result.3 = A+B|Next3
                     Next = '#'(2:Next1 1:Next2 3:Next3)
                  end
                  {Level2 Range1At2.2 A Range1At1 Next}
               end
            end
         else
            {Level1 Range1At1.2 Result}
         end
      end
   in
      {PreLevel}
   end
end
{Browse 'ListComprehension'}{Browse L1}
{Browse 'Equivalent'}{Browse L2}
thread L1 = [A if A>1 1:B A+B suchthat A in [1 2 3] suchthat B in [4 5 6 7 8 9 10]] end