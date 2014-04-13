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
            convertToType:      ConvertToType
            vS2Tk:              VS2Tk
            globalInitType:     GlobalInitType
            globalUnsetType:    GlobalUnsetType
            globalUngetType:    GlobalUngetType)

export
   Register

define

   WidgetType=entry
   Feature=scroll

   class QTkEntry

      feat
         Return TkVar
         widgetType:WidgetType
         action
         typeInfo:r(all:{Record.adjoin GlobalInitType
                         r(1:vs
                           init:vs
                           return:free
                           background:color bg:color
                           borderwidth:pixel
                           cursor:cursor
                           exportselection:boolean
                           font:font
                           foreground:color fg:color
                           highlightbackground:color
                           highlightcolor:color
                           highlightthickness:pixel
                           insertbackground:color
                           insertborderwidth:pixel
                           insertofftime:natural
                           insertontime:natural
                           insertwidth:pixel
                           justify:[left center right]
                           relief:relief
                           selectbackground:color
                           selectborderwidth:pixel
                           selectforeground:color
                           takefocus:boolean
                           show:vs
                           state:[normal disabled]
                           width:natural
                           action:action
                           lrscrollbar:boolean
                           scrollwidth:pixel
                           selectionfrom:natural
                           selectionto:natural
                          )}
                    uninit:r(1:unit
                             selectionfrom:unit
                             selectionto:unit)
                    unset:{Record.adjoin GlobalUnsetType
                           r(init:unit
                             lrscrollbar:unit
                             scrollwidth:unit)}
                    unget:{Record.adjoin GlobalUngetType
                           r(init:unit
                             font:unit
                             lrscrollbar:unit
                             scrollwidth:unit
                             selectionfrom:unit
                             selectionto:unit)}
                   )

      from Tk.entry QTkClass

      meth !Init(...)=M
         lock
            A B
         in
            QTkClass,M
            self.Return={CondSelect M return _}
            {SplitParams M [init lrscrollbar scrollwidth] A B}
            self.TkVar={New Tk.variable tkInit("")}
            Tk.entry,{Record.adjoin {TkInit A} tkInit(textvariable:self.TkVar)}
            Tk.entry,tkBind(event:"<KeyRelease>" action:{self.action action($)})
            Tk.entry,tk(insert 0 {CondSelect B init ""})
            Tk.entry,tkBind(event:"<FocusIn>"
                            action:proc{$}
                                      {self tk(selection 'from' 0)}
                                      {self tk(selection 'to' 'end')}
                                   end)
            Tk.entry,tkBind(event:"<FocusOut>"
                            action:proc{$}
                                      {self tk(selection clear)}
                                   end)
         end
      end

      meth destroy
         lock
            self.Return={self.TkVar tkReturn($)}
            {Wait self.Return}
         end
      end

      meth set(...)=M
         lock
            A B
         in
            {SplitParams M [1 selectionfrom selectionto] A B}
            QTkClass,A
            {Assert self.widgetType self.typeInfo B}
            {Record.forAllInd B
             proc{$ I V}
                case I
                of 1 then {self.TkVar tkSet({VS2Tk V})}
                [] selectionfrom then {ExecTk self selection('from' V)}
                [] selectionto then {ExecTk self selection(to V)}
                end
             end}
         end
      end

      meth get(...)=M
         lock
            A B
         in
            {SplitParams M [1] A B}
            QTkClass,A
            {Assert self.widgetType self.typeInfo B}
            {Record.forAllInd B
             proc{$ I V}
                case I
                of 1 then V={ConvertToType {self.TkVar tkReturn($)} vs}
                end
                {Wait V}
             end}
         end
      end

      meth icursor(...)=M
         lock
            {ExecTk self M}
         end
      end

      meth index(...)=M
         lock
            {ReturnTk self M natural}
         end
      end

      meth scan(...)=M
         lock
            {ExecTk self M}
         end
      end

   end

   Register=[r(widgetType:WidgetType
               feature:Feature
               widget:QTkEntry)]

end
