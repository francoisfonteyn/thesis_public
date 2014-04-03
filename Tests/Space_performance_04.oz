%%
%% Author:
%%     Francois Fonteyn, 2014
%%

functor
import
   Application
   OS
   Tester at 'Tester.ozf'
define
   local
      Browse = Tester.browse
      Pid = {OS.getPID}
      proc {PreLevel ?Result}
	 local
	    Next1
	 in
	    Result = '#'(1:Next1)
	    {Level1 1 {Fun} '#'(1:Next1)}
	 end
      end
      proc {Level1 B A ?Result}
	 if B =< H then
	    if B > 0 then
	       local
		  Next1
	       in
		  Result.1 = A|Next1
		  {Level1 B+1 {Fun} '#'(1:Next1)}
	       end
	    else
	       {Level1 B+1 {Fun} Result}
	    end
	 else
	    Result.1 = nil
	 end
      end
      fun {Fun} 1 end
      H = 500000
      fun {Measure LC}
	 local M1 M2 L in
	    if LC then
	       %% LC
	       M1 = {Tester.memory Pid} div 1000000
	       L = [A for A from Fun B in 1..H if B > 0]
	       M2 = {Tester.memory Pid} div 1000000
	       {Browse {VirtualString.toAtom 'List comprehension added '#M2-M1#' extra MB'}}
	    else
	       %% Eq
	       M1 = {Tester.memory Pid} div 1000000
	       L = {PreLevel}
	       M2 = {Tester.memory Pid} div 1000000
	       {Browse {VirtualString.toAtom 'Equivalent         added '#M2-M1#' extra MB'}}
	    end
	    M2-M1
	 end
      end
      proc {Apply}
        if @EQnocc == 10 then
	   LCnocc := @LCnocc + 1
	   LCtime := @LCtime + {Measure true}
	elseif @LCnocc == 10 then
	   EQnocc := @EQnocc + 1
	   EQtime := @EQtime + {Measure false}
	else
	   if {OS.rand} mod 2 == 0 then
	      LCnocc := @LCnocc + 1
	      LCtime := @LCtime + {Measure true}
	   else
	      EQnocc := @EQnocc + 1
	      EQtime := @EQtime + {Measure false}
	   end
	end
      end
      LCtime = {NewCell 0}
      LCnocc = {NewCell 0}
      EQtime = {NewCell 0}
      EQnocc = {NewCell 0}
   in
      {Browse 'Each technique will be tried 10 times in a random order'}
      for _ in 1..20 do {Apply} end
      {Browse {VirtualString.toAtom 'List comprehensions added '#@LCtime#' extra MB in total'}}
      {Browse {VirtualString.toAtom 'Equivalents         added '#@EQtime#' extra MB in total'}}
      {Browse {VirtualString.toAtom 'The total memory taken at the end is '
	       #{Tester.memory Pid} div 1000000#' MB'}}
      {Application.exit 0}
   end
end

