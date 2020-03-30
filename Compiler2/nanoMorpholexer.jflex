/**
    JFlex scanner example based on a scanner for NanoMorpho.
    Authors: Hrafnkell Sigurðarson  <hrs70@hi.is>,
             Róbert Ingi Huldarsson <rih4@hi.is>,
             Frosti Grétarsson      <frg17@hi.is>,
    Date:    jan. 2020.
    
    Byggt á nanolexer frá Snorra Agnarssyni

    This stand-alone scanner/lexical analyzer can be built and run using:
        java -jar JFlex-full-1.7.0.jar nanomopholexer.jflex
        javac NanoMorphoLexer.java
        java NanoMorphoLexer inputfile > outputfile
    Also, the program 'make' can be used with the proper 'makefile':
        make test
    Which will make the program and run all of the tests in the /test directory.
*/

import java.io.*;

%%

%public
%class NanoMorphoLexer
%line
%column
%unicode
%byaccj

%{


public NanoMorphoParser yyparser;

public NanoMorphoLexer(java.io.Reader r, NanoMorphoParser yyparser) {
    this(r);
    this.yyparser = yyparser;
}

public int getLine() {
    return yyline + 1;
}

public int getColumn() {
    return yycolumn + 1;
}


%}

    /* Reglulegar skilgreiningar --  Regular definitions */

_MULTILINECOMMENT = (\{;;; (.*|\n|\r|\t) *;;;\})
_COMMENT = (;;;.*)
_DIGIT   = [0-9]
_FLOAT   = {_DIGIT}+\.{_DIGIT}+([eE][+-]?{_DIGIT}+)?
_INT     = {_DIGIT}+
_STRING  = \"([^\"\\] | \\b | \\t | \\n | \\f | \\r | \\\" | \\\' | \\\\ | (\\[0-3][0-7][0-7]) | \\[0-7][0-7]   | \\[0-7])*\"
_CHAR    = \'([^\'\\] | \\b | \\t | \\n | \\f | \\r | \\\" | \\\' | \\\\ | (\\[0-3][0-7][0-7]) | (\\[0-7][0-7]) | (\\[0-7]))\'
_DELIM   = [=,;(){}\[\]]
_OPNAME  = [\+\:&<>\-*/%!?\~\^|=]+
_NAME    = [:letter:]([:letter:]|{_DIGIT})*

%%

  /* Lesgreiningarreglur -- Scanning rules */

{_DELIM} {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return yycharat(0);
}

{_STRING} | {_FLOAT} | {_CHAR} | {_INT} | null | true | false {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.LITERAL;
}

// Keywords:
"while" {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.WHILE;
}

"if" {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.IF;
}

"elsif" {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.ELSIF;
}

"else" {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.ELSE;
}

"var" {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.VAR;
}


"return" {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.RETURN;
}

{_OPNAME} {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    String curr = yytext();

    if(curr.equals("&&")){
        return NanoMorphoParser.OPNAME_AND;
    } else if(curr.equals("||")){
        return NanoMorphoParser.OPNAME_OR;
    }   else if(curr.equals("!")){
        return NanoMorphoParser.OPNAME_NOT;
    }

    switch(curr.charAt(0)){
        case '*':
        case '/':
        case '%':
            return NanoMorphoParser.OPNAME7;
        case '+':
        case '-':
            return NanoMorphoParser.OPNAME6;
        case '<':
        case '>':
        case '=':
            return NanoMorphoParser.OPNAME5;
        case '&':
            return NanoMorphoParser.OPNAME4;
        case '|':
            return NanoMorphoParser.OPNAME3;
        case ':':
            return NanoMorphoParser.OPNAME2;
        case '?':
        case '~':
        case '^':
            return NanoMorphoParser.OPNAME1;
    }
}

{_NAME} {
    yyparser.yylval = new NanoMorphoParserVal(yytext());
    return NanoMorphoParser.NAME;
}

// Stuff that gets ignored or returns an error:

{_MULTILINECOMMENT} {
}

{_COMMENT} {
}



[ \t\r\n\f] {
}

. {
    return NanoMorphoParser.YYERRCODE;
}
