%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include<math.h>
	extern int line_num;
	void addQuadruple(char [],char [],char [],char []);
	void display_Quadruple();
	void push(int);
	int pop();
	/* Structure for Quadruple table */
	struct Quadruple
	{
		char operator[5];
		char operand1[10];
		char operand2[10];
		char result[10];
	}QUAD[25];

	/* Stack to keep track of line numbers for SELECTION/ITERATIVE CONSTRUCTS */
	struct Stack
	{
		int items[25];
		int top;
	}Stk;

	int Index=0,tIndex=0,errno=0;
	//Index to keep track of Quadruple table index
	int ind1,ind2;
	
	
%}

%union{ 
	char arg[10];  //declaring arg to be a type
	  }
%token <arg> VARIABLE NUMBER RELOP 
%token CLASS
%token PSVM
%token INT FLOAT CHAR DOUBLE LONG STRING UNARYPLUS UNARYMINUS
%token IF ELSE WHILE FOR
%left '+' '-' 
%left '*' '/'
%type <arg> E ASSIGNMENT CONDITION VARLIST UNARY '('//these are of type arg
%start START

%%
START:PROGRAM1  { if(errno==0){
                          display_Quadruple();
                     }
                     else {
                          printf("\n\n The No of Errors are : %d \n\n",errno);
			  
                     }
               }
PROGRAM1: CLASS VARIABLE '{' PROGRAM '}'
PROGRAM: PSVM BLOCK 
BLOCK:'{' CODE '}'
CODE:BLOCK|STATEMENT CODE|STATEMENT
STATEMENT:DECLARATIVE ';'|
		CONDITIONAL|WHILELOOP|FORLOOP|ASSIGNMENT ';' |ASSIGNMENT { printf("\n Missing Selmicolon at line%d",line_num); errno++;}

DECLARATIVE : INT VARLIST    
            | FLOAT VARLIST  
            | CHAR VARLIST   
	    | DOUBLE VARLIST  
	    | LONG VARLIST    
      
VARLIST:VARIABLE ',' VARLIST 
         | VARIABLE  	     
          | VARIABLE '=' NUMBER { //x=10;
				   
				  strcpy(QUAD[Index].operator,"=");
                                  strcpy(QUAD[Index].operand1,$3);
                                  strcpy(QUAD[Index].operand2,"");
                                  strcpy(QUAD[Index].result,$1);
				  Index++;
                                
               
               
          } 
          | VARIABLE '=' NUMBER ',' VARLIST              


ASSIGNMENT:VARIABLE '=' E    { //x=a+3;  ---> var=a+3; t=var;

                                  strcpy(QUAD[Index].operator,"=");
                                  strcpy(QUAD[Index].operand1,$3);
                                  strcpy(QUAD[Index].operand2,"");
                                  strcpy(QUAD[Index].result,$1);
                                  Index++;
                             }
E: E '+' E   {   
                           addQuadruple("+",$1,$3,$$);
                           
                }
               
             
  |E '-' E   {addQuadruple("-",$1,$3,$$);}  
  |E '*' E   {addQuadruple("*",$1,$3,$$);}  
  |E '/' E   {addQuadruple("/",$1,$3,$$);}  
  |'(' E ')'   
  |VARIABLE  
   |NUMBER   

CONDITIONAL :IFSTMT  {   /* For single-IF statements, after the condition is evaluated, we push the starting index onto the stack.
			    After execution of the block of statements, we pop this index and change the value of "GOTO" result to
			    the appropriate line number
			    sprintf is used here as we need more than 2 arguments
			*/

			 ind1 = pop();
                         sprintf(QUAD[ind1].result,"GOTO %d",Index);
                     }
            |IFSTMT  {    /* For IF-ELSE statements, we need two GOTO statements: One containing the snippet of code to jump tp
			     if 'ELSE' is satisfied, and another to skip the block of statements of 'ELSE', if IF is satisfied.
			     After the condition is evaluated, we push the starting index onto the stack.
			     After execution of the block of statements, we go add a "GOTO ?" line to jump the block of "ELSE" statements
			     and also push the line number of the beginning of the "ELSE" block.
			     We then go to ELSESTMT and pop the 2 indexes and update the "GOTO" statements with the appropriate line numbers.
			*/

			strcpy(QUAD[Index].operator,"GOTO");
                         strcpy(QUAD[Index].operand1,"");
                         strcpy(QUAD[Index].operand2,"");
			 strcpy(QUAD[Index].result,"-1");
                         push(Index);
                         Index++;
                      }  ELSESTMT

IFSTMT : IF '(' CONDITION ')'   {    strcpy(QUAD[Index].operator,"==");
                                     strcpy(QUAD[Index].operand1,$3);
                                     strcpy(QUAD[Index].operand2,"FALSE");
                                     strcpy(QUAD[Index].result,"-1");
                                     push(Index);
                                     Index++;
		                } BLOCK

ELSESTMT : ELSE      {   ind1=pop();
	                 ind2=pop();
                         push(ind1);
                         sprintf(QUAD[ind2].result,"GOTO %d",Index); 
                     } BLOCK  { 
				ind1=pop(); 
		                sprintf(QUAD[ind1].result,"%d",Index);
		              }

CONDITION : VARIABLE RELOP VARIABLE   
             {    
                  addQuadruple($2,$1,$3,$$);
             }
            |VARIABLE RELOP NUMBER
             {
                
                addQuadruple($2,$1,$3,$$);   
             }

FORLOOP : FORSTMT

