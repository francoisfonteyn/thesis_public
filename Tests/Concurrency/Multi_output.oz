%%
%% Author:
%%     Francois Fonteyn, 2014
%%

%% feed paragraph to see it execute
local
   Xs Ys1 Ys2
in
   {Browse 'Xs  '#Xs}
   {Browse 'Ys1 '#Ys1}
   {Browse 'Ys2 '#Ys2}
   thread Xs = [A suchthat lazy A in 10..25 do {Delay 1000}] end
   thread Ys1#Ys2 = [2*A if A mod 2 == 1 3*A if A mod 2 == 0 suchthat A in Xs] end
   % thread Ys1#Ys2 = [1:collect:C1 2:collect:C2 suchthat A in Xs do
   %                                                if A mod 2 == 1 then {C1 2*A}
   %                                                else {C2 3*A}
   %                                                end]
   % end
end

