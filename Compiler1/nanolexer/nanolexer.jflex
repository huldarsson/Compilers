/**
	JFlex scanner example based on a scanner for NanoLisp.
	Author: Snorri Agnarsson, 2017-2020

	This stand-alone scanner/lexical analyzer can be built and run using:
		java -jar JFlex-full-1.7.0.jar nanolexer.jflex
		javac NanoLexer.java
		java NanoLexer inputfile > outputfile
	Also, the program 'make' can be used with the proper 'makefile':
		make test
 */

import java.io.*;

%%

%public
%class NanoLexer
%unicode
%byaccj

%{

// This part becomes a verbatim part of the program text inside
// the class, NanoLexer.java, that is generated.

// Definitions of tokens:
final static int ERROR = -1;
final static int IF = 1001;
final static int ELSIF = 1002;
final static int ELSE = 1003;
final static int WHILE = 1004;
final static int VAR = 1005;
final static int RETURN = 1006;
final static int NAME = 1007;
final static int OPNAME1 = 1008;
final static int OPNAME2 = 1009;
final static int OPNAME3 = 1010;
final static int OPNAME4 = 1011;
final static int OPNAME5 = 1012;
final static int OPNAME6 = 1013;
final static int OPNAME7 = 1014;
final static int AND = 1015;
final static int OR = 1016;
final static int NOT = 1017;
final static int LITERAL = 1018;

// A variable that will contain lexemes as they are recognized:
private static String lexeme;

// This runs the scanner:
public static void main( String[] args ) throws Exception
{
	NanoLexer lexer = new NanoLexer(new FileReader(args[0]));
	int token = lexer.yylex();
	while( token!=0 )
	{
		System.out.println(""+token+": \'"+lexeme+"\'");
		token = lexer.yylex();
	}
}

%}

  /* Reglulegar skilgreiningar */

  /* Regular definitions */
_MULTILINECOMMENT = (\{;;; (.*|\n|\r|\t) *;;;\})
_DIGIT=[0-9]
_FLOAT={_DIGIT}+\.{_DIGIT}+([eE][+-]?{_DIGIT}+)?
_INT={_DIGIT}+
_STRING=\"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"
_CHAR=\'([^\'\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|(\\[0-7][0-7])|(\\[0-7]))\'
_DELIM=[(){};,\[\]]
_NAME=[:letter:]([:letter:]|{_DIGIT})*
_OPNAME=[\+\-*/!%=><\:\^\~&|?]+

%%

  /* Lesgreiningarreglur */
  /* Scanning rules */

{_DELIM} {
	lexeme = yytext();
	return yycharat(0);
}

"if" {
	lexeme = yytext();
	return IF;
}

"elsif" {
	lexeme = yytext();
	return ELSIF;
}

"else" {
	lexeme = yytext();
	return ELSE;
}

"var" {
	lexeme = yytext();
	return VAR;
}

"return" {
	lexeme = yytext();
	return RETURN;
}

"while" {
	lexeme = yytext();
	return WHILE;
}

{_NAME} {
	lexeme = yytext();
	return NAME;
}

{_OPNAME} {
	lexeme = yytext();

	if(lexeme.equals("&&")){
		return AND;
	} else if(lexeme.equals("||")){
		return OR;
	}	else if(lexeme.equals("!")){
		return NOT;
	}

	char firstLetter = lexeme.charAt(0);
	if(firstLetter == '*' 
	|| firstLetter == '/' 
	|| firstLetter == '%'){
		return OPNAME1;
	} else if(firstLetter == '+' | firstLetter == '-'){
		return OPNAME2;
	} else if (firstLetter == '<'
	|| firstLetter =='>'
	|| firstLetter == '!'
	|| firstLetter == '='){
		return OPNAME3;
	} else if (firstLetter == '&'){
		return OPNAME4;
	} else if (firstLetter == '|'){
		return OPNAME5;
	}	else if (firstLetter == ':'){
		return OPNAME6;
	} else if (firstLetter == '?'
	|| firstLetter == '~'
	|| firstLetter == '^'){
		return OPNAME7;
	}

}

{_STRING} | {_FLOAT} | {_CHAR} | {_INT} | null | true | false {
	lexeme = yytext();
	return LITERAL;
}

";;;".*$ {
}

{_MULTILINECOMMENT} {

}

[ \t\r\n\f] {
}

. {
	lexeme = yytext();
	return ERROR;
}
