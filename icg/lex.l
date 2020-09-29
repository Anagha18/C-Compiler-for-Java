%{
	#include<stdio.h>
	#include<stdlib.h>
	#include "y.tab.h"
	int line_num = 0;
%}

%%
\<[a-zA-Z]+\.[a-zA-Z]+\> 				;

\/\*(.|\n)*\*\/ 			{++line_num;}
\/\/.* 					{++line_num;}
class  	 				{return(CLASS);}
"public static void main(String args[])"	{return(PSVM);}
int      				{return(INT);}
float    				{return(FLOAT);}
char     				{return(CHAR);}
double	 				{return(DOUBLE);}
long	 				{return(LONG);}
String   				{return(STRING);}
if        				{return(IF);} 
else      				{return(ELSE);}
while     				{return WHILE;}
for       				{return FOR;}
[a-zA-Z][_a-zA-Z0-9]*    		{ strcpy(yylval.arg,yytext); return(VARIABLE); }
[0-9]+                   		{ strcpy(yylval.arg,yytext);  return(NUMBER); }
\<|\>|\>=|\<=|==        		{ strcpy(yylval.arg,yytext);   return(RELOP);  }
[ \t]       				;
"\n"        				{ ++line_num; }
.           				{return(yytext[0]);}  
\+\+ 					{return(UNARYPLUS);}
\-\-					{return(UNARYMINUS);}
%%

int yywrap()
{
	return(1);
}

int yyerror(char *s)
{
	printf("\nERROR!! %s at line no. %d",s,line_num);
	return(1);
}
