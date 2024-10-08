/*
Copyright 2021 Herman Jansson & Johan Martinson

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package se.isselab.HAnS.folderAnnotation;

import com.intellij.psi.tree.IElementType;
import se.isselab.HAnS.folderAnnotation.psi.FolderAnnotationTypes;
import com.intellij.psi.TokenType;

%%

%class FolderAnnotationLexer
%implements FlexLexer
%unicode
%function advance
%type IElementType
%eof{  return;
%eof}

CRLF=[\n|\r\n]
SPACE= [' ']
SEPARATOR = [:]
CS = [,]

FEATURENAME= [[A-Z]+|[a-z]+|[0-9]+|'_'+|'\''+]

%state WAITING_VALUE

%%

<YYINITIAL> {FEATURENAME}+                                 { yybegin(YYINITIAL); return FolderAnnotationTypes.FEATURENAME; }
<YYINITIAL> {SEPARATOR}{SEPARATOR}                         { yybegin(YYINITIAL); return FolderAnnotationTypes.SEPARATOR; }
<YYINITIAL> {CS}                                           { yybegin(YYINITIAL); return FolderAnnotationTypes.CS; }

<WAITING_VALUE> {CRLF}({CRLF}|{SPACE})+                    { yybegin(YYINITIAL); return TokenType.WHITE_SPACE; }

<WAITING_VALUE> {SPACE}+                                   { yybegin(WAITING_VALUE); return TokenType.WHITE_SPACE; }

({CRLF}|{SPACE})+                                          { yybegin(YYINITIAL); return TokenType.WHITE_SPACE; }

[^]                                                        { return TokenType.BAD_CHARACTER; }
