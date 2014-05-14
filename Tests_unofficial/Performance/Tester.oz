functor
import
   System
   OS
export
   browse:            Browse1
   memory:            MemoryTaken
define
   Browse1 = System.show
   %% Returns the memory taken by process Pid in Bytes
   fun {MemoryTaken Pid}
      Pipe
      Read
      {OS.pipe "top" ["-pid" ""#Pid  "-l" "1" "-stats" "mem"] _ Pipe}
      {OS.read Pipe.1 1000 Read nil _}
      proc {Aux List NL ?Next}
         if NL < 12 then
            case List
            of &\n|Tail then
               {Aux Tail NL+1 Next}
            [] _|Tail then
               {Aux Tail NL Next}
            end
         else
            case List
            of &\n|_ then
               Next = nil
            [] H|Tail then N in
               Next = H|N
               {Aux Tail NL N}
            end
         end
      end
      fun {Clean Mem}
         M = {Reverse Mem}
         fun {Aux L Mul Acc}
            case L
            of nil then Acc
            [] H|T then
               case H
               of &+ then
                  {Aux T Mul Acc}
               [] &K then
                  {Aux T 1000 Acc}
               [] &M then
                  {Aux T 1000000 Acc}
               [] &G then
                  {Aux T 1000000000 Acc}
               else
                  {Aux T Mul*10 Acc+Mul*(H-&0)}
               end
            end
         end
      in
         {Aux M 1 0}
      end
   in
      {Clean {Aux Read 0}}
   end
end