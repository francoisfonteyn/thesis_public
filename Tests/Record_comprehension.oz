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
      Rec = rec(c:c b:b 1:a d:d)
      Tree = tree(tree(leaf(1) leaf(2)) leaf(3))
      fun {Treat X} case X of rrr(N) then N*2 else X*2 end end
      fun {Bool X} {Label X} \= rrr end
      Tests = [ %% each element is [recordComprehension]#[expectedRecord]
		%% add tests form here...
		[A for A through Rec]
		#Rec

		[A for _:A through Rec]
		#Rec

		[F for F:A through Rec of {Arity A} \= nil]
		#rec(1:1 b:b c:c d:d)

		[[F A] for F:A through Rec of {Arity A} \= nil]
		#rec(1:[1 a] b:[b b] c:[c c] d:[d d])

		[1 for A through Rec of {Arity A} \= nil]
		#rec(1:1 b:1 c:1 d:1)

		[1 for _ through r(1 2 rr(3 rrr(4)) 5)]
		#r(1 1 rr(1 rrr(1)) 1)
		
		[1 for A through r(1 2 rr(3 rrr(4)) 5) of {Bool A}]
		#r(1 1 rr(1 1) 1)

		[1 a:2 for A through r(1 2 rr(3 rrr(4)) 5) of {Bool A}]
		#'#'(1:r(1 1 rr(1 1) 1) a:r(2 2 rr(2 2) 2))

		[A+1 for A through r(1 2 rr(3 rrr(4)) 5)]
		#r(2 3 rr(4 rrr(5)) 6)

		[A+1 A-1 for A through r(1 2 rr(3 rrr(4)) 5)]
		#(r(2 3 rr(4 rrr(5)) 6)#r(0 1 rr(2 rrr(3)) 4))

		[A for A through r(1 2 rr(3 rrr(4)) 5) of {Bool A}]
		#r(1 2 rr(3 rrr(4)) 5)

		[{Treat A} for A through r(1 2 rr(3 rrr(4)) 5) of {Bool A}]
		#r(2 4 rr(6 8) 10)

		[A for F:A through r(1:bb(w(2)) 2:y(1) 3:w(2) 4:n(0) 5:rr(n(0) 6:w(2) 7:y(1) 8:y(1)) 9:rr(rrr(y(1) n(0))))
		      if {Not {IsRecord A}} orelse {Label A} \= w
		      of {Label A} \= bb orelse F > 3]
		#r(1:bb(w(2)) 2:y(1) 4:n(0) 5:rr(1:n(0) 7:y(1) 8:y(1)) 9:rr(rrr(y(1) n(0))))

		[A for A through rec(a:yes b:no c:yes rec:rec(a:no b:yes)) of {Arity A} \= nil if {Label A} == yes orelse {Label A} == rec]
		#rec(a:yes c:yes rec:rec(b:yes))

		[F#A for F:A through [1 2 3]]
		#[1#1 1#2 1#3]

		[F#A for F:A through [1 2 3] of 1 == 0]
		#'|'(1#1 2#[2 3])

		[A for A through Tree]
		#Tree
		
		[A+1 for A through Tree]
		#tree(tree(leaf(2) leaf(3)) leaf(4))

		[F#A for F:A through Tree]
		#tree(tree(leaf(1#1) leaf(1#2)) leaf(1#3))

		[F#A for F:A through Tree of F == 1]
		#tree(tree(leaf(1#1) 2#leaf(2)) 2#leaf(3))

		[A for F:A through Tree if F == 1]
		#tree(tree(leaf(1)))
		%% ...to here
	      ]
   in
      {Tester.test Tests}
      {Application.exit 0}
   end
end
