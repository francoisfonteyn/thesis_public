local
   FakeCoords = pos
   FakeExpr1  = [forExpression(fAtom(expression pos(expression)) unit)]
   FakeExpr2  = [forExpression(expression1 unit) forExpression(expression2 conditon2)]
   FakeExpr3  = [forExpression(expression1 condition1)
                 forExpression(fColon(fInt(1 unit) expression2) condition2)
                 forExpression(fColon(fAtom(a unit) expression3) unit)]
   FakeExpr4  = [forExpression(fColon(fInt(2 unit) expression) unit)]
   FakeExpr5  = [forFeature(fAtom(collect unit) fColon(fAtom(c unit) fVar('Collect' unit)))
                 forExpression(fColon(fInt(2 unit) expression) unit)
                 forExpression(expression1 condition1)
                ]
   FakeBody0   = unit
   FakeBody1   = body
   FakeLevels1 = [
                  fForComprehensionLevel(
                     [forPattern(fVar('A' unit) forGeneratorList(fVar('LA' pos)))]
                     unit
                     pos)
                 ]
   FakeLevels2 = [
                  fForComprehensionLevel(
                     [forFlag(fAtom(lazy pos(lazyFlag)))
                      forPattern(fVar('A' pos(varA)) forGeneratorInt(fVar('LAInts' pos) fVar('HAInts' pos) unit))]
                     unit
                     pos)
                 ]
   FakeLevels3 = [
                  fForComprehensionLevel(
                     [forPattern(
                         fVar('ACsty' pos)
                         forGeneratorC(fVar('BACsty' pos) fVar('CACsty' pos) fOpApply('+' ['ACsty' 'SACsty'] unit))
                         )
                      forPattern(
                         fWildcard(pos)%fVar('AInts' pos)
                         forGeneratorInt(fVar('LAInts' pos) fVar('HAInts' pos) fVar('SAInts' pos))
                         )
                      forFrom(
                         fVar('AFrom' pos)
                         fVar('AFun1' pos)
                         )
                     ]
                     unit
                     pos)
                  fForComprehensionLevel(
                     [forPattern(
                         fVar('BCsty' pos)
                         forGeneratorC(fVar('BBCsty' pos) fOpApply('+' ['BCsty' 'SBCsty'] unit) unit)
                         )
                      forFlag(fAtom(lazy pos))
                      forPattern(
                         fVar('BList' pos)
                         forGeneratorList(fRecord('[3 4]'))
                         )
                      forFrom(
                         fVar('BFrom' pos)
                         fVar('BFun1' pos)
                         )
                     ]
                     fOpApply('A+B > 4' pos)
                     pos)
                  fForComprehensionLevel(
                     [forPattern(
                         fVar('CList' pos)
                         forGeneratorList(fVar('RCList' pos))
                         )
                      forPattern(
                         fVar('CInts' pos)
                         forGeneratorInt(fInt(3 pos) fInt(4 pos) unit)
                         )
                     ]
                     unit
                     pos)
                 ]
   FakeLevels4 = [
                  fForComprehensionLevel(
                     [forPattern(
                         fVar('CList1' pos)
                         forGeneratorList(fBuffer(fVar('RCList1' pos) fInt(1 pos)))
                         )
                      forPattern(
                         fVar('CList2' pos)
                         forGeneratorList(fBuffer(fVar('RCList2' pos) fInt(3 pos)))
                         )           ]
                     unit
                     pos)
                 ]
   FakeLevels5 = [
                  fForComprehensionLevel(
                     [forPattern(
                         fVar('A' pos)
                         forGeneratorList(fVar('In1' pos))
                         )
                     ]
                     unit
                     pos)
                  fForComprehensionLevel(
                     [forFlag(fAtom(lazy pos))
                      forPattern(
                         fVar('B' pos)
                         forGeneratorList(fBuffer(fVar('In2' pos) fInt(3 pos)))
                         )
                     ]
                     unit
                     pos)
                 ]
   FakeLevels6 = [
                  fForComprehensionLevel(
                     [
                      forRecord(fVar('I' pos) fVar('A' pos) fVar('Rec1' pos))
                      forRecord(fWildcard(pos) fWildcard(pos) fVar('Rec2' pos))
                     ]
                     unit
                     pos)
                  fForComprehensionLevel(
                     [
                      forRecord(fWildcard(pos) fVar('B' pos) fVar('Rec3' pos))
                      forRecord(fVar('C' pos) fWildcard(pos) fVar('Rec4' pos))
                     ]
                     unit
                     pos)
                 ]
   %% create a new variable named Name
   fun {MakeVar Name}
      fVar(Name unit)
   end
   %% create a new variable named by the concatenation of Name and Index
   %% Name : atom
   %% Index : positive int
   fun {MakeVarIndex Name Index}
      fVar({VirtualString.toAtom Name#Index} unit)
   end
   %% create a new variable named by the concatenation of Name1, Index1, Name2 and Index2
   %% Name_ : atom
   %% Index_ : positive int
   fun {MakeVarIndexIndex Name1 Index1 Name2 Index2}
      fVar({VirtualString.toAtom Name1#Index1#Name2#Index2} unit)
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
      %% true iff return list instead of record
      ReturnList
      %% used to keep track of all the (level) procedures to declare
      DeclarationsDictionary = {Dictionary.new}
      proc {PutDecl Name Value}
         {Dictionary.put DeclarationsDictionary Name Value}
      end
      proc {PutDeclIndex Name Index Value}
         {PutDecl {VirtualString.toAtom Name#Index} Value}
      end
      %% returns an AST rooted at fAnd(...)
      %% to declare everything inside DeclarationsDictionary (levels, ...)
      fun {DeclareAllDico}
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
      %% --> assigns 3 lists in the same order
      %% - Fields:        the fields features
      %% - Expressions:   the fields values
      %% - Conditions:    the conditions
      %% --> assigns ReturnList to true iff a list must be returned and not a record
      %% --> returns the number of expressions
      fun {ParseExpressions EXPR_LIST ?Fields ?Expressions ?Conditions ?ReturnList}
         %% creates a dico of Ints
         %% each element is a feature explicitly given by user
         fun {CreateIntIndexDico EXPR_LIST}
            Dico = {NewDictionary}
         in
            for forExpression(H _) in EXPR_LIST do
               if {Label H} == fColon andthen {Label H.1} == fInt then
                  {Dictionary.put Dico H.1.1 unit}
               end
            end
            Dico
         end
         %% Finds the next Int that is not in Dico
         %% starting from Wanted
         %% Returns the Int that can be used (Int not in Dico)
         %% The latter Int has been put in the Dico
         fun {FindNextInt Dico Wanted}
            if {Dictionary.member Dico Wanted} then
               {FindNextInt Dico Wanted+1}
            else
               {Dictionary.put Dico Wanted unit}
               Wanted
            end
         end
         %% Body of ParseExpressions
         fun {Aux List Fs Es Cs I N}
            case List
            of nil then
               Fields = Fs
               Expressions = Es
               Conditions = Cs
               ReturnList = N == 1 andthen {Label EXPR_LIST.1.1} \= fColon
                                   andthen {Label EXPR_LIST.1} \= forFeature
               N
            [] forExpression(Colon C)|T then
               case Colon of fColon(F E) then
                  {Aux T F|Fs E|Es C|Cs I N+1}
               else W in
                  W = {FindNextInt Dico I}
                  {Aux T fInt(W unit)|Fs Colon|Es C|Cs W+1 N+1}
               end
            end
         end
         Dico = {CreateIntIndexDico EXPR_LIST}
      in
         {Aux EXPR_LIST nil nil nil 1 0}
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
      fun {NextLevelInitiators Levels Index ?Decl}
         %% Levels.1 == fForComprehensionLevel(...)
         %% Levels.1.1 == List of (forPattern(...) orelse forFrom(...) orelse forRecord(...) orelse forFlag(...))
         %% Levels.1.1.X.2 == (forGeneratorInt(...) orelse forGeneratorList(...) orelse forGeneratorC(...))
         fun {Aux Lvls Acc Dcl I}
            case Lvls
            of nil then
               Decl = Dcl
               Acc
            [] H|T then
               case H
               of forFlag(_) then {Aux T Acc Dcl I+1} % lazy
               [] forFrom(_ F) then {Aux T fApply(F nil unit)|Acc Dcl I+1} % for I in {Fun}
               [] forRecord(_ _ F) then RecVar Feq Init in % for F:I in Record
                  RecVar = {MakeVarIndexIndex 'Record' I 'At' Index+1}
                  Feq = fEq(RecVar F unit)
                  Init = fRecord(fAtom(record unit)
                                 [fApply(fVar('Arity' unit) [RecVar] unit) RecVar])
                  {Aux T Init|Acc Feq|Dcl I+1}
               [] forPattern(_ F) then
                  case F
                  of forGeneratorInt(L _ _) then {Aux T L|Acc Dcl I+1} % for I in L..H ; S
                  [] forGeneratorList(L)    then {Aux T L|Acc Dcl I+1} % for I in L
                  [] forGeneratorC(B _ _)   then {Aux T B|Acc Dcl I+1} % for I in B ; C ; S
                  end
               end
            end
         end
      in
         {Aux Levels.1.1 nil nil 1}
      end
      %% WHERE A LOT HAPPENS -----------------------------------------
      %% creates all the range for the level containing the RangesList
      %% assigns Lazy to [fAtom(lazy pos(...))] if lazy, nil if not
      %% RangesList           : e.g. [forPattern forFlag forFrom ...]
      %% Index                : the index of this level
      %% Lazy                 : true if lazy, otherwise false
      %% RangesDeeper         : all the ranges to declare in signature of deeper levels. Assigned at next instruction
      %% RangeListDecl        : the declarations needed before testing the condition given by user
      %% NewExtraArgsForLists : returns all the ranges of this level generated as list
      %% RangesDeclCallNext   : all the ranges to call this level
      %% RangesConditionList  : the list of all conditions to fullfill to keep iterating this level
      %% --> for   I1 in R1   A in 1..2   I2 in R3   B in 1;B+1   C in 1..3   lazy
      %% returns              : [fVar(C unit)  fVar(B unit)  fVar(Range3At1 unit)  fVar(A unit)
      %%                        fVar(Range1At1 unit)]
      %% Lazy                 : true
      %% RangesDeeper         : [fVar(C unit)  fVar(B unit)  fVar(I3 unit)  fVar(A unit)  fVar(I1 unit)]
      %% RangeListDecl        : fAnd(fEq(fVar(I2 pos) fVar(Range3AtX.1 unit) unit)
      %%                             fEq(fVar(I1 pos) fVar(Range1AtX.1 unit) unit))
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
                  of forGeneratorList(_) then Var Dcl Call Cond in % list given
                     %% create new variable to deal with list traversal (recursively)
                     Var = {MakeVarIndexIndex 'Range' I 'At' Index}
                     Cond = fOpApply('\\='
                                     [Var NIL]
                                     unit)
                     Dcl = fEq(V
                               fOpApply('.' [Var INT1] unit)
                               unit)
                     Call = fOpApply('.'
                                     [Var INT2]
                                     unit)
                     {Aux T Var|Acc V|AccD IsLazy I+1 Dcl|ListDecl Var|ExtraArgs Call|CallItself Cond|Conditions}
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
               [] forRecord(F V _) then Cond NewDeeper NewListDecl RecordVar ArityVar BRec Call in % in Record
                  RecordVar = {MakeVarIndexIndex 'Record' I 'At' Index}
                  ArityVar = {MakeVarIndexIndex 'Arity' I 'At' Index}
                  BRec = fRecord(fAtom(record unit) [ArityVar RecordVar])
                  if {Label F} == fWildcard then
                     if {Label V} == fWildcard then
                        NewListDecl = ListDecl
                        NewDeeper = AccD
                     else
                        NewListDecl = fEq(V
                                          fOpApply('.'
                                                   [RecordVar
                                                    fOpApply('.' [ArityVar INT1] unit)]
                                                   unit)
                                          unit)|ListDecl
                        NewDeeper = V|AccD
                     end
                  else
                     if {Label V} == fWildcard then
                        NewListDecl = fEq(F fOpApply('.' [ArityVar INT1] unit) unit)|ListDecl
                        NewDeeper = F|AccD
                     else
                        NewListDecl = fEq(F fOpApply('.' [ArityVar INT1] unit) unit)
                                      |fEq(V fOpApply('.' [RecordVar F] unit) unit)|ListDecl
                        NewDeeper = F|V|AccD
                     end
                  end
                  Call = fRecord(fAtom(record unit)
                                 [fOpApply('.' [ArityVar INT2] unit) RecordVar])
                  Cond = fOpApply('\\=' [ArityVar NIL] unit)
                  {Aux T BRec|Acc NewDeeper IsLazy I+1 NewListDecl BRec|ExtraArgs Call|CallItself Cond|Conditions}
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
      %% RangesDeclCallNext   : all the ranges to call  this level
      %% PreviousIds          : previous ids to put in call
      %% Name                 : name of the current level
      %% OldExtraArgsForLists : all the ranges of previous level generated as list
      %% ----> for A in _.._ ; 2 for B in _;_;B+1
      %% > {Level1 A+2}   at level 1
      %% > {Level2 B+1 A} at level 2
      %% ----> for A in R1 for B in R2
      %% > {Level1 Range1At1.2} at level 1 (Old = nil, New = [fVar('Range1At1' unit)])
      %% > {Level2 Range1At2.2 A Range1At1} at level 2 (Old = [fVar('Range1At1' unit)],
      %%                                                New = [fVar('Range1At2' unit)])
      fun {MakeNextCallItself RangesDeclCallNext PreviousIds NameVar OldExtraArgsForLists ResultVar}
         fApply(NameVar
                {List.append RangesDeclCallNext
                 {List.append PreviousIds {List.append OldExtraArgsForLists [ResultVar]}}}
                unit)
      end
      %% RangesDeeper         : all the ranges to call
      %% PreviousIds          : previous ids to put in call
      %% {LevelX {NextLevelInitiators Levels} RangesDeeper PreviousIds ExtraArgsForLists}
      fun {MakeNextLevelCall RangesDeeper Levels NextLevelName PreviousIds ExtraArgsForLists ResultVar Index}
         local
            Decls
            NextInitiators = {NextLevelInitiators Levels Index Decls}
            Apply = fApply(
                       %% function name
                       NextLevelName
                       %% args
                       {List.append NextInitiators
                        {List.append RangesDeeper
                         {List.append PreviousIds
                          {List.append ExtraArgsForLists [ResultVar]}}}}
                       %% position
                       unit)
         in
            {LocalsIn Decls Apply}
         end
      end
      %% returns a big condition which is conjunction (andthen)
      %% of all the conditions that each range requires
      %% --> for   I1 in R1   A in 1..2   I2 in R3   B in 1;B<5;B+1   C in 1..3
      %% gives
      %% Range1\=nil andthen A=<2 andthen Range3\=nil andthen B<5 andthen C=<3
      fun {MakeRangesCondition RangesConditionList}
         case RangesConditionList
         of nil   then fAtom(true unit)
         [] H|nil then H
         [] H|T   then
            case H
            of fAtom(true _) then {MakeRangesCondition T}
            else fAndThen(H {MakeRangesCondition T} unit)
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
            %% the list of all conditions to fulfill to keep iterating this level
            RangesConditionList
            %% all the ranges to declare in signature of this level
            RangesDecl        = {MakeRanges Level.1 Index ResultVar ?Lazy ?RangesDeeper ?RangeListDecl
                                 ?NewExtraArgsForLists ?RangesDeclCallNext ?RangesConditionList}
            %% the call (fApply) to this level, one step forward
            NextCallItself    = {MakeNextCallItself RangesDeclCallNext PreviousIds
                                 NameVar OldExtraArgsForLists ResultVar}
            %% concatenation of NewExtraArgsForLists and OldExtraArgsForLists
            ExtraArgsForLists = {List.append NewExtraArgsForLists OldExtraArgsForLists}
            %% all the conditions to fulfill to keep iterating on this level
            RangesCondition   = {MakeRangesCondition RangesConditionList}
            %% the condition given by the user if any, unit otherwise
            Condition         = Level.2
            %% call to make for next if exists, EXPR|NextCallItself if not
            NextLevelCall     = if Levels == nil then
                                   %%=========================================
                                   %% last level: generates the following code
                                   %%
                                   %% local Next in
                                   %%    if {{ This_Level_Condition }} then
                                   %%       local {{ Next_1 ... Next_N }} in
                                   %%          Next = {{ '#'(field1:Next1 ... fieldN:NextN) }}
                                   %%          if {{ Is_Body }} then {{ Body }} end
                                   %%          {{ Forall I in Fields_Name }}
                                   %%             Result.I = if {{ Condition.I }} then Expression.I|Next_I
                                   %%                        else Next_I end
                                   %%          {{ end Forall }}
                                   %%       end
                                   %%    else
                                   %%       Next = Result
                                   %%    end
                                   %%    {LevelIndex %% current level
                                   %%     {{ Next_Iteration_For_The_Ranges_Of_This_Level }}
                                   %%     {{ Previous_Levels_Arguments }}
                                   %%     {{ Previous_List_Ranges }}
                                   %%     Next}
                                   %% end
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
                                                    TrueStat = fEq(
                                                                  fOpApply('.' [ResultVar F] unit)
                                                                  fRecord(fAtom('|' unit) [E N])
                                                                  unit)
                                                 in
                                                    if C == unit then %% no condition
                                                       TrueStat
                                                    else
                                                       fBoolCase(C
                                                                 TrueStat
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
                                        if Index == 1 then
                                           %% first level so assign Result to nil
                                           {List2fAnds {Map Fields
                                                        fun{$ F}
                                                           fEq(fOpApply('.' [ResultVar F] unit)
                                                               NIL
                                                                unit)
                                                        end}}
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
                                             fApply(fVar('WaitNeeded' unit)
                                                    [fOpApply('.' [ResultVar Fields.1] unit)]
                                                    unit)
                                          else
                                             %%==========================
                                             %% lazy with several outputs
                                             fOpApplyStatement('Record.waitNeededFirst' [ResultVar] unit)
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
                                Decls
                                Initiators = {NextLevelInitiators FOR_COMPREHENSION_LIST 0 ?Decls}
                                ResultArg = if ReturnList then
                                               [fRecord(HASH [fColon(INT1 ResultVar)])]
                                            else
                                               [ResultVar]
                                            end
                                ApplyStat = fApply(Level1Var {List.append Initiators ResultArg} unit)
                                BodyStat = {LocalsIn Decls ApplyStat}
                             in
                                if ReturnList then
                                   BodyStat
                                else RecordMake in
                                   RecordMake = fEq(ResultVar
                                                    fApply(fOpApply('.'
                                                                    [fVar('Record' unit) fAtom('make' unit)]
                                                                    unit)
                                                           [HASH {LogicList2ASTList Fields}]
                                                           unit)
                                                    unit)
                                   fAnd(RecordMake BodyStat)
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
      Outputs = {ParseExpressions EXPR_LIST ?Fields ?Expressions ?Conditions ?ReturnList}
      %% launch the chain of level generation
      PreLevelVar = {LevelsGenerator}
   in
      %% return the actual tree rooted at fStepPoint
      fStepPoint(
         fLocal(
            %% all the declarations (levels and bounds)
            {DeclareAllDico}
            %% return the resulting list(s)
            fApply(PreLevelVar nil COORDS)
            %% LC position
            COORDS)
         %% list comprehension tag
         listComprehension
         %% keep position of list comprehension
         COORDS)
   end
in
   {Browse {Compile fListComprehension(FakeExpr2 FakeLevels1 FakeBody0 FakeCoords)}}
end
