%%% Copyright © 2014, Université catholique de Louvain
%%% All rights reserved.
%%%
%%% Redistribution and use in source and binary forms, with or without
%%% modification, are permitted provided that the following conditions are met:
%%%
%%% *  Redistributions of source code must retain the above copyright notice,
%%%    this list of conditions and the following disclaimer.
%%% *  Redistributions in binary form must reproduce the above copyright notice,
%%%    this list of conditions and the following disclaimer in the documentation
%%%    and/or other materials provided with the distribution.
%%%
%%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%%% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%%% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%%% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
%%% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%%% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%%% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%%% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%%% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%%% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%%% POSSIBILITY OF SUCH DAMAGE.

%% Explanations related to this file are in
%% https://github.com/francoisfonteyn/thesis_public/blob/master/Thesis.pdf
%% Complete syntax
%% https://github.com/francoisfonteyn/thesis_public/blob/master/Syntax_unofficial.pdf

functor
import
   BootName(newNamed:NewNamedName) at 'x-oz://boot/Name'

export
   Compile

define
   %% create a new variable named Name
   fun {MakeVar Name}
      fVar({NewNamedName Name} unit)
   end
   %% create a new variable named by the concatenation of Name and Index
   %% Name : atom
   %% Index : positive int
   fun {MakeVarIndex Name Index}
      fVar({NewNamedName {VirtualString.toAtom Name#Index}} unit)
   end
   %% create a new variable named by the concatenation of Name1, Index1, Name2 and Index2
   %% Name_ : atom
   %% Index_ : positive int
   fun {MakeVarIndexIndex Name1 Index1 Name2 Index2}
      fVar({NewNamedName {VirtualString.toAtom Name1#Index1#Name2#Index2}} unit)
   end
   %% returns Coord with its label set to pos --> pos(...same as what was in Coord...)
   %% if Coord == unit then pos end
   fun {CoordNoDebug Coord}
      case {Label Coord}
      of pos then Coord
      else {Adjoin Coord pos}
      end
   end
   NIL = fAtom(nil unit)
   HASH = fAtom('#' unit)
   INT1 = fInt(1 unit)
   INT2 = fInt(2 unit)
   %%==================================================
   %%==================================================
   %% the actual exported function called by Unnester
   %% returns the AST with the mode fListComprehensions
   %% replaced by its transformation
   %% Argument : the fListComprehension node
   fun {Compile fListComprehension(EXPR_LIST FOR_COMPREHENSION_LIST BODY COORDS)}
      %% name of FindNext if at least one range generator is forRecord, unbound otherwise
      FindNextDFS
      FindNextDFSFun
      %% unit if return list instead of record
      ReturnList
      %% used to keep track of all the (level) procedures to declare (see List2fAnds)
      %% used to keep trakc of all the bounds of range to declare e.g. Low..High (see List2fAnds)
      DeclarationsDictionary = {Dictionary.new}
      proc {PutDecl Name Value}
         {Dictionary.put DeclarationsDictionary Name Value}
      end
      proc {PutDeclIndex Name Index Value}
         {PutDecl {VirtualString.toAtom Name#Index} Value}
      end
      %% returns an AST rooted at fAnd(...)
      %% to declare everything inside DeclarationsDictionary (levels, ...)
      fun {List2fAndsDico}
         {List2fAnds {Dictionary.items DeclarationsDictionary}}
      end
      %% efficiently puts all the elements in the list List into fAnd's (no fSkip execpt if nil)
      %% returns an AST rooted at fAnd(...) if at least 2 elements
      %% returns first element is only one
      %% returns fSkip(unit) if none
      fun {List2fAnds List}
         case List
         of nil   then fSkip(unit)
         [] H|nil then H
         [] H|T   then fAnd(H {List2fAnds T})
         end
      end
      %% returns a fLocal AST node with
      %% Decls as declarations
      %% Body as body
      %% EXCEPTION: if Decls is empty then returns only Body
      fun {LocalsIn Decls Body}
         if Decls == nil then
            Body
         else
            fLocal({List2fAnds Decls} Body unit)
         end
      end
      %% transforms a non-empty list: [e1 ... e2]
      %% into an AST list: fRecord(...)
      fun {LogicList2ASTList Fields}
         proc {Aux Fs Next}
            case Fs
            of H|nil then
               Next = fRecord(fAtom('|' unit) [H NIL])
            [] H|T then N in
               Next = fRecord(fAtom('|' unit) [H N])
               {Aux T N}
            end
         end
      in
         {Aux Fields}
      end
      %% declare the cell and collector for a collect output
      %% returns the name of the cell
      fun {DeclareCollector FeatVar CollVar}
         CellVar = {MakeVarIndex 'Cell' FeatVar.1}
         ElemVar = {MakeVar 'Elem'}
         NextVar = {MakeVar 'Next'}
      in
         %% add cell
         {PutDeclIndex 'Cell' FeatVar.1
          fEq(CellVar
              fApply(fVar('NewCell' unit)
                     [fWildcard(unit)]
                     unit)
              unit)}
         %% add procedure
         {PutDeclIndex 'Collector' FeatVar.1
          fProc(%% name
                CollVar
                %% arguments
                [ElemVar]
                %% body
                fLocal(%% decl
                       NextVar
                       %% body
                       fApply(fVar('Exchange' unit)
                              [CellVar fRecord(fAtom('|' unit) [ElemVar NextVar]) NextVar]
                              unit)
                       %% position
                       unit)
                %% flags
                nil
                %% position
                COORDS)}
         CellVar
      end
      %% push to FindNextDFS in dictionary
      %% returns its name
      %% WithFun : true if proc with Fun arg, false otherwise
      fun {PutFindNextDFS WithFun}
         Name = {MakeVar 'FindNext'}
         Result = {MakeVar 'ResultDFS'}
         FeatStack = {MakeVar 'FeatStack'}
         ValueStack = {MakeVar 'ValueStack'}
         Feat = {MakeVar 'Feat'}
         Value = {MakeVar 'Value'}
         PoppedFeatStack = {MakeVar 'PoppedFeatStack'}
         PoppedValueStack = {MakeVar 'PoppedValueStack'}
         Fun = {MakeVar 'Fun'}
         Index = if WithFun then 1 else 0 end
      in
         {PutDeclIndex 'FindNext' Index
          fProc(%% name
                Name
                %% arguments
                if WithFun then
                   [fRecord(fAtom(stacks unit) [FeatStack ValueStack]) Fun Result]
                else
                   [fRecord(fAtom(stacks unit) [FeatStack ValueStack]) Result]
                end
                %% body
                fLocal(%% decl
                       fAnd(fEq(Feat fOpApply('.' [FeatStack INT1] unit) unit)
                            fAnd(fEq(Value fOpApply('.' [ValueStack INT1] unit) unit)
                                 fAnd(fEq(PoppedFeatStack fOpApply('.' [FeatStack INT2] unit) unit)
                                      fEq(PoppedValueStack fOpApply('.' [ValueStack INT2] unit) unit))))
                       %% body
                       fBoolCase(%% condition
                                 if WithFun then
                                    fAndThen(fApply(fVar('IsRecord' unit) [Value] unit)
                                             fAndThen(fOpApply('\\=' [fApply(fVar('Arity' unit) [Value] unit) NIL] unit)
                                                      fApply(Fun [Feat Value] unit)
                                                      unit)
                                             unit)
                                 else
                                    fAndThen(fApply(fVar('IsRecord' unit) [Value] unit)
                                             fOpApply('\\=' [fApply(fVar('Arity' unit) [Value] unit) NIL] unit)
                                             unit)
                                 end
                                 %% true
                                 fApply(Name
                                        fRecord(fAtom(stacks unit)
                                                [
                                                 fApply(fVar('Append' unit) [fApply(fVar('Arity' unit)
                                                                                    [Value]
                                                                                    unit)
                                                                             PoppedFeatStack] unit)
                                                 fApply(fVar('Append' unit) [fApply(fOpApply('.' [fVar('Record' unit) fAtom(toList unit)] unit)
                                                                                    [Value]
                                                                                    unit)
                                                                             PoppedValueStack] unit)
                                                ])|if WithFun then Fun|Result|nil else Result|nil end
                                        unit)
                                 %% false
                                 fEq(Result
                                     fRecord(HASH
                                             [Feat
                                              Value
                                              fRecord(fAtom(stacks unit) [PoppedFeatStack PoppedValueStack])
                                             ])
                                     unit)
                                 %% position
                                 unit)
                       %% position
                       unit)
                %% flags
                nil
                %% position
                COORDS)}
         Name
      end
      %% --> assigns 3 lists in the same order
      %% - Fields:        the fields features
      %% - Expressions:   the fields values
      %% - Conditions:    the conditions
      %% - FieldsCollect: the fields of collects --> [Feature ... Feature]
      %% - CellsCollect:  the cells of collects --> [Cell ... Cell]
      %% --> assigns ReturnList to true iff a list must be returned and not a record
      %% --> returns the number of expressions
      fun {ParseExpressions EXPR_LIST ?Fields ?Expressions ?Conditions ?FieldsCollect ?CellsCollect}
         %% inserts I inside List, keeping it sorted
         %% no duplicates are in this list before and after
         %% List : sorted List of Ints
         %% I    : Int to insert
         proc {InsertSortNoDuplicate List I ?Result}
            case List of nil then
               if I == unit then Result = nil
               else Result = I|nil
               end
            [] H|T then N in
               if I == unit orelse I > H then
                  Result = H|N
                  {InsertSortNoDuplicate T I N}
               elseif I == H then
                  {Exception.raiseError 'list comprehension'(duplicateFeature(I))}
               else
                  Result = I|H|N
                  {InsertSortNoDuplicate T unit N}
               end
            end
         end
         %% creates the list of Ints (no duplicate)
         %% each element is a feature explicitly given by user
         fun {CreateIntIndexList EXPR_LIST Acc}
            case EXPR_LIST
            of nil then Acc
            [] forExpression(H _)|T then
               if {Label H} == fColon andthen {Label H.1} == fInt then
                  {CreateIntIndexList T {InsertSortNoDuplicate Acc H.1.1}}
               else
                  {CreateIntIndexList T Acc}
               end
            [] forFeature(_ _)|T then
               {CreateIntIndexList T Acc}
            end
         end
         %% List : a sorted list of Ints
         %% E    : an Int
         %% return a tuple or unit
         %% - unit: if E < every element of List
         %%         this sould never happen with our use here
         %% - tuple: otherwise
         %%          first element of tuple is
         %%                the resulting list of removing E from List if exists
         %%          second element of tuple is
         %%                a boolean, true iff E is in List, false otherwise
         fun {ContainsSubtracts List E}
            case List
            of nil then List#false
            [] H|T then
               if H == E then T#true
               elseif H > E then List#false
               else unit
               end
            end
         end
         %% Finds the next Int that is not in List
         %% starting from Wanted
         %% -List:   list of sorted Ints
         %% -Wanted: an Int
         %% Returns a tuple of 2 elements
         %% -1st: List with first elements < Wanted removed
         %% -2nd: the Int that can be used (Int not in List)
         fun {FindNextInt List Wanted}
            local L B in
               L#B = {ContainsSubtracts List Wanted}
               if B then {FindNextInt L Wanted+1}
               else L#Wanted
               end
            end
         end
         %% Body of ParseExpressions
         fun {Aux List Fs Es Cs FCs CCs Li I N}
            case List
            of nil then
               Fields = Fs
               Expressions = Es
               Conditions = Cs
               FieldsCollect = FCs
               CellsCollect = CCs
               ReturnList = N == 1 andthen {Label EXPR_LIST.1.1} \= fColon andthen {Label EXPR_LIST.1} \= forFeature
               N
            [] forExpression(Colon C)|T then
               case Colon of fColon(F E) then
                  {Aux T F|Fs E|Es C|Cs FCs CCs Li I N+1}
               else L W in
                  L#W = {FindNextInt Li I}
                  {Aux T fInt(W unit)|Fs Colon|Es C|Cs FCs CCs L W+1 N+1}
               end
            [] forFeature(C fColon(Feat Coll))|T then
               case C of fAtom(collect _) then Cell in
                  Cell = {DeclareCollector Feat Coll}
                  {Aux T Fs Es Cs Feat|FCs Cell|CCs Li I N+1}
               else
                  {Exception.raiseError 'list comprehension'(unknownFeature(C))} unit
               end
            end
         end
         Li = {CreateIntIndexList EXPR_LIST nil}
      in
         {Aux EXPR_LIST nil nil nil nil nil Li 1 0}
      end
      %% same as List.map but with more lists
      %% 4 lists as input
      %% Fun is the function to apply with 4 arguments
      fun {Map4 Fields Expressions Conditions NextVars Fun}
         fun {Aux Fs Es Ns Cs Acc}
            case Fs#Es#Ns#Cs
            of nil#nil#nil#nil then
               Acc
            [] (F|TF)#(E|TE)#(N|TN)#(C|TC) then
               {Aux TF TE TN TC {Fun F E N C}|Acc}
            end
         end
      in
         {Aux Fields Expressions Conditions NextVars nil}
      end
      %% creates a list with all the Result.FieldsCollect = @CellsCollect
      fun {CreateCellsInit FieldsCollect CellsCollect ResultVar}
         fun {Aux FCs CCs Acc}
            case FCs#CCs
            of nil#nil then Acc
            [] (F|Ft)#(C|Ct) then Eq in
               Eq = fEq(fOpApply('.' [ResultVar F] unit)
                        fAt(C unit)
                        unit)
               {Aux Ft Ct Eq|Acc}
            end
         end
      in
         {Aux FieldsCollect CellsCollect nil}
      end
      %% creates a list with all the outputs
      %% returns [fVar('Next1' unit) ... fVar('NextN' unit)]
      %% NextsRecord is bound to the same list but with
      %%    each element put inside a fColon with its feature
      fun {CreateNextsForLastLevel Fields ?NextsRecord}
         fun {Aux I Fs Acc1 Acc2}
            case Fs
            of nil then
               NextsRecord = Acc2
               Acc1
            else Var in
               Var = {MakeVarIndex 'Next' I}
               {Aux I+1 Fs.2 Var|Acc1 fColon(Fs.1 Var)|Acc2}
            end
         end
      in
         {Aux 1 Fields nil nil}
      end
      %% returns the next level initiators as a list (reversed !)
      %% used to initiate the next level (the first in Levels)
      %% Levels cannot be empty ! (this should never be needed because checked elsewhere)
      %% e.g. [fVar(...)]    if forGeneratorInt
      %% e.g. [fInt(...)]    if forGeneratorInt
      %% e.g. [fVar(...)]    if forGeneratorC
      %% e.g. [fInt(...)]    if forGeneratorC
      %% e.g. [fVar(...)]    if forGeneratorList
      %% e.g. [fRecord(...)] if forGeneratorList
      %% e.g. unit if no next level
      %% --> assigns AnyRecord to unit if any forRecord
      fun {NextLevelInitiators Levels Index ?Decl}
         %% Levels.1 == fForComprehensionLevel(...)
         %% Levels.1.1 == List of (forPattern(...) orelse forFrom(...) orelse forRecord(...) orelse forFlag(...))
         %% Levels.1.1.X.2 == (forGeneratorInt(...) orelse forGeneratorList(...) orelse forGeneratorC(...))
         fun {Aux Lvls Acc ?Dcl I}
            case Lvls
            of nil then
               Decl = Dcl
               Acc
            [] H|T then
               case H
               of forFlag(_) then {Aux T Acc Dcl I+1} % lazy
               [] forFrom(_ F) then {Aux T fApply(F nil unit)|Acc Dcl I+1} % for I in {Fun}
               [] forRecord(_ _ F Fun) then RecVar Feq Init in % for F:I in Record
                  if Fun == unit then
                     if {Not {IsDet FindNextDFS}} then
                        FindNextDFS = {PutFindNextDFS false}
                     end
                  else
                     if {Not {IsDet FindNextDFSFun}} then
                        FindNextDFSFun = {PutFindNextDFS true}
                     end
                  end
                  RecVar = {MakeVarIndexIndex 'Record' I 'At' Index+1}
                  Feq = fEq(RecVar F unit)
                  Init = fRecord(fAtom(stacks unit)
                                 [fApply(fVar('Arity' unit) [RecVar] unit)
                                  fApply(fOpApply('.' [fVar('Record' unit) fAtom(toList unit)] unit) [RecVar] unit)
                                 ])
                  {Aux T Init|Acc Feq|Dcl I+1}
               [] forPattern(_ F) then
                  case F
                  of forGeneratorInt(L _ _) then {Aux T L|Acc Dcl I+1} % for I in L..H ; S
                  [] forGeneratorList(L)    then
                     case L
                     of fBuffer(LL N) then End Thread Range Eq in  % for I in LL:N
                        End = {MakeVarIndexIndex 'End' I 'At' Index+1}
                        Range = {MakeVarIndexIndex 'Range' I 'At' Index+1}
                        Eq = fEq(Range LL unit)
                        Thread = fEq(End
                                     fThread(fApply(fOpApply('.' [fVar('List' unit) fAtom(drop unit)] unit)
                                                    [Range N]
                                                    unit)
                                             {CoordNoDebug COORDS})
                                     unit)
                        {Aux T fRecord(HASH [Range End])|Acc Eq|Thread|Dcl I+1}
                     else % for I in (L orelse [...])
                        {Aux T L|Acc Dcl I+1}
                     end
                  [] forGeneratorC(B _ _)   then {Aux T B|Acc Dcl I+1} % for I in B ; C ; S
                  end
               end
            end
         end
      in
         {Aux Levels.1.1 nil nil 1}
      end
      %% WHERE A LOT HAPPENS --------------------------------------------------------
      %% creates all the range for the level containing the RangesList
      %% assigns Lazy to [fAtom(lazy pos(...))] if lazy, nil if not
      %% RangesList           : e.g. [forPattern forFlag forFrom ...]
      %% Index                : the index of this level
      %% Lazy                 : true if lazy, otherwise false
      %% RangesDeeper         : all the ranges to declare in signature of deeper levels.
      %%                        Assigned at next instruction
      %% RangeListDecl        : the declarations needed before testing the condition given by user
      %% NewExtraArgsForLists : returns all the ranges of this level generated as list
      %% RangesDeclCallNext   : all the ranges to call this level
      %% RangesConditionList  : the list of all conditions to fullfill to keep iterating this level
      %% --> for   I1 in R1:2   A in 1..2   I2 in R3   B in 1;B+1   C in 1..3   lazy
      %% returns              : [fVar(C unit)  fVar(B unit)  fVar(Range3At1 unit)  fVar(A unit)
      %%                        fVar(Range1At1 unit)#fVar(End1At1 unit)]
      %% Lazy                 : true
      %% RangesDeeper         : [fVar(C unit)  fVar(B unit)  fVar(I3 unit)  fVar(A unit)  fVar(I1 unit)]
      %% RangeListDecl        : fAnd(fEq(fVar(I2 pos) fVar(Range3AtX.1 unit) unit)   fEq(fVar(I1 pos)
      %%                        fVar(Range1AtX.1 unit) unit))
      %% NewExtraArgsForLists : [fVar(Range3AtX unit) fVar(Range1AtX unit)]
      %% RangesDeclCallNext   : [fOpApply('+'  [fVar('C' pos) INT1] unit)  ...]
      %% RangesConditionList  : [fOpApply('=<' [fVar('C' pos) fInt(3 unit)] unit)  ...}
      fun {MakeRanges RangesList Index Result
           ?Lazy ?RangesDeeper ?RangeListDecl ?NewExtraArgsForLists ?RangesDeclCallNext ?RangesConditionList}
         fun {Aux List Acc AccD IsLazy I ListDecl ExtraArgs CallItself Conditions}
            %% Acc        : arguments of this level
            %% AccD       : arguments for next levels
            %% ListDecl   : declarations just after range condition and before user condition
            %% ExtraArgs  : extra arguments for next levels
            %% CallItself : how to call next iteration for this all the ranges of this level
            %% Conditions : user conditions
            case List
            of nil then
               %% end of ranges for this level
               %% assign all unbounded variables
               Lazy                 = IsLazy
               RangesDeeper         = AccD
               RangeListDecl        = ListDecl
               NewExtraArgsForLists = ExtraArgs
               RangesDeclCallNext   = CallItself
               RangesConditionList  = Conditions
               %% return the ranges
               Acc
            [] H|T then
               case H
               of forPattern(V P) then
                  case P
                  of forGeneratorList(GL) then Both Var Dcl Call Cond in % list given
                     %% create new variable to deal with list traversal (recursively)
                     Var = {MakeVarIndexIndex 'Range' I 'At' Index}
                     Cond = fOpApply('\\='
                                     [Var NIL]
                                     unit)
                     Dcl = fEq(V
                               fOpApply('.' [Var INT1] unit)
                               unit)
                     if {Record.label GL} == fBuffer then End in
                        %% we need a buffer
                        End = {MakeVarIndexIndex 'End' I 'At' Index}
                        Call = fRecord(HASH
                                       [fOpApply('.'
                                                 [Var INT2]
                                                 unit)
                                        fThread(fBoolCase(fOpApply('==' [End NIL] unit)
                                                          End
                                                          fOpApply('.' [End INT2] unit)
                                                          unit)
                                                {CoordNoDebug COORDS})
                                       ]
                                      )
                        Both = fRecord(HASH [Var End])
                     else
                        Both = Var
                        Call = fOpApply('.'
                                        [Var INT2]
                                        unit)
                     end
                     {Aux T Both|Acc V|AccD IsLazy I+1 Dcl|ListDecl Both|ExtraArgs Call|CallItself Cond|Conditions}
                  [] forGeneratorInt(_ Hi St) then Call Cond Var in % Ints style
                     case V
                     of fWildcard(_) then
                        Var = {MakeVar 'Wildcard'}
                     else
                        Var = V
                     end
                     Call = fOpApply('+'
                                     [Var if St == unit then INT1 else St end]
                                     unit)
                     Cond = fOpApply('=<' [Var Hi] unit)
                     {Aux T Var|Acc Var|AccD IsLazy I+1 ListDecl ExtraArgs Call|CallItself Cond|Conditions}
                  [] forGeneratorC(_ Cd St) then Call in % C-style
                     Call = if St == unit then Cd else St end
                     if St == unit then
                        {Aux T V|Acc V|AccD IsLazy I+1 ListDecl ExtraArgs Call|CallItself Conditions}
                     else
                        {Aux T V|Acc V|AccD IsLazy I+1 ListDecl ExtraArgs Call|CallItself Cd|Conditions}
                     end
                  end
               [] forRecord(F V _ Fun) then Cond NewDeeper Dcl Stacks NewStacks in % in record
                  %% create new variable to deal with arity traversal (recursively)
                  if {Label F} == fWildcard then
                     if {Label V} == fWildcard then NewDeeper = AccD
                     else NewDeeper = V|AccD
                     end
                  else
                     if {Label V} == fWildcard then NewDeeper = F|AccD
                     else NewDeeper = F|V|AccD
                     end
                  end
                  Stacks = {MakeVarIndexIndex 'Stacks' I 'At' Index}
                  NewStacks = {MakeVarIndexIndex 'NewStacks' I 'At' Index}
                  Cond = fOpApply('\\='
                                  [fOpApply('.' [Stacks INT1] unit) NIL]
                                  unit)
                  Dcl = fEq(fRecord(HASH [F V NewStacks])
                            if Fun == unit then fApply(FindNextDFS [Stacks] unit)
                            else fApply(FindNextDFSFun [Stacks Fun] unit)
                            end
                            unit)
                  {Aux T Stacks|Acc NewDeeper IsLazy I+1 Dcl|ListDecl NewStacks|ExtraArgs NewStacks|CallItself Cond|Conditions}
               [] forFrom(V F) then Call in % from function
                  Call = fApply(F nil unit)
                  {Aux T V|Acc V|AccD IsLazy I+1 ListDecl ExtraArgs Call|CallItself Conditions}
               [] forFlag(F) then % flag
                  case F
                  of fAtom(lazy C) then
                     %% is flag already there ?
                     if IsLazy then
                        {Exception.raiseError 'list comprehension'(doubleFlag(lazy C))} unit
                     else
                        {Aux T Acc AccD true I+1 ListDecl ExtraArgs CallItself Conditions}
                     end
                  else
                     {Exception.raiseError 'list comprehension'(unknownFlag(F.1 F.2))} unit
                  end
               end
            end
         end
      in
         {Aux RangesList nil nil false 1 nil nil nil nil}
      end
      %% creates the call to make for the next iteration on this level
      %% RangesDeclCallNext   : all the ranges to call of this level
      %% PreviousIds          : previous ids to put in call
      %% Name                 : name of the current level
      %% OldExtraArgsForLists : all the ranges of previous level generated as list
      %% ----> for A in _.._ ; 2 for B in _;_;B+1
      %% --> {Level1 A+2}   at level 1
      %% --> {Level2 B+1 A} at level 2
      %% ----> for A in R1 for B in R2
      %% --> {Level1 Range1At1.2} at level 1 (Old = nil, New = [fVar('Range1At1' unit)])
      %% --> {Level2 Range1At2.2 A Range1At1} at level 2 (Old = [fVar('Range1At1' unit)],
      %%                                                  New = [fVar('Range1At2' unit)])
      fun {MakeNextCallItself RangesDeclCallNext PreviousIds Name OldExtraArgsForLists Result}
         fApply(Name
                {List.flatten RangesDeclCallNext|PreviousIds|OldExtraArgsForLists|[Result]}
                unit)
      end
      %% RangesDeeper         : all the ranges to call
      %% PreviousIds          : previous ids to put in call
      %% {LevelX {NextLevelInitiators Levels} RangesDeeper PreviousIds ExtraArgsForLists}
      fun {MakeNextLevelCall RangesDeeper Levels NextLevelName PreviousIds ExtraArgsForLists Result Index}
         local
            Decls
            NextInitiators = {NextLevelInitiators Levels Index Decls}
            Apply = fApply(
                       %% function name
                       NextLevelName
                       %% args
                       {List.flatten NextInitiators|RangesDeeper|PreviousIds|ExtraArgsForLists|[Result]}
                       %% position
                       unit)
         in
            {LocalsIn Decls Apply}
         end
      end
      %% a big condition which is conjonction (andthen)
      %% of all the conditions that each range requires
      %% --> for   I1 in R1   A in 1..2   I2 in R3   B in 1;B<5;B+1   C in 1..3
      %% gives
      %% Range1\=nil andthen A=<2 andthen Range3\=nil andthen B<5 andthen C=<3
      fun {MakeRangesCondition RangesConditionList}
         local
            proc {Aux Xs A}
               case Xs
               of H|nil then
                  A = H
               [] H|T then
                  case H
                  of fAtom(true _) then
                     {Aux T A}
                  else B in
                     A = fAndThen(H B unit)
                     {Aux T B}
                  end
               end
            end
         in
            case RangesConditionList
            of nil then
               fAtom(true unit)
            [] H|nil then
               H
            [] H|T then
               case H
               of fAtom(true _) then {MakeRangesCondition T}
               else Next And in
                  And = fAndThen(H Next unit)
                  {Aux T Next}
                  And
               end
            end
         end
      end
      %% Replaces the last argument of the call (fApply) in the first argument
      %% by the new result (the one from this level) because it was the result
      %% of the previous level !
      fun {SwitchResultInPreviousLevelCall fApply(Name List unit) Result}
         local
            Tmp1 = {Reverse List}
            Tmp2 = {Reverse Result|Tmp1.2}
         in
            fApply(Name Tmp2 unit)
         end
      end
      %% creates each fThread I (a list is returned)
      %% - call WaitNeeded on result.I
      %% - assign LazyVar to unit
      fun {MakeThreads Result LazyVar Init Fields Cells}
         local
            fun {Aux Acc Fs Cs}
               if Fs == nil then
                  if Cs == nil then Acc
                  else Thrd in
                     Thrd = fThread(
                               fAnd(
                                  fApply(
                                     fVar('WaitNeeded' unit)
                                     [fAt(Cs.1 unit)]
                                     unit)
                                  fEq(LazyVar fAtom(unit unit) unit)
                                  )
                               COORDS)
                     {Aux Thrd|Acc Fs Cs.2}
                  end
               else Thrd in
                  Thrd = fThread(
                            fAnd(
                               fApply(
                                  fVar('WaitNeeded' unit)
                                  [fOpApply('.' [Result Fs.1] unit)]
                                  unit)
                               fEq(LazyVar fAtom(unit unit) unit)
                               )
                            COORDS)
                  {Aux Thrd|Acc Fs.2 Cs}
               end
            end
         in
            {Aux Init|nil Fields Cells}
         end
      end
      %% generates all the levels of the list comprehension recursively
      %% starting from a 'fake' level called PreLevel
      %% each levels launch the generation the next level if exists
      fun {LevelsGenerator}
         %%====================================================================================
         %% generates the procedure AST for Level numbered Index (name is <Name/'Level'#Index>)
         %% puts it in the dictionary DeclarationsDictionary at key 'Level'#Index
         %% returns the name (fVar) of the procedure generated
         %% Level               : fForComprehensionLevel([...] ... ...)
         %% Index               : int in [0, infinity]
         %% Levels              : the list of next levels
         %% PreviousIds         : list of the previous ranges name in the reverse order
         %% CallToPreviousLevel : how this level should call back the previous when done with range --> fApply(...)
         fun {LevelGenerator Level Index Levels PreviousIds CallToPreviousLevel OldExtraArgsForLists}
            %% the name of the function of this level
            NameVar           = {MakeVarIndex 'Level' Index}
            %% result
            ResultVar         = {MakeVar 'Result'}
            %% nil if not lazy, [fAtom(lazy pos(...))] if lazy
            Lazy
            %% all the ranges to declare in signature of deeper levels
            RangesDeeper
            %% the declarations needed before testing the condition given by user
            RangeListDecl
            %% arguments to add at next level because generator is a list and because of call back to previous level
            NewExtraArgsForLists
            %% the arguments of this level, with the transformation for next iteration
            RangesDeclCallNext
            %% the list of all conditions to fullfill to keep iterating this level
            RangesConditionList
            %% all the ranges to declare in signature of this level
            RangesDecl        = {MakeRanges Level.1 Index ResultVar
                                 ?Lazy ?RangesDeeper ?RangeListDecl ?NewExtraArgsForLists ?RangesDeclCallNext ?RangesConditionList}
            %% the call (fApply) to this level, one step forward
            NextCallItself    = {MakeNextCallItself RangesDeclCallNext PreviousIds NameVar OldExtraArgsForLists ResultVar}
            %% concatenation of NewExtraArgsForLists and OldExtraArgsForLists
            ExtraArgsForLists =  {List.append NewExtraArgsForLists OldExtraArgsForLists}
            %% all the conditions to fullfill to keep iterating on this level
            RangesCondition = {MakeRangesCondition RangesConditionList}
            %% the condition given by the user if any, unit otherwise
            Condition       = Level.2
            %% call to make for next if exists, EXPR|NextCallItself if not
            NextLevelCall     = if Levels == nil then
                                   %%===========
                                   %% last level
                                   local
                                      NextLastVar = {MakeVar 'Next'}
                                      NextsRecord
                                      NextVars = {CreateNextsForLastLevel Fields ?NextsRecord}
                                      NextAssignTrue  = fEq(NextLastVar fRecord(HASH NextsRecord) unit)
                                      NextAssignFalse = fEq(NextLastVar ResultVar                 unit)
                                      NextCall = {MakeNextCallItself RangesDeclCallNext PreviousIds NameVar
                                                  OldExtraArgsForLists NextLastVar}
                                      Assigns = {Map4 Fields Expressions Conditions {Reverse NextVars}
                                                 fun{$ F E C N}
                                                    True = fEq(
                                                       fOpApply('.' [ResultVar F] unit)
                                                       fRecord(fAtom('|' unit) [E N])
                                                       unit)
                                                 in
                                                    if C == unit then %% no condition
                                                       True
                                                    else
                                                        fBoolCase(C
                                                                  True
                                                                  fEq(fOpApply('.' [ResultVar F] unit) N unit)
                                                                  unit)
                                                    end
                                                 end}
                                      TrueStat = fLocal({List2fAnds NextVars}
                                                        if BODY == unit then
                                                           {List2fAnds {List.append Assigns [NextAssignTrue]}}
                                                        else
                                                           {List2fAnds {List.append BODY|Assigns [NextAssignTrue]}}
                                                        end
                                                        unit)
                                      ThisLevelConditionStat = if Condition == unit then
                                                                  %% no level condition: consider it always true
                                                                  TrueStat
                                                               else
                                                                  fBoolCase(Condition TrueStat NextAssignFalse unit)
                                                               end
                                   in
                                      fLocal(NextLastVar fAnd(ThisLevelConditionStat NextCall) unit)
                                   end
                                else
                                   %%===============
                                   %% not last level
                                   local
                                      NextLevelName = {LevelGenerator
                                                       Levels.1
                                                       Index+1
                                                       Levels.2
                                                       {List.append RangesDeeper PreviousIds}
                                                       NextCallItself
                                                       ExtraArgsForLists}
                                      NextLevelCallNotLast = {MakeNextLevelCall RangesDeeper Levels NextLevelName
                                                              PreviousIds ExtraArgsForLists ResultVar Index}
                                   in
                                      if Condition == unit then
                                         NextLevelCallNotLast
                                      else
                                         fBoolCase(Condition NextLevelCallNotLast NextCallItself unit)
                                      end
                                   end
                                end
            Procedure =
            fProc(
               %% name
               NameVar
               %% arguments
               {List.append RangesDecl {List.append PreviousIds {List.append OldExtraArgsForLists [ResultVar]}}}
               %% body
               local
                  BodyStat = local
                                TrueStat = {LocalsIn RangeListDecl NextLevelCall}
                             in
                                case RangesCondition
                                of fAtom(true _) then TrueStat
                                else fBoolCase(
                                        %% condition of ranges
                                        RangesCondition
                                        %% true
                                        TrueStat
                                        %% false
                                        if Index == 1 then Clts in
                                           %% close collectors
                                           Clts = {Map CellsCollect
                                                  fun{$ C}
                                                     fApply(fVar('Exchange' unit) [C NIL fWildcard(unit)] unit)
                                                  end}
                                           %% first level so assign Result to nil
                                           {List2fAnds {List.append Clts
                                                        {Map Fields
                                                         fun{$ F}
                                                            fEq(fOpApply('.' [ResultVar F] unit)
                                                                NIL
                                                                unit)
                                                         end}}}
                                        else
                                            %% call previous level
                                           {SwitchResultInPreviousLevelCall CallToPreviousLevel ResultVar}
                                        end
                                        %% position
                                        unit
                                        )
                                end
                             end
                  LazyAndBodyStat = if Lazy then
                                       %% LAZY --------------------
                                       fAnd(
                                          if Outputs == 1 then
                                             %%=====================
                                             %% lazy with one output
                                             if CellsCollect == nil then
                                                fApply(fVar('WaitNeeded' unit) [fOpApply('.' [ResultVar Fields.1] unit)] unit)
                                             else
                                                fApply(fVar('WaitNeeded' unit) [fAt(CellsCollect.1 unit)] unit)
                                             end
                                          else LazyVar in
                                             %%==========================
                                             %% lazy with several outputs
                                             LazyVar = {MakeVar 'LazyVar'}
                                             fLocal(LazyVar
                                                    {List2fAnds {MakeThreads ResultVar LazyVar
                                                                 fApply(fVar('Wait' unit) [LazyVar] unit) Fields CellsCollect}}
                                                    unit)
                                          end
                                          BodyStat
                                          ) % end of fAnd (because of lazy...)
                                    else
                                       %% not lazy, just body, no waiting
                                       BodyStat
                                    end
               in
                  LazyAndBodyStat
               end
               %% flags
               nil
               %% position
               COORDS)
         in
            {PutDeclIndex 'Level' Index Procedure}
            NameVar
         end %% end of LevelGenerator
         NameVar = {MakeVar 'PreLevel'}
         ResultVar = {MakeVar 'Result'}
         Level1Var  = {LevelGenerator FOR_COMPREHENSION_LIST.1 1 FOR_COMPREHENSION_LIST.2 nil unit nil}
      in
         %% put PreLevel in dico at key 'PreLevel'
         {PutDecl 'PreLevel' fProc(
                             %% name
                             NameVar
                             %% arguments
                             [ResultVar]
                             %% body
                             local
                                CellsDecls = {CreateCellsInit FieldsCollect CellsCollect ResultVar}
                                Decls
                                Initiators = {NextLevelInitiators FOR_COMPREHENSION_LIST 0 ?Decls}
                                ResultArg = if ReturnList then
                                               [fRecord(HASH [fColon(INT1 ResultVar)])]
                                            else
                                               [ResultVar]
                                            end
                                ApplyStat = fApply(Level1Var {List.append Initiators ResultArg} unit)
                                BodyStat = {LocalsIn Decls ApplyStat}
                                RecordMake = fEq(ResultVar
                                                    fApply(fOpApply('.'
                                                                    [fVar('Record' unit) fAtom('make' unit)]
                                                                    unit)
                                                           [HASH {LogicList2ASTList {List.append Fields FieldsCollect}}]
                                                           unit)
                                                    unit)
                             in
                                if ReturnList then %% if return list, can not be a collector
                                   BodyStat
                                elseif CellsDecls == nil then %% no collectors
                                   fAnd(RecordMake BodyStat)
                                else %% collectors
                                   {List2fAnds {List.append RecordMake|CellsDecls [BodyStat]}}
                                end
                             end
                             %% flags
                             nil
                             %% position
                             COORDS)
         }
         %% return name
         NameVar
      end %% end of LevelsGenerator
      Fields
      Expressions
      Conditions
      FieldsCollect
      CellsCollect
      Outputs = {ParseExpressions EXPR_LIST Fields Expressions Conditions FieldsCollect CellsCollect}
      %% launch the chain of level generation
      PreLevelVar = {LevelsGenerator}
   in
      %% return the actual tree rooted at fStepPoint
      fStepPoint(
         fLocal(
            %% all the declarations (levels and bounds)
            {List2fAndsDico}
            %% return the resulting list-s
            fApply(PreLevelVar nil COORDS)
            %% no position
            COORDS)
         %% list comprehension tag
         listComprehension
         %% keep position of list comprehension
         COORDS)
   end
end
