functor
import
   System
export
   test:              TestSeveral
   testLazy:          TestLazy
   browse:            Browse1
define
   Browse1 = System.show
   Browse2 = System.print
   %% prints final result of test
   proc {PrintResult G B}
      if B \= 0 then
         {Browse1 {VirtualString.toAtom G#' tests successfully passed.'}}
         {Browse1 {VirtualString.toAtom B#' tests failed.'}}
      else
         {Browse1 {VirtualString.toAtom 'All tests ('#G#') successfully passed.'}}
      end
   end
   %% test all the elements of the list using SimpleAssert
   proc {TestSeveral List}
      proc {Aux L G B}
         case L
         of nil then {PrintResult G B}
         [] TR#Ex|T then
            if {SimpleAssert TR Ex G+B+1} then
               {Aux T G+1 B}
            else
               {Aux T G B+1}
            end
         end
      end
   in
      {Aux List 0 0}
   end
   %% test the equality of its first two arguments
   %% displays error message if not equal
   %% return true iff equal
   fun {SimpleAssert TestResult Expected Index}
      if TestResult \= Expected then
         {Browse1 {VirtualString.toAtom '----------------------------'}}
         {Browse1 {VirtualString.toAtom 'Error in test '#Index}}
         {Browse2 'Expecting: '}{Browse1 Expected}
         {Browse2 'Getting:   '}{Browse1 TestResult}
         {Browse1 {VirtualString.toAtom '----------------------------'}}
         false
      else
         true
      end
   end
   %% test all the elements of the list for lazy input
   proc {TestLazy List}
      proc {Aux L G B}
         case L
         of nil then {PrintResult G B}
         [] TR#Ex#N|T then Good in
            for I in 1 ; I=<{Length Ex} ; I+N do
               if {LazyAssert TR Ex G+B+1 I N} then
                  skip
               else
                  Good = unit
               end
            end
            if {IsDet Good} then
               {Aux T G B+1}
            else
               {Aux T G+1 B}
            end
         end
      end
   in
      {Aux List 0 0}
   end
   %% lazy assert
   fun {LazyAssert TestResult Expected Index B N}
      if {IsDet {Nth TestResult B}} then {Browse1 'Lazy error'} false
      else
         local
            Bad
         in
            for I in B..B+N-1 do
               if {Nth TestResult I} \= {Nth Expected I} then
                  {Browse1 {VirtualString.toAtom '----------------------------'}}
                  {Browse1 {VirtualString.toAtom 'Error in lazy test '#Index}}
                  {Browse2 'Expecting: '}{Browse1 Expected}
                  {Browse2 'Getting:   '}{Browse1 TestResult}
                  {Browse1 {VirtualString.toAtom '----------------------------'}}
                  Bad = unit
               end
            end
            {Not {IsDet Bad}}
         end
      end
   end
end