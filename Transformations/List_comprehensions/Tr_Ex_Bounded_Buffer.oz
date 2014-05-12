%% L1 = L2 = [A B A+B suchthat A in In1:2 suchthat lazy B in In2:3]
declare In1 In2 L1 L2 MakeNeeded Producer in
proc {MakeNeeded L N}
   if N > 0 andthen L \= nil then {MakeNeeded L.2 N-1} end
end
%% producer
fun lazy {Producer I N}
   {Delay 2000}
   if I > N then
      nil
   else
      I|{Producer I+1 N}
   end
end
%% Big local
thread L2 =
   local
      %% pre level
      proc {PreLevel ?Result}
         local
            Next1 Next2 Next3
         in
            Result = '#'(1:Next1 2:Next2 3:Next3)
            local
               Range1At1 = In1
               End1At1 = thread {List.drop Range1At1 2} end
            in
               {Level1 Range1At1#End1At1 '#'(1:Next1 2:Next2 3:Next3)}
            end
         end
      end
      %% level 1
      proc {Level1 Range1At1#End1At1 ?Result}
         if Range1At1 \= nil then
            local
               A = Range1At1.1
            in
               local
                  Range1At2 = In2
                  End1At2 = thread {List.drop Range1At2 3} end
               in
                  {Level2 Range1At2#End1At2 A Range1At1#End1At1 Result}
               end
            end
         else
            Result.1 = nil
            Result.2 = nil
            Result.3 = nil
         end
      end
      %% level 2
      proc {Level2 Range1At2#End1At2 A Range1At1#End1At1 ?Result}
         local
            LazyVar
         in
            thread {WaitNeeded Result.1} LazyVar = unit end
            thread {WaitNeeded Result.2} LazyVar = unit end
            {Wait LazyVar}
         end
         if Range1At2 \= nil then
            local
               B = Range1At2.1
            in
               local
                  Next1 Next2 Next3
               in
                  Result.1 = A|Next1
                  Result.2 = B|Next2
                  Result.3 = A+B|Next3
                  {Level2 Range1At2.2#thread
                                         if End1At2 == nil then End1At2
                                         else End1At2.2
                                         end
                                      end
                   A Range1At1#End1At1 '#'(1:Next1 2:Next2 3:Next3)}
               end
            end
         else
            {Level1 Range1At1.2#thread
                                   if End1At1 == nil then End1At1
                                   else End1At1.2
                                   end
                                end
             Result}
         end
      end
   in
      {PreLevel}
   end
end
{Browse 'In1'}{Browse In1}
{Browse 'In2'}{Browse In2}
{Browse 'ListComprehension'}{Browse L1}
{Browse 'Equivalent'}{Browse L2}
thread {Producer 0 10 In1} end
thread {Producer 0 5 In2} end
thread L1 = [A B A+B suchthat A in In1:2 suchthat lazy B in In2:3] end

thread {MakeNeeded L1.1 14} end
thread {MakeNeeded L2.2 14} end

thread {MakeNeeded L1.3 67} end
thread {MakeNeeded L2.1 67} end

%% change all RangeXatY into RangeXatY#EndXatY --> ok
%% fLocal when calling next level (except last level), see initiators --> ok
%% first line of any level --> ok
%% thread .2 when calling itself --> ok
%% threads are there because otherwise one can not take profit of the buffers because we have to wait for the next lement of End to be there to go on with what the rest - that might there a lot !
