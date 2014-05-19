%% L1 = L2 = [FA#A if A>10 1:B A#B suchthat lazy FA:A in 10#20 suchthat _:B in R]
declare L1 L2 R Fun in
%% Big local
thread L2 =
   local
      %% pre level
      proc {PreLevel ?Result}
         Result = {Record.make '#' [2 1 3]}
         local
            Record1At1 = 10#20
         in
            {Level1 record({Arity Record1At1} Record1At1) Result}
         end
      end
      %% level 1
      proc {Level1 record(Arity1At1 Record1At1) ?Result}
         local
            LazyVar
         in
            thread {WaitNeeded Result.2} LazyVar = unit end
            thread {WaitNeeded Result.1} LazyVar = unit end
            thread {WaitNeeded Result.3} LazyVar = unit end
            {Wait LazyVar}
         end
         if Arity1At1 \= nil then
            local
               FA = Arity1At1.1
               A  = Record1At1.(Arity1At1.1)
            in
               local
                  Record1At2 = R
               in
                  {Level2 record({Arity Record1At2} Record1At2) FA A record(Arity1At1 Record1At1) Result}
               end
            end
         else
            Result.2 = nil
            Result.1 = nil
            Result.3 = nil
         end
      end
      %% level 2
      proc {Level2 record(Arity1At2 Record1At2) FA A record(Arity1At1 Record1At1) ?Result}
         if Arity1At2 \= nil then
            local
               B = Record1At2.(Arity1At2.1)
            in
               local
                  Next
               in
                  local
                     Next1 Next2 Next3
                  in
                     Result.2 = if A>10 then (FA#A)|Next1 else Next1 end
                     Result.1 = B|Next2
                     Result.3 = A#B|Next3
                     Next = '#'(2:Next1 1:Next2 3:Next3)
                  end
                  {Level2 record(Arity1At2.2 Record1At2) FA A record(Arity1At1 Record1At1) Next}
               end
            end
         else
            {Level1 record(Arity1At1.2 Record1At1) Result}
         end
      end
   in
      {PreLevel}
   end
end
R = r(1:f(a:f1) 2:f2 3:f3 rr1:rr(c:f4 crrr1:rrr(50:f5 dd:f6) cx:f7) rr2:rr(8:f8))
{Browse 'ListComprehension'}{Browse L1}
{Browse 'Equivalent'}{Browse L2}
thread L1 = [FA#A if A>10 1:B A#B suchthat lazy FA:A in 10#20 suchthat _:B in R] end

%% because lazy
thread {Value.makeNeeded L1.3} end
thread {Value.makeNeeded L2.3} end

%% end streams
thread {Value.makeNeeded L1.2.2.2.2.2.2.2.2.2} end
thread {Value.makeNeeded L2.2.2.2.2.2.2.2.2.2} end
