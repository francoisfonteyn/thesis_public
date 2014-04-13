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

   class QTkLabel

      feat
         Return
         widgetType:label
         typeInfo:r(all:{Record.adjoin GlobalInitType
                         r(1:vs
                           init:vs
                           return:free
                           anchor:[n ne e se s sw w nw center]
                           background:color bg:color
                           bitmap:bitmap
                           borderwidth:pixel
                           cursor:cursor
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
                           width:natural
                           height:natural
                           wraplength:pixel
                           ipadx:pixel
                           ipady:pixel)}
                    uninit:r(1:unit)
                    unset:{Record.adjoin GlobalUnsetType
                           r(init:unit)}
                    unget:{Record.adjoin GlobalUngetType
                           r(init:unit
                             bitmap:unit
                             image:unit
                             font:unit)}
                   )

      from Tk.label QTkClass

      meth !Init(...)=M
         lock
            A B
         in
            QTkClass,M
            self.Return={CondSelect M return _}
            {SplitParams M [ipadx ipady init] A B}
            Tk.label,{Record.adjoin {TkInit A} tkInit(padx:{CondSelect B ipadx 0}
                                                      pady:{CondSelect B ipady 0}
                                                      text:{CondSelect B init {CondSelect A text ""}})}
         end
      end

      meth destroy
         lock
            QTkClass,get(text:self.Return)
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
                of 1 then QTkClass,get(text:V)
                [] ipadx then {ReturnTk self cget("-padx" V) natural}
                [] ipady then {ReturnTk self cget("-pady" V) natural}
                end
             end}
         end
      end

   end

   class QTkMessage

      feat
         Return
         widgetType:message
         typeInfo:r(all:{Record.adjoin GlobalInitType
                         r(1:vs
                           init:vs
                           return:free
                           anchor:[n ne e se s sw w nw center]
                           background:color bg:color
                           borderwidth:pixel
                           cursor:cursor
                           font:font
                           foreground:color fg:color
                           highlightbackground:color
                           highlightcolor:color
                           highlightthickness:pixel
                           justify:[left right center]
                           relief:relief
                           takefocus:boolean
                           text:vs
                           aspect:natural
                           ipadx:pixel
                           ipady:pixel)}
                    uninit:r(1:unit)
                    unset:{Record.adjoin GlobalUnsetType
                           r(init:unit)}
                    unget:{Record.adjoin GlobalUngetType
                           r(init:unit
                             font:unit)}
                   )

      from Tk.message QTkClass

      meth !Init(...)=M
         lock
            A B
         in
            QTkClass,M
            self.Return={CondSelect M return _}
            {SplitParams M [ipadx ipady init] A B}
            Tk.message,{Record.adjoin {TkInit A} tkInit(padx:{CondSelect B ipadx 0}
                                                        pady:{CondSelect B ipady 0}
                                                        text:{CondSelect B init {CondSelect A text ""}})}
         end
      end

      meth destroy
         lock
            QTkClass,get(text:self.Return)
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
                of 1 then QTkClass,get(text:V)
                [] ipadx then {ReturnTk self cget("-padx" V) natural}
                [] ipady then {ReturnTk self cget("-pady" V) natural}
                end
             end}
         end
      end

   end

   Register=[r(widgetType:label
               feature:false
               widget:QTkLabel)
             r(widgetType:message
               feature:false
               widget:QTkMessage)]

end
