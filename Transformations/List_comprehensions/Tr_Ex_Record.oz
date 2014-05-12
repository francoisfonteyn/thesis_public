%% L1 = L2 = [FA#A if A>10 1:B A#B suchthat lazy FA:A in 10#20 suchthat _:B in R]
declare L1 L2 R Fun in
%% Big local
thread L2 =
   local
      proc {FindNext stacks(FeatStack ValueStack) ?Result}
         local
            Feat = FeatStack.1
            Value = ValueStack.1
            PoppedFeatStack = FeatStack.2
            PoppedValueStack = ValueStack.2
         in
            if {IsRecord Value} andthen {Arity Value} \= nil then
               {FindNext stacks({Append {Arity Value} PoppedFeatStack} {Append {Record.toList Value} PoppedValueStack}) Result}
            else
               Result = Feat#Value#stacks(PoppedFeatStack PoppedValueStack)
            end
         end
      end
      %% pre level
      proc {PreLevel ?Result}
         local
            Next1 Next2 Next3
         in
            Result = '#'(2:Next1 1:Next2 3:Next3)
            local
               Record1At1 = 10#20
            in
               {Level1 stacks({Arity Record1At1} {Record.toList Record1At1}) '#'(2:Next1 1:Next2 3:Next3)}
            end
         end
      end
      %% level 1
      proc {Level1 Stacks1At1 ?Result}
         local
            LazyVar
         in
            thread {WaitNeeded Result.2} LazyVar = unit end
            thread {WaitNeeded Result.1} LazyVar = unit end
            thread {WaitNeeded Result.3} LazyVar = unit end
            {Wait LazyVar}
         end
         if Stacks1At1.1 \= nil then
            local
               FA#A#NewStacks1At1 = {FindNext Stacks1At1}
            in
               local
                  Record1At2 = R
               in
                  {Level2 stacks({Arity Record1At2} {Record.toList Record1At2}) FA A NewStacks1At1 Result}
               end
            end
         else
            Result.2 = nil
            Result.1 = nil
            Result.3 = nil
         end
      end
      %% level 2
      proc {Level2 Stacks1At2 FA A Stacks1At1 ?Result}
         if Stacks1At2.1 \= nil then
            local
               _#B#NewStacks1At2 = {FindNext Stacks1At2}
            in
               local
                  Next1 Next2 Next3
               in
                  Result.2 = if A>10 then (FA#A)|Next1 else Next1 end
                  Result.1 = B|Next2
                  Result.3 = A#B|Next3
                  {Level2 NewStacks1At2 FA A Stacks1At1 '#'(2:Next1 1:Next2 3:Next3)}
               end
            end
         else
            {Level1 Stacks1At1 Result}
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
{Value.makeNeeded L1.3}
{Value.makeNeeded L2.3}

%% end streams
{Value.makeNeeded L1.2.2.2.2.2.2.2.2.2}
{Value.makeNeeded L2.2.2.2.2.2.2.2.2.2}
