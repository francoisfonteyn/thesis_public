%%
%% Author:
%%     Francois Fonteyn, 2014
%%

functor
import
   Application
   Tester at 'Tester.ozf'
define
   local
      Tests = [ %% each element is [listComprehension]#[expectedList]
		%% Add tests from here...
		[A A+3 for A in 1..3]
		#([1 2 3]#[4 5 6])

		[A B for A in 1..3 B in 4..6]
		#([1 2 3]#[4 5 6])

		[A B for A in 1..3 B in 4..6 if A+B<9]
		#([1 2]#[4 5])

		[A B C for A in 1..2 for B in 3..4 for C in 5..6]
		#([1 1 1 1 2 2 2 2]#[3 3 4 4 3 3 4 4]#[5 6 5 6 5 6 5 6])

		[A B C for A in 1..2 B in 3..4 C in 5..6]
		#([1 2]#[3 4]#[5 6])

		[A B C D for A in 1..2 B in 3..4 C in 5..6 D in 7..8]
		#([1 2]#[3 4]#[5 6]#[7 8])

		[A B C for A in 1..2 for B in 3..4 C in 5..6]
		#([1 1 2 2]#[3 4 3 4]#[5 6 5 6])
		%% ...to here
	      ]
   in
      {Tester.test Tests}
      {Application.exit 0}
   end
end
