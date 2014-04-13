%
% Authors:
%   Donatien Grolaux (2000)
%
% Copyright:
%   (c) 2000 Universit� catholique de Louvain
%
% Last change:
%   $Date$ by $Author$
%   $Revision$
%
% This file is part of Mozart, an implementation
% of Oz 3:
%   http://www.mozart-oz.org
%
% See the file "LICENSE" or
%   http://www.mozart-oz.org/LICENSE.html
% for information on usage and redistribution
% of this file, and for a DISCLAIMER OF ALL
% WARRANTIES.
%
%  The development of QTk is supported by the PIRATES project at
%  the Universit� catholique de Louvain.

local
   Init={NewName}
   class DialogBoxC
      meth !Init skip end
      meth Diag(cmd:_
                defaultextension:_ <= _
                filetypes:_        <= _
                initialdir:_       <= _
                initialfile:_      <= _
                title:_            <= _
                1:_) = M
         {Record.forAllInd M
          proc{$ I V}
             Err={CheckType
                  case I
                  of cmd then [tk_getSaveFile tk_getOpenFile]
                  [] defaultextension then vs
                  [] filetypes then no
                  [] initialdir then vs
                  [] initialfile then vs
                  [] title then vs
                  [] 1 then free end
                  V}
          in
             if Err==unit then skip else
                {Exception.raiseError qtk(typeError I dialogbox Err M)}
             end
          end}
         {ReturnTk unit {Record.subtract {Record.adjoin M M.cmd} cmd} vs}
      end
      meth save(...)=M
         {self {Record.adjoin M Diag(cmd:tk_getSaveFile)}}
      end
      meth load(...)=M
         {self {Record.adjoin M Diag(cmd:tk_getOpenFile)}}
      end
      meth chooseDirectory(initialdir:_ <=_
                           title:_ <=_
                           mustexist:_ <=_
                           1:_)=M
         {Record.forAllInd M
          proc{$ I V}
             Err={CheckType
                  case I
                  of initialdir then vs
                  [] title then vs
                  [] mustexist then boolean
                  [] 1 then free
                  end V}
          in
             if Err==unit then skip else
                {Exception.raiseError qtk(typeError I dialogbox Err M)}
             end
          end}
         try
            {ReturnTk unit {Record.adjoin M tk_chooseDirectory} vs}
         catch _ then M.1=nil end
      end
      meth color(initialcolor:_  <= _
                 title:_         <= _
                 1:_)=M
         {Record.forAllInd M
          proc{$ I V}
             Err={CheckType
                  case I
                  of initialcolor then color
                  [] title then vs
                  [] 1 then free end
                  V}
          in
             if Err==unit then skip else
                {Exception.raiseError qtk(typeError I dialogbox Err M)}
             end
          end}
         try
            {ReturnTk unit {Record.adjoin M tk_chooseColor} color}
         catch _ then M.1=nil end
      end
      meth printcanvas(1:_ ...)=M
         R={PrintCanvas.getPSOptions {Record.subtract M 1}}
      in
         M.1=if R=='' then nil else R end
      end

   end
in
   DialogBox={New DialogBoxC Init}
end
