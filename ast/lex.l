%{
	#include<stdio.h>
	#include<string.h>
	#include "y.tab.h"

	int lineNo=1;
	int scope=-1;
	int isInt=0;
	int isFloat=0;
	int f=0;
%}
%%

\/\/(.*)
\/\*[^\*\/]*\*\/
"if"						{f=1;scope++;return IF;}
"else"						{f=1;scope++;return ELSE;}
"for"						{f=1;scope++;return FOR;}
"while"						{f=1;scope++;return WHILE;}
"class"						return CLASS;			
"public static void main(String args[])"	{f=1;scope++;return MAIN;} 
"{"						{if(f){f=0;}else{scope++;}return FO;}
"}"						{scope--;return FC;}
"("						return BO;
")"						return BC;
";"						return SeCo;
","						return com;
"+"						return plus;
"-"						return minus;
"*"						return mult;
"/"						return divide;
"%"     		        		return mod;
"=="|"<="|">="|"!="|"<"|">"      		{yylval.text=strdup(yytext);return comp;}  
"="						return assig;
"+="						return assigP;
"-="						return assigM;
"*="						return assigMu;
"/="						return assigD;
"++"						return UOP;
"--"                           			return UOM;
"&"|"&&"|"|"|"||"                   		{yylval.text=strdup(yytext);return logical;}
"int"						{isInt=1;isFloat=0;return dataType;}
"char"						{return dataType;}
"float"                				{isFloat=1;isInt=0;return dataType;}
"System.out.println" 				return SOP;
"break"						return brak;
[0-9]+"."[0-9]+					{yylval.floot=atof(yytext);return flot;}
[0-9]+						{yylval.text=strdup(yytext);return integer;}
\"[^\"]*\"     					{yylval.text=strdup(yytext);return string;}
[a-zA-Z_][a-zA-Z_0-9]*				{yylval.text=strdup(yytext);return id;}
[\n]						{lineNo++;}
[ ]|[\t]
.						return yytext[0];
%%
int yywrap(){
	return 1;
}
