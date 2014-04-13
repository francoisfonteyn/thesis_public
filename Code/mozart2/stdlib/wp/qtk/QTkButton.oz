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


functor

import
   OS
   Tk
   QTkDevel(splitParams:        SplitParams
            tkInit:             TkInit
            init:               Init
            assert:             Assert
            qTkClass:           QTkClass
            execTk:             ExecTk
            returnTk:           ReturnTk
            globalInitType:     GlobalInitType
            globalUnsetType:    GlobalUnsetType
            globalUngetType:    GlobalUngetType)

export
   Register

define

   %IsDarwin=({OS.uName}.sysname=="Darwin")
   IsDarwin = OS.fopen == OS.fclose % of course always false
   DPadx#DPady=if IsDarwin then 10#1 else 0#0 end
   class QTkButton

      feat
         Return
         widgetType:button
         action
         typeInfo:r(all:{Record.adjoin GlobalInitType
                         r(1:vs
                           init:vs
                           return:free
                           activebackground:color
                           activeforeground:color
                           anchor:[n ne e se s sw w nw center]
                           background:color bg:color
                           bitmap:bitmap
                           borderwidth:pixel
                           cursor:cursor
                           disabledforeground:color
                           font:font
                           foreground:color fg:color
                           highlightbackground:color
                           highlightcolor:color
                           highlightthickness:pixel
                           image:image
                           justify:[left right center]
                           relief:relief
                           takefocus:boolean
                           text:vs
                           underline:natural
                           wraplength:pixel
                           ipadx:pixel
                           ipady:pixel
                           action:action
                           default:[normal disabled active]
                           height:pixel
                           state:[normal disabled active]
                           width:pixel
                           key:vs
                          )}
                    uninit:r(1:unit)
                    unset:{Record.adjoin GlobalUnsetType
                           r(init:unit
                             return:unit
                             key:unit)}
                    unget:{Record.adjoin GlobalUngetType
                           r(init:unit
                             bitmap:bitmap
                             image:image
                             font:font
                             return:unit
                             key:unit)}
                   )

      from Tk.button QTkClass

      meth !Init(...)=M
         lock
            A B
         in
            QTkClass,M
            self.Return={CondSelect M return _}
            {SplitParams M [ipadx ipady init key] A B}
            Tk.button,{Record.adjoin {TkInit A}
                                   tkInit(padx:{CondSelect B ipadx 2}+DPadx
                                                  pady:{CondSelect B ipady 2}+DPady
                                                  text:{CondSelect B init {CondSelect A text ""}}
                                                  action:self.toplevel.port#r(self Execute)
                                                 )}
            if {HasFeature B key} then
               if {Tk.returnInt 'catch'(v("{") bind self.toplevel "<"#M.key#">" v("{info library}") v("}"))}==0 then
                  {self.toplevel tkBind(event:"<"#M.key#">" action:self.toplevel.port#r(self Execute))}
               else
                  {Exception.raiseError qtk(typeError key button "A virtual string representing a valid key" M)}
               end
            end
         end
      end

      meth destroy
         lock
            self.Return={self.toplevel getDestroyer($)}==self
         end
      end

      meth Execute
         lock
            {self.toplevel setDestroyer(self)}
            {self.action execute}
         end
      end

      meth set(...)=M
         lock
            A B
         in
            {SplitParams M [1 ipadx ipady] A B}
            QTkClass,A
            {Assert self.widgetType self.typeInfo B}
            {Record.forAllInd B
             proc{$ I V}
                case I
                of 1 then QTkClass,set(text:V)
                [] ipadx then {ExecTk self configure(padx:V+DPadx)}
                [] ipady then {ExecTk self configure(pady:V+DPady)}
                end
             end}
         end
      end

      meth get(...)=M
         lock
            A B
         in
            {SplitParams M [1 ipadx ipady] A B}
            QTkClass,A
            {Assert self.widgetType self.typeInfo B}
            {Record.forAllInd B
             proc{$ I V}
                case I
                of 1 then QTkClass,get(text:V)
                [] ipadx then V={ReturnTk self cget("-padx" $) natural}-DPadx
                [] ipady then V={ReturnTk self cget("-pady" $) natural}-DPady
                end
             end}
         end
      end

   end

   Register=[r(widgetType:button
               feature:false
               widget:QTkButton)]

end
