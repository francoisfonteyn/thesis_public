%%%
%%% Authors:
%%%   Christian Schulte <schulte@ps.uni-sb.de>
%%%
%%% Copyright:
%%%   Christian Schulte, 1997, 1998
%%%
%%% Last change:
%%%   $Date$ by $Author$
%%%   $Revision$
%%%
%%% This file is part of Mozart, an implementation
%%% of Oz 3
%%%    http://www.mozart-oz.org
%%%
%%% See the file "LICENSE" or
%%%    http://www.mozart-oz.org/LICENSE.html
%%% for information on usage and redistribution
%%% of this file, and for a DISCLAIMER OF ALL
%%% WARRANTIES.
%%%

local

   Tests =
   [naive #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3) (1#3)#(0#1)#(3#5)#(1#3)#(0#3)
     0#(0#1)#(3#5)#0#(0#3) (2#3)#(0#1)#(3#5)#(2#3)#(0#3)
     1#(0#1)#(3#5)#1#(0#3) 0#1#(3#5)#0#(0#3) 0#0#(3#5)#0#(0#3)
     3#(0#1)#(3#5)#3#(0#3) 2#(0#1)#(3#5)#2#(0#3) 1#1#(3#5)#1#(0#3)
     1#0#(3#5)#1#(0#3) 0#1#(4#5)#0#(0#3) 0#1#3#0#(0#3) 0#0#(4#5)#0#(0#3)
     0#0#3#0#(0#3) 3#1#(3#5)#3#(0#3) 3#0#(3#5)#3#(0#3) 2#1#(3#5)#2#(0#3)
     2#0#(3#5)#2#(0#3) 1#1#(4#5)#1#(0#3) 1#1#3#1#(0#3) 1#0#(4#5)#1#(0#3)
     1#0#3#1#(0#3) 0#1#5#0#(0#3) 0#1#4#0#(0#3) 0#1#3#0#(1#3) 0#0#5#0#(0#3)
     0#0#4#0#(0#3) 0#0#3#0#(1#3) 3#1#(4#5)#3#(0#3) 3#1#3#3#(0#3)
     3#0#(4#5)#3#(0#3) 3#0#3#3#(0#3) 2#1#(4#5)#2#(0#3) 2#1#3#2#(0#3)
     2#0#(4#5)#2#(0#3) 2#0#3#2#(0#3) 1#1#5#1#(0#3) 1#1#4#1#(0#3)
     1#1#3#1#(1#3) 1#0#5#1#(0#3) 1#0#4#1#(0#3) 1#0#3#1#(1#3) 0#1#5#0#(1#3)
     0#1#4#0#(1#3) 0#1#3#0#(2#3) 0#0#5#0#(1#3) 0#0#4#0#(1#3) 0#0#3#0#(2#3)
     3#1#5#3#(0#3) 3#1#4#3#(0#3) 3#1#3#3#(1#3) 3#0#5#3#(0#3) 3#0#4#3#(0#3)
     3#0#3#3#(1#3) 2#1#5#2#(0#3) 2#1#4#2#(0#3) 2#1#3#2#(1#3) 2#0#5#2#(0#3)
     2#0#4#2#(0#3) 2#0#3#2#(1#3) 1#1#5#1#(1#3) 1#1#4#1#(1#3) 1#1#3#1#(2#3)
     1#0#5#1#(1#3) 1#0#4#1#(1#3) 1#0#3#1#(2#3) 0#1#5#0#(2#3) 0#1#4#0#(2#3)
     0#0#5#0#(2#3) 0#0#4#0#(2#3) 3#1#5#3#(1#3) 3#1#4#3#(1#3) 3#1#3#3#(2#3)
     3#0#5#3#(1#3) 3#0#4#3#(1#3) 3#0#3#3#(2#3) 2#1#5#2#(1#3) 2#1#4#2#(1#3)
     2#1#3#2#(2#3) 2#0#5#2#(1#3) 2#0#4#2#(1#3) 2#0#3#2#(2#3) 1#1#5#1#(2#3)
     1#1#4#1#(2#3) 1#0#5#1#(2#3) 1#0#4#1#(2#3) 3#1#5#3#(2#3) 3#1#4#3#(2#3)
     3#0#5#3#(2#3) 3#0#4#3#(2#3) 2#1#5#2#(2#3) 2#1#4#2#(2#3) 2#0#5#2#(2#3)
     2#0#4#2#(2#3)]

    generic(order:naive value:min) #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3) (1#3)#(0#1)#(3#5)#(1#3)#(0#3)
     0#(0#1)#(3#5)#0#(0#3) (2#3)#(0#1)#(3#5)#(2#3)#(0#3)
     1#(0#1)#(3#5)#1#(0#3) 0#1#(3#5)#0#(0#3) 0#0#(3#5)#0#(0#3)
     3#(0#1)#(3#5)#3#(0#3) 2#(0#1)#(3#5)#2#(0#3) 1#1#(3#5)#1#(0#3)
     1#0#(3#5)#1#(0#3) 0#1#(4#5)#0#(0#3) 0#1#3#0#(0#3) 0#0#(4#5)#0#(0#3)
     0#0#3#0#(0#3) 3#1#(3#5)#3#(0#3) 3#0#(3#5)#3#(0#3) 2#1#(3#5)#2#(0#3)
     2#0#(3#5)#2#(0#3) 1#1#(4#5)#1#(0#3) 1#1#3#1#(0#3) 1#0#(4#5)#1#(0#3)
     1#0#3#1#(0#3) 0#1#5#0#(0#3) 0#1#4#0#(0#3) 0#1#3#0#(1#3) 0#0#5#0#(0#3)
     0#0#4#0#(0#3) 0#0#3#0#(1#3) 3#1#(4#5)#3#(0#3) 3#1#3#3#(0#3)
     3#0#(4#5)#3#(0#3) 3#0#3#3#(0#3) 2#1#(4#5)#2#(0#3) 2#1#3#2#(0#3)
     2#0#(4#5)#2#(0#3) 2#0#3#2#(0#3) 1#1#5#1#(0#3) 1#1#4#1#(0#3)
     1#1#3#1#(1#3) 1#0#5#1#(0#3) 1#0#4#1#(0#3) 1#0#3#1#(1#3) 0#1#5#0#(1#3)
     0#1#4#0#(1#3) 0#1#3#0#(2#3) 0#0#5#0#(1#3) 0#0#4#0#(1#3) 0#0#3#0#(2#3)
     3#1#5#3#(0#3) 3#1#4#3#(0#3) 3#1#3#3#(1#3) 3#0#5#3#(0#3) 3#0#4#3#(0#3)
     3#0#3#3#(1#3) 2#1#5#2#(0#3) 2#1#4#2#(0#3) 2#1#3#2#(1#3) 2#0#5#2#(0#3)
     2#0#4#2#(0#3) 2#0#3#2#(1#3) 1#1#5#1#(1#3) 1#1#4#1#(1#3) 1#1#3#1#(2#3)
     1#0#5#1#(1#3) 1#0#4#1#(1#3) 1#0#3#1#(2#3) 0#1#5#0#(2#3) 0#1#4#0#(2#3)
     0#0#5#0#(2#3) 0#0#4#0#(2#3) 3#1#5#3#(1#3) 3#1#4#3#(1#3) 3#1#3#3#(2#3)
     3#0#5#3#(1#3) 3#0#4#3#(1#3) 3#0#3#3#(2#3) 2#1#5#2#(1#3) 2#1#4#2#(1#3)
     2#1#3#2#(2#3) 2#0#5#2#(1#3) 2#0#4#2#(1#3) 2#0#3#2#(2#3) 1#1#5#1#(2#3)
     1#1#4#1#(2#3) 1#0#5#1#(2#3) 1#0#4#1#(2#3) 3#1#5#3#(2#3) 3#1#4#3#(2#3)
     3#0#5#3#(2#3) 3#0#4#3#(2#3) 2#1#5#2#(2#3) 2#1#4#2#(2#3) 2#0#5#2#(2#3)
     2#0#4#2#(2#3)]

    ff #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (0#3)#1#(3#5)#(0#3)#(0#3) (0#3)#0#(3#5)#(0#3)#(0#3)
     (0#3)#1#(4#5)#(0#3)#(0#3) (0#3)#1#3#(0#3)#(0#3)
     (0#3)#0#(4#5)#(0#3)#(0#3) (0#3)#0#3#(0#3)#(0#3)
     (0#3)#1#5#(0#3)#(0#3) (0#3)#1#4#(0#3)#(0#3)
     (1#3)#1#3#(1#3)#(0#3) 0#1#3#0#(0#3)
     (0#3)#0#5#(0#3)#(0#3) (0#3)#0#4#(0#3)#(0#3)
     (1#3)#0#3#(1#3)#(0#3) 0#0#3#0#(0#3)
     (1#3)#1#5#(1#3)#(0#3) 0#1#5#0#(0#3)
     (1#3)#1#4#(1#3)#(0#3) 0#1#4#0#(0#3)
     (2#3)#1#3#(2#3)#(0#3) 1#1#3#1#(0#3) 0#1#3#0#(1#3)
     (1#3)#0#5#(1#3)#(0#3) 0#0#5#0#(0#3)
     (1#3)#0#4#(1#3)#(0#3) 0#0#4#0#(0#3)
     (2#3)#0#3#(2#3)#(0#3) 1#0#3#1#(0#3) 0#0#3#0#(1#3)
     (2#3)#1#5#(2#3)#(0#3) 1#1#5#1#(0#3) 0#1#5#0#(1#3)
     (2#3)#1#4#(2#3)#(0#3) 1#1#4#1#(0#3) 0#1#4#0#(1#3)
     3#1#3#3#(0#3) 2#1#3#2#(0#3) 1#1#3#1#(1#3) 0#1#3#0#(2#3)
     (2#3)#0#5#(2#3)#(0#3) 1#0#5#1#(0#3) 0#0#5#0#(1#3)
     (2#3)#0#4#(2#3)#(0#3) 1#0#4#1#(0#3) 0#0#4#0#(1#3)
     3#0#3#3#(0#3) 2#0#3#2#(0#3) 1#0#3#1#(1#3) 0#0#3#0#(2#3)
     3#1#5#3#(0#3) 2#1#5#2#(0#3) 1#1#5#1#(1#3) 0#1#5#0#(2#3)
     3#1#4#3#(0#3) 2#1#4#2#(0#3) 1#1#4#1#(1#3) 0#1#4#0#(2#3)
     3#1#3#3#(1#3) 2#1#3#2#(1#3) 1#1#3#1#(2#3) 3#0#5#3#(0#3)
     2#0#5#2#(0#3) 1#0#5#1#(1#3) 0#0#5#0#(2#3) 3#0#4#3#(0#3)
     2#0#4#2#(0#3) 1#0#4#1#(1#3) 0#0#4#0#(2#3) 3#0#3#3#(1#3)
     2#0#3#2#(1#3) 1#0#3#1#(2#3) 3#1#5#3#(1#3) 2#1#5#2#(1#3)
     1#1#5#1#(2#3) 3#1#4#3#(1#3) 2#1#4#2#(1#3) 1#1#4#1#(2#3)
     3#1#3#3#(2#3) 2#1#3#2#(2#3) 3#0#5#3#(1#3) 2#0#5#2#(1#3)
     1#0#5#1#(2#3) 3#0#4#3#(1#3) 2#0#4#2#(1#3) 1#0#4#1#(2#3)
     3#0#3#3#(2#3) 2#0#3#2#(2#3) 3#1#5#3#(2#3) 2#1#5#2#(2#3)
     3#1#4#3#(2#3) 2#1#4#2#(2#3) 3#0#5#3#(2#3) 2#0#5#2#(2#3)
     3#0#4#3#(2#3) 2#0#4#2#(2#3)]

    generic(order:size value:min) #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (0#3)#1#(3#5)#(0#3)#(0#3) (0#3)#0#(3#5)#(0#3)#(0#3)
     (0#3)#1#(4#5)#(0#3)#(0#3) (0#3)#1#3#(0#3)#(0#3)
     (0#3)#0#(4#5)#(0#3)#(0#3) (0#3)#0#3#(0#3)#(0#3)
     (0#3)#1#5#(0#3)#(0#3) (0#3)#1#4#(0#3)#(0#3)
     (1#3)#1#3#(1#3)#(0#3) 0#1#3#0#(0#3)
     (0#3)#0#5#(0#3)#(0#3) (0#3)#0#4#(0#3)#(0#3)
     (1#3)#0#3#(1#3)#(0#3) 0#0#3#0#(0#3)
     (1#3)#1#5#(1#3)#(0#3) 0#1#5#0#(0#3)
     (1#3)#1#4#(1#3)#(0#3) 0#1#4#0#(0#3)
     (2#3)#1#3#(2#3)#(0#3) 1#1#3#1#(0#3) 0#1#3#0#(1#3)
     (1#3)#0#5#(1#3)#(0#3) 0#0#5#0#(0#3)
     (1#3)#0#4#(1#3)#(0#3) 0#0#4#0#(0#3)
     (2#3)#0#3#(2#3)#(0#3) 1#0#3#1#(0#3) 0#0#3#0#(1#3)
     (2#3)#1#5#(2#3)#(0#3) 1#1#5#1#(0#3) 0#1#5#0#(1#3)
     (2#3)#1#4#(2#3)#(0#3) 1#1#4#1#(0#3) 0#1#4#0#(1#3)
     3#1#3#3#(0#3) 2#1#3#2#(0#3) 1#1#3#1#(1#3) 0#1#3#0#(2#3)
     (2#3)#0#5#(2#3)#(0#3) 1#0#5#1#(0#3) 0#0#5#0#(1#3)
     (2#3)#0#4#(2#3)#(0#3) 1#0#4#1#(0#3) 0#0#4#0#(1#3)
     3#0#3#3#(0#3) 2#0#3#2#(0#3) 1#0#3#1#(1#3) 0#0#3#0#(2#3)
     3#1#5#3#(0#3) 2#1#5#2#(0#3) 1#1#5#1#(1#3) 0#1#5#0#(2#3)
     3#1#4#3#(0#3) 2#1#4#2#(0#3) 1#1#4#1#(1#3) 0#1#4#0#(2#3)
     3#1#3#3#(1#3) 2#1#3#2#(1#3) 1#1#3#1#(2#3) 3#0#5#3#(0#3)
     2#0#5#2#(0#3) 1#0#5#1#(1#3) 0#0#5#0#(2#3) 3#0#4#3#(0#3)
     2#0#4#2#(0#3) 1#0#4#1#(1#3) 0#0#4#0#(2#3) 3#0#3#3#(1#3)
     2#0#3#2#(1#3) 1#0#3#1#(2#3) 3#1#5#3#(1#3) 2#1#5#2#(1#3)
     1#1#5#1#(2#3) 3#1#4#3#(1#3) 2#1#4#2#(1#3) 1#1#4#1#(2#3)
     3#1#3#3#(2#3) 2#1#3#2#(2#3) 3#0#5#3#(1#3) 2#0#5#2#(1#3)
     1#0#5#1#(2#3) 3#0#4#3#(1#3) 2#0#4#2#(1#3) 1#0#4#1#(2#3)
     3#0#3#3#(2#3) 2#0#3#2#(2#3) 3#1#5#3#(2#3) 2#1#5#2#(2#3)
     3#1#4#3#(2#3) 2#1#4#2#(2#3) 3#0#5#3#(2#3) 2#0#5#2#(2#3)
     3#0#4#3#(2#3) 2#0#4#2#(2#3)]

    split #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (0#3)#1#(3#5)#(0#3)#(0#3) (0#3)#0#(3#5)#(0#3)#(0#3)
     (0#3)#1#5#(0#3)#(0#3) (0#3)#1#(3#4)#(0#3)#(0#3)
     (0#3)#0#5#(0#3)#(0#3) (0#3)#0#(3#4)#(0#3)#(0#3)
     (2#3)#1#5#(2#3)#(0#3) (0#1)#1#5#(0#1)#(0#3)
     (0#3)#1#4#(0#3)#(0#3) (0#3)#1#3#(0#3)#(0#3)
     (2#3)#0#5#(2#3)#(0#3) (0#1)#0#5#(0#1)#(0#3)
     (0#3)#0#4#(0#3)#(0#3) (0#3)#0#3#(0#3)#(0#3) 3#1#5#3#(0#3)
     2#1#5#2#(0#3) 1#1#5#1#(0#3) 0#1#5#0#(0#3)
     (2#3)#1#4#(2#3)#(0#3) (0#1)#1#4#(0#1)#(0#3)
     (2#3)#1#3#(2#3)#(0#3) (0#1)#1#3#(0#1)#(0#3) 3#0#5#3#(0#3)
     2#0#5#2#(0#3) 1#0#5#1#(0#3) 0#0#5#0#(0#3)
     (2#3)#0#4#(2#3)#(0#3) (0#1)#0#4#(0#1)#(0#3)
     (2#3)#0#3#(2#3)#(0#3) (0#1)#0#3#(0#1)#(0#3) 3#1#5#3#(2#3)
     3#1#5#3#(0#1) 2#1#5#2#(2#3) 2#1#5#2#(0#1) 1#1#5#1#(2#3)
     1#1#5#1#(0#1) 0#1#5#0#(2#3) 0#1#5#0#(0#1) 3#1#4#3#(0#3)
     2#1#4#2#(0#3) 1#1#4#1#(0#3) 0#1#4#0#(0#3) 3#1#3#3#(0#3)
     2#1#3#2#(0#3) 1#1#3#1#(0#3) 0#1#3#0#(0#3) 3#0#5#3#(2#3)
     3#0#5#3#(0#1) 2#0#5#2#(2#3) 2#0#5#2#(0#1) 1#0#5#1#(2#3)
     1#0#5#1#(0#1) 0#0#5#0#(2#3) 0#0#5#0#(0#1) 3#0#4#3#(0#3)
     2#0#4#2#(0#3) 1#0#4#1#(0#3) 0#0#4#0#(0#3) 3#0#3#3#(0#3)
     2#0#3#2#(0#3) 1#0#3#1#(0#3) 0#0#3#0#(0#3) 3#1#4#3#(2#3)
     3#1#4#3#(0#1) 2#1#4#2#(2#3) 2#1#4#2#(0#1) 1#1#4#1#(2#3)
     1#1#4#1#(0#1) 0#1#4#0#(2#3) 0#1#4#0#(0#1) 3#1#3#3#(2#3)
     3#1#3#3#(0#1) 2#1#3#2#(2#3) 2#1#3#2#(0#1) 1#1#3#1#(2#3)
     1#1#3#1#(0#1) 0#1#3#0#(2#3) 0#1#3#0#(0#1) 3#0#4#3#(2#3)
     3#0#4#3#(0#1) 2#0#4#2#(2#3) 2#0#4#2#(0#1) 1#0#4#1#(2#3)
     1#0#4#1#(0#1) 0#0#4#0#(2#3) 0#0#4#0#(0#1) 3#0#3#3#(2#3)
     3#0#3#3#(0#1) 2#0#3#2#(2#3) 2#0#3#2#(0#1) 1#0#3#1#(2#3)
     1#0#3#1#(0#1) 0#0#3#0#(2#3) 0#0#3#0#(0#1)]

    generic(order:size value:splitMin) #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (0#3)#1#(3#5)#(0#3)#(0#3) (0#3)#0#(3#5)#(0#3)#(0#3)
     (0#3)#1#5#(0#3)#(0#3) (0#3)#1#(3#4)#(0#3)#(0#3)
     (0#3)#0#5#(0#3)#(0#3) (0#3)#0#(3#4)#(0#3)#(0#3)
     (2#3)#1#5#(2#3)#(0#3) (0#1)#1#5#(0#1)#(0#3)
     (0#3)#1#4#(0#3)#(0#3) (0#3)#1#3#(0#3)#(0#3)
     (2#3)#0#5#(2#3)#(0#3) (0#1)#0#5#(0#1)#(0#3)
     (0#3)#0#4#(0#3)#(0#3) (0#3)#0#3#(0#3)#(0#3) 3#1#5#3#(0#3)
     2#1#5#2#(0#3) 1#1#5#1#(0#3) 0#1#5#0#(0#3)
     (2#3)#1#4#(2#3)#(0#3) (0#1)#1#4#(0#1)#(0#3)
     (2#3)#1#3#(2#3)#(0#3) (0#1)#1#3#(0#1)#(0#3) 3#0#5#3#(0#3)
     2#0#5#2#(0#3) 1#0#5#1#(0#3) 0#0#5#0#(0#3)
     (2#3)#0#4#(2#3)#(0#3) (0#1)#0#4#(0#1)#(0#3)
     (2#3)#0#3#(2#3)#(0#3) (0#1)#0#3#(0#1)#(0#3) 3#1#5#3#(2#3)
     3#1#5#3#(0#1) 2#1#5#2#(2#3) 2#1#5#2#(0#1) 1#1#5#1#(2#3)
     1#1#5#1#(0#1) 0#1#5#0#(2#3) 0#1#5#0#(0#1) 3#1#4#3#(0#3)
     2#1#4#2#(0#3) 1#1#4#1#(0#3) 0#1#4#0#(0#3) 3#1#3#3#(0#3)
     2#1#3#2#(0#3) 1#1#3#1#(0#3) 0#1#3#0#(0#3) 3#0#5#3#(2#3)
     3#0#5#3#(0#1) 2#0#5#2#(2#3) 2#0#5#2#(0#1) 1#0#5#1#(2#3)
     1#0#5#1#(0#1) 0#0#5#0#(2#3) 0#0#5#0#(0#1) 3#0#4#3#(0#3)
     2#0#4#2#(0#3) 1#0#4#1#(0#3) 0#0#4#0#(0#3) 3#0#3#3#(0#3)
     2#0#3#2#(0#3) 1#0#3#1#(0#3) 0#0#3#0#(0#3) 3#1#4#3#(2#3)
     3#1#4#3#(0#1) 2#1#4#2#(2#3) 2#1#4#2#(0#1) 1#1#4#1#(2#3)
     1#1#4#1#(0#1) 0#1#4#0#(2#3) 0#1#4#0#(0#1) 3#1#3#3#(2#3)
     3#1#3#3#(0#1) 2#1#3#2#(2#3) 2#1#3#2#(0#1) 1#1#3#1#(2#3)
     1#1#3#1#(0#1) 0#1#3#0#(2#3) 0#1#3#0#(0#1) 3#0#4#3#(2#3)
     3#0#4#3#(0#1) 2#0#4#2#(2#3) 2#0#4#2#(0#1) 1#0#4#1#(2#3)
     1#0#4#1#(0#1) 0#0#4#0#(2#3) 0#0#4#0#(0#1) 3#0#3#3#(2#3)
     3#0#3#3#(0#1) 2#0#3#2#(2#3) 2#0#3#2#(0#1) 1#0#3#1#(2#3)
     1#0#3#1#(0#1) 0#0#3#0#(2#3) 0#0#3#0#(0#1)]

    generic(order:size value:max) #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (0#3)#0#(3#5)#(0#3)#(0#3) (0#3)#1#(3#5)#(0#3)#(0#3)
     (0#3)#0#(3#4)#(0#3)#(0#3) (0#3)#0#5#(0#3)#(0#3)
     (0#3)#1#(3#4)#(0#3)#(0#3) (0#3)#1#5#(0#3)#(0#3)
     (0#3)#0#3#(0#3)#(0#3) (0#3)#0#4#(0#3)#(0#3)
     (0#2)#0#5#(0#2)#(0#3) 3#0#5#3#(0#3)
     (0#3)#1#3#(0#3)#(0#3) (0#3)#1#4#(0#3)#(0#3)
     (0#2)#1#5#(0#2)#(0#3) 3#1#5#3#(0#3)
     (0#2)#0#3#(0#2)#(0#3) 3#0#3#3#(0#3)
     (0#2)#0#4#(0#2)#(0#3) 3#0#4#3#(0#3)
     (0#1)#0#5#(0#1)#(0#3) 2#0#5#2#(0#3) 3#0#5#3#(0#2)
     (0#2)#1#3#(0#2)#(0#3) 3#1#3#3#(0#3)
     (0#2)#1#4#(0#2)#(0#3) 3#1#4#3#(0#3)
     (0#1)#1#5#(0#1)#(0#3) 2#1#5#2#(0#3) 3#1#5#3#(0#2)
     (0#1)#0#3#(0#1)#(0#3) 2#0#3#2#(0#3) 3#0#3#3#(0#2)
     (0#1)#0#4#(0#1)#(0#3) 2#0#4#2#(0#3) 3#0#4#3#(0#2)
     0#0#5#0#(0#3) 1#0#5#1#(0#3) 2#0#5#2#(0#2) 3#0#5#3#(0#1)
     (0#1)#1#3#(0#1)#(0#3) 2#1#3#2#(0#3) 3#1#3#3#(0#2)
     (0#1)#1#4#(0#1)#(0#3) 2#1#4#2#(0#3) 3#1#4#3#(0#2)
     0#1#5#0#(0#3) 1#1#5#1#(0#3) 2#1#5#2#(0#2) 3#1#5#3#(0#1)
     0#0#3#0#(0#3) 1#0#3#1#(0#3) 2#0#3#2#(0#2) 3#0#3#3#(0#1)
     0#0#4#0#(0#3) 1#0#4#1#(0#3) 2#0#4#2#(0#2) 3#0#4#3#(0#1)
     0#0#5#0#(0#2) 1#0#5#1#(0#2) 2#0#5#2#(0#1) 0#1#3#0#(0#3)
     1#1#3#1#(0#3) 2#1#3#2#(0#2) 3#1#3#3#(0#1) 0#1#4#0#(0#3)
     1#1#4#1#(0#3) 2#1#4#2#(0#2) 3#1#4#3#(0#1) 0#1#5#0#(0#2)
     1#1#5#1#(0#2) 2#1#5#2#(0#1) 0#0#3#0#(0#2) 1#0#3#1#(0#2)
     2#0#3#2#(0#1) 0#0#4#0#(0#2) 1#0#4#1#(0#2) 2#0#4#2#(0#1)
     0#0#5#0#(0#1) 1#0#5#1#(0#1) 0#1#3#0#(0#2) 1#1#3#1#(0#2)
     2#1#3#2#(0#1) 0#1#4#0#(0#2) 1#1#4#1#(0#2) 2#1#4#2#(0#1)
     0#1#5#0#(0#1) 1#1#5#1#(0#1) 0#0#3#0#(0#1) 1#0#3#1#(0#1)
     0#0#4#0#(0#1) 1#0#4#1#(0#1) 0#1#3#0#(0#1) 1#1#3#1#(0#1)
     0#1#4#0#(0#1) 1#1#4#1#(0#1)]

    generic(order:naive value:mid) #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     [0 2#3]#(0#1)#(3#5)#[0 2#3]#(0#3)
     1#(0#1)#(3#5)#1#(0#3)
     (2#3)#(0#1)#(3#5)#(2#3)#(0#3) 0#(0#1)#(3#5)#0#(0#3)
     1#1#(3#5)#1#(0#3) 1#0#(3#5)#1#(0#3)
     3#(0#1)#(3#5)#3#(0#3) 2#(0#1)#(3#5)#2#(0#3)
     0#1#(3#5)#0#(0#3) 0#0#(3#5)#0#(0#3) 1#1#[3 5]#1#(0#3)
     1#1#4#1#(0#3) 1#0#[3 5]#1#(0#3) 1#0#4#1#(0#3)
     3#1#(3#5)#3#(0#3) 3#0#(3#5)#3#(0#3) 2#1#(3#5)#2#(0#3)
     2#0#(3#5)#2#(0#3) 0#1#[3 5]#0#(0#3) 0#1#4#0#(0#3)
     0#0#[3 5]#0#(0#3) 0#0#4#0#(0#3) 1#1#5#1#(0#3) 1#1#3#1#(0#3)
     1#1#4#1#[0 2#3] 1#0#5#1#(0#3) 1#0#3#1#(0#3)
     1#0#4#1#[0 2#3] 3#1#[3 5]#3#(0#3) 3#1#4#3#(0#3)
     3#0#[3 5]#3#(0#3) 3#0#4#3#(0#3) 2#1#[3 5]#2#(0#3)
     2#1#4#2#(0#3) 2#0#[3 5]#2#(0#3) 2#0#4#2#(0#3) 0#1#5#0#(0#3)
     0#1#3#0#(0#3) 0#1#4#0#[0 2#3] 0#0#5#0#(0#3) 0#0#3#0#(0#3)
     0#0#4#0#[0 2#3] 1#1#5#1#[0 2#3] 1#1#3#1#[0 2#3]
     1#1#4#1#(2#3) 1#0#5#1#[0 2#3] 1#0#3#1#[0 2#3] 1#0#4#1#(2#3)
     3#1#5#3#(0#3) 3#1#3#3#(0#3) 3#1#4#3#[0 2#3] 3#0#5#3#(0#3)
     3#0#3#3#(0#3) 3#0#4#3#[0 2#3] 2#1#5#2#(0#3) 2#1#3#2#(0#3)
     2#1#4#2#[0 2#3] 2#0#5#2#(0#3) 2#0#3#2#(0#3)
     2#0#4#2#[0 2#3] 0#1#5#0#[0 2#3] 0#1#3#0#[0 2#3]
     0#1#4#0#(2#3) 0#0#5#0#[0 2#3] 0#0#3#0#[0 2#3] 0#0#4#0#(2#3)
     1#1#5#1#(2#3) 1#1#3#1#(2#3) 1#0#5#1#(2#3) 1#0#3#1#(2#3)
     3#1#5#3#[0 2#3] 3#1#3#3#[0 2#3] 3#1#4#3#(2#3)
     3#0#5#3#[0 2#3] 3#0#3#3#[0 2#3] 3#0#4#3#(2#3)
     2#1#5#2#[0 2#3] 2#1#3#2#[0 2#3] 2#1#4#2#(2#3)
     2#0#5#2#[0 2#3] 2#0#3#2#[0 2#3] 2#0#4#2#(2#3) 0#1#5#0#(2#3)
     0#1#3#0#(2#3) 0#0#5#0#(2#3) 0#0#3#0#(2#3) 3#1#5#3#(2#3)
     3#1#3#3#(2#3) 3#0#5#3#(2#3) 3#0#3#3#(2#3) 2#1#5#2#(2#3)
     2#1#3#2#(2#3) 2#0#5#2#(2#3) 2#0#3#2#(2#3)]

    generic(order:nbSusps value:min)      #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (0#3)#(0#1)#(3#5)#(0#3)#(1#3)
     (0#3)#(0#1)#(3#5)#(0#3)#0
     (0#3)#(0#1)#(3#5)#(0#3)#(2#3)
     (0#3)#(0#1)#(3#5)#(0#3)#1 (1#3)#(0#1)#(3#5)#(1#3)#0
     0#(0#1)#(3#5)#0#0 (0#3)#(0#1)#(3#5)#(0#3)#3
     (0#3)#(0#1)#(3#5)#(0#3)#2 (1#3)#(0#1)#(3#5)#(1#3)#1
     0#(0#1)#(3#5)#0#1 (2#3)#(0#1)#(3#5)#(2#3)#0
     1#(0#1)#(3#5)#1#0 0#1#(3#5)#0#0 0#0#(3#5)#0#0
     (1#3)#(0#1)#(3#5)#(1#3)#3 0#(0#1)#(3#5)#0#3
     (1#3)#(0#1)#(3#5)#(1#3)#2 0#(0#1)#(3#5)#0#2
     (2#3)#(0#1)#(3#5)#(2#3)#1 1#(0#1)#(3#5)#1#1 0#1#(3#5)#0#1
     0#0#(3#5)#0#1 3#(0#1)#(3#5)#3#0 2#(0#1)#(3#5)#2#0
     1#1#(3#5)#1#0 1#0#(3#5)#1#0 0#1#(4#5)#0#0 0#0#(4#5)#0#0
     (2#3)#(0#1)#(3#5)#(2#3)#3 1#(0#1)#(3#5)#1#3 0#1#(3#5)#0#3
     0#0#(3#5)#0#3 (2#3)#(0#1)#(3#5)#(2#3)#2 1#(0#1)#(3#5)#1#2
     0#1#(3#5)#0#2 0#0#(3#5)#0#2 3#(0#1)#(3#5)#3#1
     2#(0#1)#(3#5)#2#1 1#1#(3#5)#1#1 1#0#(3#5)#1#1 0#1#(4#5)#0#1
     0#0#(4#5)#0#1 3#1#(3#5)#3#0 3#0#(3#5)#3#0 2#1#(3#5)#2#0
     2#0#(3#5)#2#0 1#1#(4#5)#1#0 1#0#(4#5)#1#0
     3#(0#1)#(3#5)#3#3 2#(0#1)#(3#5)#2#3 1#1#(3#5)#1#3
     1#0#(3#5)#1#3 0#1#(4#5)#0#3 0#0#(4#5)#0#3
     3#(0#1)#(3#5)#3#2 2#(0#1)#(3#5)#2#2 1#1#(3#5)#1#2
     1#0#(3#5)#1#2 0#1#(4#5)#0#2 0#0#(4#5)#0#2 3#1#(3#5)#3#1
     3#0#(3#5)#3#1 2#1#(3#5)#2#1 2#0#(3#5)#2#1 1#1#(4#5)#1#1
     1#0#(4#5)#1#1 3#1#(4#5)#3#0 3#0#(4#5)#3#0 2#1#(4#5)#2#0
     2#0#(4#5)#2#0 3#1#(3#5)#3#3 3#0#(3#5)#3#3 2#1#(3#5)#2#3
     2#0#(3#5)#2#3 1#1#(4#5)#1#3 1#0#(4#5)#1#3 3#1#(3#5)#3#2
     3#0#(3#5)#3#2 2#1#(3#5)#2#2 2#0#(3#5)#2#2 1#1#(4#5)#1#2
     1#0#(4#5)#1#2 3#1#(4#5)#3#1 3#0#(4#5)#3#1 2#1#(4#5)#2#1
     2#0#(4#5)#2#1 3#1#(4#5)#3#3 3#0#(4#5)#3#3 2#1#(4#5)#2#3
     2#0#(4#5)#2#3 3#1#(4#5)#3#2 3#0#(4#5)#3#2 2#1#(4#5)#2#2
     2#0#(4#5)#2#2]

    generic(order:min value:splitMin) #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (2#3)#(0#1)#(3#5)#(2#3)#(0#3)
     (0#1)#(0#1)#(3#5)#(0#1)#(0#3)
     (2#3)#1#(3#5)#(2#3)#(0#3) (2#3)#0#(3#5)#(2#3)#(0#3)
     1#(0#1)#(3#5)#1#(0#3) 0#(0#1)#(3#5)#0#(0#3)
     (2#3)#1#(3#5)#(2#3)#(2#3) (2#3)#1#(3#5)#(2#3)#(0#1)
     (2#3)#0#(3#5)#(2#3)#(2#3) (2#3)#0#(3#5)#(2#3)#(0#1)
     1#1#(3#5)#1#(0#3) 1#0#(3#5)#1#(0#3) 0#1#(3#5)#0#(0#3)
     0#0#(3#5)#0#(0#3) 3#1#(3#5)#3#(2#3) 2#1#(3#5)#2#(2#3)
     (2#3)#1#(3#5)#(2#3)#1 (2#3)#1#(3#5)#(2#3)#0
     3#0#(3#5)#3#(2#3) 2#0#(3#5)#2#(2#3)
     (2#3)#0#(3#5)#(2#3)#1 (2#3)#0#(3#5)#(2#3)#0
     1#1#(3#5)#1#(2#3) 1#1#(3#5)#1#(0#1) 1#0#(3#5)#1#(2#3)
     1#0#(3#5)#1#(0#1) 0#1#(3#5)#0#(2#3) 0#1#(3#5)#0#(0#1)
     0#0#(3#5)#0#(2#3) 0#0#(3#5)#0#(0#1) 3#1#(3#5)#3#3
     3#1#(3#5)#3#2 2#1#(3#5)#2#3 2#1#(3#5)#2#2 3#1#(3#5)#3#1
     2#1#(3#5)#2#1 3#1#(3#5)#3#0 2#1#(3#5)#2#0 3#0#(3#5)#3#3
     3#0#(3#5)#3#2 2#0#(3#5)#2#3 2#0#(3#5)#2#2 3#0#(3#5)#3#1
     2#0#(3#5)#2#1 3#0#(3#5)#3#0 2#0#(3#5)#2#0 1#1#(3#5)#1#3
     1#1#(3#5)#1#2 1#1#(3#5)#1#1 1#1#(3#5)#1#0 1#0#(3#5)#1#3
     1#0#(3#5)#1#2 1#0#(3#5)#1#1 1#0#(3#5)#1#0 0#1#(3#5)#0#3
     0#1#(3#5)#0#2 0#1#(3#5)#0#1 0#1#(3#5)#0#0 0#0#(3#5)#0#3
     0#0#(3#5)#0#2 0#0#(3#5)#0#1 0#0#(3#5)#0#0 3#1#(3#4)#3#3
     3#1#(3#4)#3#2 2#1#(3#4)#2#3 2#1#(3#4)#2#2 3#1#(3#4)#3#1
     2#1#(3#4)#2#1 3#1#(3#4)#3#0 2#1#(3#4)#2#0 3#0#(3#4)#3#3
     3#0#(3#4)#3#2 2#0#(3#4)#2#3 2#0#(3#4)#2#2 3#0#(3#4)#3#1
     2#0#(3#4)#2#1 3#0#(3#4)#3#0 2#0#(3#4)#2#0 1#1#(3#4)#1#3
     1#1#(3#4)#1#2 1#1#(3#4)#1#1 1#1#(3#4)#1#0 1#0#(3#4)#1#3
     1#0#(3#4)#1#2 1#0#(3#4)#1#1 1#0#(3#4)#1#0 0#1#(3#4)#0#3
     0#1#(3#4)#0#2 0#1#(3#4)#0#1 0#1#(3#4)#0#0 0#0#(3#4)#0#3
     0#0#(3#4)#0#2 0#0#(3#4)#0#1 0#0#(3#4)#0#0]

    generic(order:max value:splitMax) #
    [(0#3)#(0#1)#(3#5)#(0#3)#(0#3)
     (0#3)#(0#1)#(3#4)#(0#3)#(0#3)
     (0#3)#(0#1)#5#(0#3)#(0#3) (0#3)#(0#1)#3#(0#3)#(0#3)
     (0#3)#(0#1)#4#(0#3)#(0#3) (0#1)#(0#1)#5#(0#1)#(0#3)
     (2#3)#(0#1)#5#(2#3)#(0#3) (0#1)#(0#1)#3#(0#1)#(0#3)
     (2#3)#(0#1)#3#(2#3)#(0#3) (0#1)#(0#1)#4#(0#1)#(0#3)
     (2#3)#(0#1)#4#(2#3)#(0#3) (0#1)#(0#1)#5#(0#1)#(0#1)
     (0#1)#(0#1)#5#(0#1)#(2#3) 2#(0#1)#5#2#(0#3)
     3#(0#1)#5#3#(0#3) (0#1)#(0#1)#3#(0#1)#(0#1)
     (0#1)#(0#1)#3#(0#1)#(2#3) 2#(0#1)#3#2#(0#3)
     3#(0#1)#3#3#(0#3) (0#1)#(0#1)#4#(0#1)#(0#1)
     (0#1)#(0#1)#4#(0#1)#(2#3) 2#(0#1)#4#2#(0#3)
     3#(0#1)#4#3#(0#3) 0#(0#1)#5#0#(0#1) 1#(0#1)#5#1#(0#1)
     (0#1)#(0#1)#5#(0#1)#2 (0#1)#(0#1)#5#(0#1)#3
     2#(0#1)#5#2#(0#1) 2#(0#1)#5#2#(2#3) 3#(0#1)#5#3#(0#1)
     3#(0#1)#5#3#(2#3) 0#(0#1)#3#0#(0#1) 1#(0#1)#3#1#(0#1)
     (0#1)#(0#1)#3#(0#1)#2 (0#1)#(0#1)#3#(0#1)#3
     2#(0#1)#3#2#(0#1) 2#(0#1)#3#2#(2#3) 3#(0#1)#3#3#(0#1)
     3#(0#1)#3#3#(2#3) 0#(0#1)#4#0#(0#1) 1#(0#1)#4#1#(0#1)
     (0#1)#(0#1)#4#(0#1)#2 (0#1)#(0#1)#4#(0#1)#3
     2#(0#1)#4#2#(0#1) 2#(0#1)#4#2#(2#3) 3#(0#1)#4#3#(0#1)
     3#(0#1)#4#3#(2#3) 0#0#5#0#(0#1) 0#1#5#0#(0#1) 1#0#5#1#(0#1)
     1#1#5#1#(0#1) 0#(0#1)#5#0#2 1#(0#1)#5#1#2 0#(0#1)#5#0#3
     1#(0#1)#5#1#3 2#0#5#2#(0#1) 2#1#5#2#(0#1) 2#(0#1)#5#2#2
     2#(0#1)#5#2#3 3#0#5#3#(0#1) 3#1#5#3#(0#1) 3#(0#1)#5#3#2
     3#(0#1)#5#3#3 0#0#3#0#(0#1) 0#1#3#0#(0#1) 1#0#3#1#(0#1)
     1#1#3#1#(0#1) 0#(0#1)#3#0#2 1#(0#1)#3#1#2 0#(0#1)#3#0#3
     1#(0#1)#3#1#3 2#0#3#2#(0#1) 2#1#3#2#(0#1) 2#(0#1)#3#2#2
     2#(0#1)#3#2#3 3#0#3#3#(0#1) 3#1#3#3#(0#1) 3#(0#1)#3#3#2
     3#(0#1)#3#3#3 0#0#4#0#(0#1) 0#1#4#0#(0#1) 1#0#4#1#(0#1)
     1#1#4#1#(0#1) 0#(0#1)#4#0#2 1#(0#1)#4#1#2 0#(0#1)#4#0#3
     1#(0#1)#4#1#3 2#0#4#2#(0#1) 2#1#4#2#(0#1) 2#(0#1)#4#2#2
     2#(0#1)#4#2#3 3#0#4#3#(0#1) 3#1#4#3#(0#1) 3#(0#1)#4#3#2
     3#(0#1)#4#3#3]
   ]

in

   functor

   import
      FD
      Space

   export
      Return
   define

         local
            fun {AllSpaces Ss Ps}
               case Ss of nil then Ps else
                  Ns={FoldR Ss fun {$ S Ss}
                                  case {Space.ask S}
                                  of failed          then Ss
                                  [] succeeded       then Ss
                                  [] alternatives(N) then
                                     {ForThread 1 N 1
                                      fun {$ Ss I}
                                         C={Space.clone S}
                                      in
                                         {Space.commit C I}
                                         C|Ss
                                      end Ss}
                                  end
                               end nil}
               in
                  {AllSpaces Ns {Append Ps Ss}}
               end
            end

            proc {CreateSusp X}
               thread {Wait X} end
            end

            fun {MakeScript Strategy}
               proc {$ S}
                  X#Y#Z#X#U = S
               in
                  X :: 0 # 3
                  Y :: 0 # 1 % Boolean!!
                  Z :: 3 # 5
                  U :: 0 # 3
                  {CreateSusp X}
                  {CreateSusp X}
                  {CreateSusp U}
                  {CreateSusp U}
                  {CreateSusp U}
                  {CreateSusp U}
                  {FD.distribute Strategy S}
               end
            end
         in
            fun {MakeTest Strategy}
               fun {$}
                  {Map {Filter {AllSpaces [{Space.new {MakeScript Strategy}}] nil}
                        fun {$ S}
                           case {Space.ask S} of alternatives(_) then true
                           else false
                           end
                        end}
                   Space.merge}
               end
            end
         end

         local
            fun {GetDom X}
               case {FD.reflect.dom X}
               of [D] then D
               elseof Is then Is
               end
            end

            fun {Check X#Y}
               {Record.all {Record.zip X Y fun {$ X Y} X#Y end}
                fun {$ X#Y}
                   {GetDom X} == Y
                end}
            end
         in
            fun {MakeProof Ss}
               fun {$ Ts}
                  {Length Ts}=={Length Ss} andthen
                  {All {List.zip Ts Ss fun {$ X Y} X#Y end} Check}
               end
            end
         end

         Return=
         fd([distribute({Map Tests
                         fun {$ K#R}
                            L = if  {IsAtom K} then K
                                else generic(order:O value:V)=K in
                                   {String.toAtom {Append
                                                   {Atom.toString O}
                                                   &_|{Atom.toString V}}}
                                end
                         in
                            L(test({MakeTest K}
                                   {MakeProof R})
                              keys: [fd distribute])
                         end})])
      end

end
