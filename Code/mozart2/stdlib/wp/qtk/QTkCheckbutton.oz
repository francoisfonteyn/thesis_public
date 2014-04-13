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
   Tk
   QTkDevel(splitParams:        SplitParams
            tkInit:             TkInit
            init:               Init
            assert:             Assert
            execTk:             ExecTk
            returnTk:           ReturnTk
            qTkClass:           QTkClass
            globalInitType:     GlobalInitType
            globalUnsetType:    GlobalUnsetType
            globalUngetType:    GlobalUngetType)

export
   Register

define

   class QTkCheckbutton

      feat
         Return
         TkVar
         widgetType:checkbutton
         action
         typeInfo:r(all:{Record.adjoin GlobalInitType
                         r(1:boolean
                           init:boolean
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
                           height:pixel
                           indicatoron:boolean
                           selectcolor:color
                           selectimage:image
                           state:[normal disabled active]
                           width:pixel
                           ipadx:pixel
                           ipady:pixel
                           action:action)}
                    uninit:r(1:unit)
                    unset:{Record.adjoin GlobalUnsetType
                           r(init:unit)}
                    unget:{Record.adjoin GlobalUngetType
                           r(init:unit
                             bitmap:unit
                             image:unit
                             selectimage:unit
                             font:unit
                             key:unit)}
                   )

      from Tk.checkbutton QTkClass

      meth !Init(...)=M
         lock
            A B
         in
            QTkClass,M
            self.Return={CondSelect M return _}
            {SplitParams M [ipadx ipady init] A B}
            self.TkVar={New Tk.variable tkInit({CondSelect M init false})}
            Tk.checkbutton,{Record.adjoin {TkInit A} tkInit(padx:{CondSelect B ipadx 2}
                                                            pady:{CondSelect B ipady 2}
                                                            action:{self.action action($)}
                                                            variable:self.TkVar
                                                           )}
         end
      end

      meth destroy
         self.Return={self.TkVar tkReturn($)}=="1"
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
                of 1 then {self.TkVar tkSet(V)}
                [] ipadx then {ExecTk self configure(padx:V)}
                [] ipady then {ExecTk self configure(pady:V)}
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
                of 1 then  V={self.TkVar tkReturn($)}=="1"
                [] ipadx then {ReturnTk self cget("-padx" V) natural}
                [] ipady then {ReturnTk self cget("-pady" V) natural}
                end
             end}
         end
      end

      meth flash
         lock
            Tk.radiobutton,tk(flash)
         end
      end


   end

   Register=[r(widgetType:checkbutton
               feature:false
               widget:QTkCheckbutton)]
end