FORSTMT : FOR '(' EXPRESSIONS ')' BLOCK { /* In a looping statement, you need two sets of indices; one to get out of the loop
		  and the other to iterate through the loop again, to go back to the condition;
		  You first go to expressions and evaluate the condition. For ex: IF t3==FALSE GOTO ?
		  We first push the current_index-1 (where the looping condition is present) into the stack.
		  The block of code under the FOR loop is evaluated and then we come back here.
		  At the end, we need to add a GOTO statement to jump back to the loop
                  The stack now contains: LineNum of the last block of statements, and the lineNum of the for condition
		  We pop the last index, which is the line to jump to from t3==FALSE GOTO. We copy that data into the result.
		  Next we change the GOTO value of the previous entry in the table - which contains the line number of the FOR statement
			 */
                   strcpy(QUAD[Index].operator,"GOTO");
	           strcpy(QUAD[Index].operand1,"");
                   strcpy(QUAD[Index].operand2,"");
                   strcpy(QUAD[Index].result,"-1");
                   Index++;
		   ind1 = pop();
                   sprintf(QUAD[ind1].result,"GOTO %d",Index);
                   ind2 = pop();
                   sprintf(QUAD[Index-1].result,"%d",ind2);
                }

EXPRESSIONS: DECLARATIVE ';' CONDITION { push(Index-1);
                 strcpy(QUAD[Index].operator,"==");
                 strcpy(QUAD[Index].operand1,$3);
                 strcpy(QUAD[Index].operand2,"FALSE");
                 strcpy(QUAD[Index].result,"-1");
                 push(Index);
                 Index++;
                 } ';' UNARY {;}

UNARY: VARIABLE UNARYPLUS {
				  strcpy(QUAD[Index].operator,"+");
                        	  strcpy(QUAD[Index].operand1,"1");
                                  strcpy(QUAD[Index].operand2,$1);
                                  strcpy(QUAD[Index].result,$1);
                                  strcpy($$,QUAD[Index++].result);
}
     | VARIABLE UNARYMINUS {  strcpy(QUAD[Index].operator,"-");
                        	  strcpy(QUAD[Index].operand1,$1);
                                  strcpy(QUAD[Index].operand2,"-1");
                                  strcpy(QUAD[Index].result,$1);
                                  strcpy($$,QUAD[Index++].result);

}

WHILELOOP : WHILESTMT

WHILESTMT : WHILE '(' CONDITION
              {  
		 push(Index-1);
                 strcpy(QUAD[Index].operator,"==");
                 strcpy(QUAD[Index].operand1,$3);
                 strcpy(QUAD[Index].operand2,"FALSE");
                 strcpy(QUAD[Index].result,"-1");
                 push(Index);
                 Index++;
              }
            ')' BLOCK
                {
	           strcpy(QUAD[Index].operator,"GOTO");
	           strcpy(QUAD[Index].operand1,"");
                   strcpy(QUAD[Index].operand2,"");
                   strcpy(QUAD[Index].result,"-1");
                   Index++;
		   ind1 = pop();
                   sprintf(QUAD[ind1].result,"GOTO %d",Index);
                   ind2 = pop();
                   sprintf(QUAD[Index-1].result,"%d",ind2);
                }
%%

extern FILE *yyin;
int main(int argc,char *argv[])
{
	FILE *fp;
	Stk.top = -1;
	yyin = fopen(argv[1],"r");
	yyparse();
	printf("\n\n");
	return(0);
}


void addQuadruple(char op[5],char arg1[10],char arg2[10],char res[10])
{
	strcpy(QUAD[Index].operator,op);
	strcpy(QUAD[Index].operand1,arg1);
	strcpy(QUAD[Index].operand2,arg2);
	sprintf(QUAD[Index].result,"t%d",tIndex++);
	strcpy(res,QUAD[Index++].result);
}

void display_Quadruple()
{
	int i;
	printf("\n\n The INTERMEDIATE CODE Is : \n\n");
	for(i=0;i<Index;i++){
	
		printf("\n %d     %s          %s          %s          %s",i,QUAD[i].operator,QUAD[i].operand1,QUAD[i].operand2,QUAD[i].result); 
	}
	printf("\n\n");
	printf("1234\n");
	for(i=0;i<Index;i++)
	{
		//If operator is =,means it's an assignment statement of the form x=a
		//!strcmp as strcmp returns 0 if it's a match
		if(!(strcmp(QUAD[i].operator,"="))){
			printf("%s = %s\n",QUAD[i].result,QUAD[i].operand1);
		}
		//If operator is GOTO,means it's of the form GOTO <linenumber>
		else if(!(strcmp(QUAD[i].operator,"GOTO"))){
			printf("GOTO %s\n",QUAD[i].result);
		}
		//A looping condition of the form t2==FALSE GOTO 13
		else if(!(strcmp(QUAD[i].operand2,"FALSE"))){
			printf("%s%sFALSE %s\n",QUAD[i].operand1,QUAD[i].operator,QUAD[i].result);
		}
		else{
                //An evaluation expression
		char chch[]={QUAD[i].result};
		printf("%s = %s %s %s\n",QUAD[i].result,QUAD[i].operand1,QUAD[i].operator,QUAD[i].operand2);
		}
		
	}
}

void push(int i)
{
	Stk.top++;
	if(Stk.top==100)
	{
		printf("\nStack OverFlow!! \n");
		exit(0);
	}
	Stk.items[Stk.top] = i;
}

int pop()
{
	int i;
	if(Stk.top==-1)
	{
		printf("\nStack Empty!! \n");
		exit(0);
	}
	i=Stk.items[Stk.top];
	Stk.top--;
	return(i);
}


