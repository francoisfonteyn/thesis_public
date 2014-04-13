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
            qTkClass:           QTkClass
            globalInitType:     GlobalInitType
            globalUnsetType:    GlobalUnsetType
            globalUngetType:    GlobalUngetType)

export
   Register

define

   fun{QTkScale WidgetType}
      class $

         feat
            Return TkVar
            widgetType:WidgetType
            action
            typeInfo:r(all:{Record.adjoin GlobalInitType
                            r(1:float
                              init:float
                              return:free
                              activebackground:color
                              background:color bg:color
                              borderwidth:pixel
                              cursor:cursor
                              font:font
                              foreground:color fg:color
                              highlightbackground:color
                              highlightcolor:color
                              highlightthickness:pixel
                              relief:relief
                              repeatdelay:natural
                              repeatinterval:natural
                              takefocus:boolean
                              troughcolor:color
                              bigincrement:float
                              digits:natural
                              'from':float
                              label:vs
                              length:pixel
                              resolution:float
                              showvalue:boolean
                              sliderlength:pixel
                              sliderrelief:relief
                              state:[normal active disabled]
                              tickinterval:float
                              to:float
                              width:pixel
                              action:action
                             )}
                       uninit:r(1:unit)
                       unset:{Record.adjoin GlobalUnsetType
                              r(init:unit)}
                       unget:{Record.adjoin GlobalUngetType
                              r(init:unit
                                bitmap:bitmap
                                font:font)}
                      )

         from Tk.scale QTkClass

         meth !Init(...)=M
            lock
               A B P
               Orient=if WidgetType==tdscale then vert else horiz end
            in
               QTkClass,M
               P={self.action get($)}
               {self.action set(proc{$} skip end)}
               self.Return={CondSelect M return _}
               {SplitParams M [init] A B}
               self.TkVar={New Tk.variable tkInit({CondSelect B init 0.0})}
               Tk.scale,{Record.adjoin {TkInit A} tkInit(action:self.toplevel.port#r(self Execute)
                                                         variable:self.TkVar
                                                         orient:Orient
                                                        )}
               {self.action set(P)}
            end
         end

         meth Execute(...)
            lock
               {self.action execute}
            end
         end

         meth destroy
            lock
               {self get(self.Return)}
            end
         end

         meth set(...)=M
            lock
               A B
            in
               {SplitParams M [1] A B}
               QTkClass,A
               {Assert self.widgetType self.typeInfo B}
               {Record.forAllInd B
                proc{$ I V}
                   case I
                   of 1 then {self.TkVar tkSet(V)}
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
                   of 1 then
                      {self.TkVar tkReturnFloat(V)}
                      {Wait V}
                   end
                end}
            end
         end

      end
   end

   Register=[r(widgetType:tdscale
               feature:false
               widget:{QTkScale tdscale})
             r(widgetType:lrscale
               feature:false
               widget:{QTkScale lrscale})]

end
