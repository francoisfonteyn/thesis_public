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
prepare
   skip
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
   fun {Compile fRecordComprehension(EXPR_LIST RANGER RECORD CONDITION FILTER BODY COORDS)}
      %% true iff return one non-nested record instead of record of records
      ReturnOneRecord
      %% used to keep track of all the procedures to declare
      DeclarationsDictionary = {Dictionary.new}
      proc {PutDecl Name Value}
         {Dictionary.put DeclarationsDictionary Name Value}
      end
      %% returns an AST rooted at fAnd(...)
      %% to declare everything inside DeclarationsDictionary
      fun {DeclareAllDico}
         {List2fAnds {Dictionary.items DeclarationsDictionary}}
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
      %% --> assigns 3 lists in the same order
      %% - Fields:      the fields features
      %% - Expressions: the fields values
      %% --> assigns ReturnOneRecord to true iff one record must be returned and not a record of records
      %% --> returns the number of expressions
      fun {ParseExpressions EXPR_LIST ?Fields ?Expressions ?Conditions ?ReturnOneRecord}
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
               ReturnOneRecord = N == 1 andthen {Label EXPR_LIST.1.1} \= fColon
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
      %% creates a list with all the outputs
      %% returns [fVar('Next1' unit) ... fVar('NextN' unit)]
      %% NextsRecord is bound to the same list but with
      %%    each element put inside a fColon with its feature
      fun {CreateNexts Outputs Fields Name ?NextsRecord}
         fun {Aux I Fs Acc1 Acc2}
            if I == 0 then
               NextsRecord = fRecord(fAtom('arities' unit) Acc2)
               Acc1
            else Var in
               Var = {MakeVarIndex Name I}
               {Aux I-1 Fs.2 Var|Acc1 fColon(Fs.1 Var)|Acc2}
            end
         end
      in
         {Aux Outputs Fields nil nil}
      end
      %% return the creations of all the output records of Level
      %% Fields    : the fields of Result
      %% LblArg    : the label
      %% NextsVar  : the arities
      %% ResultVar : the result
      fun {CreateRecords LblArg NextsVar ResultVar Fields}
         fun {Aux Ns Fs Acc}
            case Ns#Fs
            of nil#nil then Acc
            [] (N|Nt)#(F|Ft) then Apply in
               Apply = fApply(RecMake
                              [LblArg N fOpApply('.' [ResultVar F] unit)]
                              unit)
               {Aux Nt Ft Apply|Acc}
            end
         end
         RecMake = fOpApply('.' [fVar('Record' unit) fAtom('make' unit)] unit)
      in
         {Aux NextsVar Fields nil}
      end
      %% creates
      %% {IsRecord Val} andthen {Arity Val} \= nil andthen CONDITION
      fun {CreateRecursiveCondition ValVar}
         IsRec = fApply(fVar('IsRecord' unit) [ValVar] unit)
         Ari   = fOpApply('\\=' [fApply(fVar('Arity' unit) [ValVar] unit) NIL] unit)
      in
         fAndThen(IsRec
                  if CONDITION == unit then Ari
                  else fAndThen(Ari CONDITION unit)
                  end
                  unit)
      end
      %% creates the call
      %% {Level {Label Val} {Arity Val} Val '#'(1:Result.1.Feat ... N:Result.N.Feat)}
      fun {CreateRecursiveLevelCall FeatVar ValVar ResultArg Fields LevelVar}
         Lbl = fApply(fVar('Label' unit) [ValVar] unit)
         Ari = fApply(fVar('Arity' unit) [ValVar] unit)
         Rec = fRecord(HASH {Map Fields fun{$ F}
                                           fColon(F fOpApply('.' [fOpApply('.' [ResultArg F] unit) FeatVar] unit))
                                        end})
      in
         fApply(LevelVar [Lbl Ari ValVar Rec] unit)
      end
      %% equivalent of Map with 2 lists
      fun {Map2 L1 L2 Fun}
         fun {Aux L1 L2 Acc}
            case L1#L2
            of nil#nil then Acc
            [] (H1|T1)#(H2|T2) then
               {Aux T1 T2 {Fun H1 H2}|Acc}
            end
         end
      in
         {Aux L1 L2 nil}
      end
      %% returns a list of ArisArg.I = if Conditions.I then FeatVar|NextsVar.I else |NextsVar.I end
      %% for recursively all I
      fun {Map31Cond ArisArg Conditions NextsVar FeatVar}
         fun {Aux L1 L2 L3 Acc}
            case L1#L2#L3
            of nil#nil#nil then Acc
            [] (H1|T1)#(H2|T2)#(H3|T3) then TrueStat LeftStat Eq in
               TrueStat = fRecord(fAtom('|' unit) [FeatVar H3])
               LeftStat = if H2 == unit then TrueStat
                          else fBoolCase(H2 TrueStat H3 unit)
                          end
               Eq = fEq(H1 LeftStat unit)
               {Aux T1 T2 T3 Eq|Acc}
            end
         end
      in
         {Aux ArisArg Conditions NextsVar nil}
      end
      %% returns a list of
      %%
      %% if ArisArg.I \= nil andthen FeatVar == ArisArg.I.1 then
      %%    ResultArg.(Fields.I).FeatVar = ValVar
      %%    NextsVar.I = ArisArg.I.2
      %% else
      %%    NextsVar.I = ArisArg.I
      %% end
      %%
      %% for recursively all I
      fun {Map42if ArisArg Fields NextsVar Expressions FeatVar ResultArg}
         fun {Aux L1 L2 L3 L4 Acc}
            case L1#L2#L3#L4
            of nil#nil#nil#nil then Acc
            [] (H1|T1)#(H2|T2)#(H3|T3)#(H4|T4) then Cond1 Cond2 TrueStat FalseStat If in
               Cond1 = fOpApply('\\=' [H1 NIL] unit)
               Cond2 = fOpApply('==' [FeatVar fOpApply('.' [H1 INT1] unit)] unit)
               TrueStat = fAnd(fEq(fOpApply('.' [fOpApply('.' [ResultArg H2] unit) FeatVar] unit) H4 unit)
                               fEq(H3 fOpApply('.' [H1 INT2] unit) unit))
               FalseStat = fEq(H3 H1 unit)
               If = fBoolCase(fAndThen(Cond1 Cond2 unit) TrueStat FalseStat unit)
               {Aux T1 T2 T3 T4 If|Acc}
            end
         end
      in
         {Aux ArisArg Fields NextsVar Expressions nil}
      end
      %% returns the feature and the value of the ranger given by user
      %% handles wildcards
      %% --> Feat # WhetherFeatGivenByUser # Val # WhetherValGivenByUser
      fun {GetRanger}
         fun {Aux A B}
            if {Label A} == fWildcard then {MakeVar B}
            else A
            end
         end
         F = {Aux RANGER.1 'Feat'}
         V = {Aux RANGER.2 'Val'}
      in
         F#V
      end
      %%====================================================================================
      %% generates the PreLevel
      fun {Generator}
         %% generates the first for loop procedure
         fun {For1Generator}
            %% the name of the function of the for1
            NameVar = {MakeVar 'For1'}
            %% arguments of the level
            AriArg = {MakeVar 'Ari'}
            RecArg = {MakeVar 'Rec'}
            NewAriArg = {MakeVar 'NewAri'}
            ArisRec
            ArisArg = {CreateNexts Outputs Fields 'Ari' ArisRec}
         in
            {PutDecl 'For1'
             fProc(%% name
                   NameVar
                   %% arguments
                   [AriArg RecArg NewAriArg ArisRec]
                   %% body
                   fBoolCase(%% condition
                             fOpApply('\\=' [AriArg NIL] unit)
                             %% true
                             local
                                FeatVar#ValVar = {GetRanger}
                                FeatDecl = fEq(FeatVar
                                               fOpApply('.' [AriArg INT1] unit)
                                               unit)
                                ValDecl = fEq(ValVar
                                              fOpApply('.' [RecArg FeatVar] unit)
                                              unit)
                                NextVar = {MakeVar 'Next'}
                                NextsRec
                                NextsVar = {CreateNexts Outputs Fields 'Next' NextsRec}
                                CallFor1 = fApply(NameVar
                                                  [fOpApply('.' [AriArg INT2] unit)
                                                   RecArg NextVar NextsRec]
                                                  unit)
                                ConditionalAppendStat = {List2fAnds
                                                         fEq(NewAriArg fRecord(fAtom('|' unit) [FeatVar NextVar]) unit)
                                                         |{Map31Cond ArisArg Conditions NextsVar FeatVar}}
                                AlwaysAppendStat = {List2fAnds
                                                    fEq(NewAriArg fRecord(fAtom('|' unit) [FeatVar NextVar]) unit)
                                                    |{Map2 ArisArg NextsVar fun{$ A N}
                                                                               fEq(A
                                                                                   fRecord(fAtom('|' unit) [FeatVar N])
                                                                                   unit)
                                                                            end}}
                                RecursiveCondition = {CreateRecursiveCondition ValVar}
                                RecursiveBody = if FILTER == unit then AlwaysAppendStat
                                                else NoAppendStat in
                                                   NoAppendStat = {List2fAnds
                                                                   fEq(NewAriArg NextVar unit)
                                                                   |{Map2 ArisArg NextsVar fun{$ A N}
                                                                                              fEq(A N unit)
                                                                                           end}}
                                                   fBoolCase(FILTER AlwaysAppendStat NoAppendStat unit)
                                                end
                                RecursiveIf = fBoolCase(RecursiveCondition RecursiveBody ConditionalAppendStat unit)
                             in
                                fLocal(%% decl
                                       {List2fAnds FeatDecl|ValDecl|NextVar|NextsVar}
                                       %% body
                                       fAnd(RecursiveIf CallFor1)
                                       %% position
                                       unit)
                             end
                             %% false
                             {List2fAnds {Map NewAriArg|ArisArg fun{$ X} fEq(X NIL unit) end}}
                             %% position
                             unit)
                   %% flag
                   nil
                   %% position
                   COORDS)}
            NameVar
         end
         %%-------------------------------------------------------------------
         %% generates the second for loop procedure
         fun {For2Generator LevelVar}
            %% the name of the function of the for2
            NameVar = {MakeVar 'For2'}
            %% arguments of the level
            AriArg = {MakeVar 'Ari'}
            RecArg = {MakeVar 'Rec'}
            ArisRec
            ArisArg = {CreateNexts Outputs Fields 'Ari' ArisRec}
            ResultArg = {MakeVar 'Result'}
         in
            {PutDecl 'For2'
             fProc(%% name
                   NameVar
                   %% arguments
                   [AriArg RecArg ArisRec ResultArg]
                   %% body
                   fBoolCase(%% condition
                             fOpApply('\\=' [AriArg NIL] unit)
                             %% true
                             local
                                FeatVar#ValVar = {GetRanger}
                                FeatDecl = fEq(FeatVar
                                               fOpApply('.' [AriArg INT1] unit)
                                               unit)
                                ValDecl = fEq(ValVar
                                              fOpApply('.' [RecArg FeatVar] unit)
                                              unit)
                                NextsRec
                                NextsVar = {CreateNexts Outputs Fields 'Next' NextsRec}
                                For2Call = fApply(NameVar
                                                  [fOpApply('.'
                                                            [AriArg INT2]
                                                            unit)
                                                   RecArg
                                                   NextsRec
                                                   ResultArg]
                                                  unit)
                                AllFieldsDef = {List2fAnds
                                                {Map42if ArisArg Fields NextsVar Expressions FeatVar ResultArg}}
                                RecursiveCondition = {CreateRecursiveCondition ValVar}
                                RecursiveLevelCall = {CreateRecursiveLevelCall FeatVar ValVar ResultArg Fields LevelVar}
                                RecursiveBody = {List2fAnds
                                                 RecursiveLevelCall
                                                 |{Map2 NextsVar ArisArg fun{$ N A}
                                                                            fEq(N fOpApply('.' [A INT2] unit) unit)
                                                                         end}}
                                LeafBody = if BODY == unit then AllFieldsDef
                                           else fAnd(BODY AllFieldsDef)
                                           end
                             in
                                fLocal(%% decl
                                       {List2fAnds FeatDecl|ValDecl|NextsVar}
                                       %% body
                                       fAnd(fBoolCase(RecursiveCondition RecursiveBody LeafBody unit)
                                            For2Call)
                                       %% position
                                       unit)
                             end
                             %% false
                             fSkip(unit)
                             %% position
                             unit)
                   %% flag
                   nil
                   %% position
                   COORDS)}
            NameVar
         end %% end of For2Generator
         %%-------------------------------------------------------------------
         %% generates the procedure AST for the level (name is <Name/'Level'>)
         %% puts it in the dictionary DeclarationsDictionary at key 'Level'
         %% returns the name (fVar) of the procedure generated
         fun {LevelGenerator}
            %% the name of the function of the level
            NameVar = {MakeVar 'Level'}
            %% result
            ResultVar = {MakeVar 'Result'}
            %% label argument of the level
            LblArg = {MakeVar 'Lbl'}
            %% record argument of the level
            AriArg = {MakeVar 'Ari'}
            %% record argument of the level
            RecArg = {MakeVar 'Rec'}
         in
            {PutDecl 'Level'
             fProc(
                %% name
                NameVar
                %% arguments
                [LblArg AriArg RecArg ResultVar]
                %% body
                local
                   %% the procedure for the first for loop
                   For1 = {For1Generator}
                   %% the procedure for the second for loop
                   For2 = {For2Generator NameVar}
                   %% new arity
                   NewAriVar = {MakeVar 'NewAri'}
                   %% Arities
                   ArisVar = {MakeVar 'Aris'}
                   %% nexts record
                   NextsRecord
                   %% nexts var
                   NextsVar = {CreateNexts Outputs Fields 'Next' ?NextsRecord}
                   %% Aris definition
                   ArisDef = fEq(ArisVar NextsRecord unit)
                   %% for1 call
                   For1Call = fApply(For1 [AriArg RecArg NewAriVar ArisVar] unit)
                   %% for2 call
                   For2Call = fApply(For2 [NewAriVar RecArg ArisVar ResultVar] unit)
                   %% records creation
                   RecordCreations = {CreateRecords LblArg NextsVar ResultVar Fields}
                in
                   fLocal(%% decls
                          {List2fAnds NewAriVar|ArisVar|NextsVar}
                          %% body
                          {List2fAnds ArisDef|For1Call|{List.append RecordCreations [For2Call]}}
                          %% position
                          unit)
                end
                %% flags
                nil
                %% position
                COORDS)}
            NameVar
         end %% end of LevelGenerator
         %%-------------------------------------------------------------------
         NameVar   = {MakeVar 'PreLevel'}
         ResultVar = {MakeVar 'Result'}
         LevelVar  = {LevelGenerator}
      in
         %% put PreLevel in dico at key 'PreLevel'
         {PutDecl 'PreLevel' fProc(
                                %% name
                                NameVar
                                %% arguments
                                [ResultVar]
                                %% body
                                local
                                   RecVar = {MakeVar 'Rec'}
                                   Decl = fEq(RecVar RECORD unit)
                                   ResultArg = if ReturnOneRecord then
                                                  [fRecord(HASH [fColon(INT1 ResultVar)])]
                                               else
                                                  [ResultVar]
                                               end
                                   Lbl = fApply(fVar('Label' unit) [RecVar] unit)
                                   Ari = fApply(fVar('Arity' unit) [RecVar] unit)
                                   ApplyStat = fApply(LevelVar  Lbl|Ari|RecVar|ResultArg unit)
                                   BodyStat = fLocal(Decl ApplyStat unit)
                                in
                                   if ReturnOneRecord then
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
                                COORDS)}
         %% return name
         NameVar
      end %% end of Generator
      %%-------------------------------------------------------------------
      Fields
      Expressions
      Conditions
      Outputs = {ParseExpressions EXPR_LIST ?Fields ?Expressions ?Conditions ?ReturnOneRecord}
      %% launch the generation
      PreLevelVar = {Generator}
   in
      %% return the actual tree rooted at fStepPoint
      fStepPoint(
         fLocal(
            %% all the declarations (levels and bounds)
            {DeclareAllDico}
            %% return the resulting record
            fApply(PreLevelVar nil COORDS)
            %% no position
            COORDS)
         %% record comprehension tag
         recordComprehension
         %% keep position of record comprehension
         COORDS)
   end %% end of Compile
end