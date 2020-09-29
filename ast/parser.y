%{
	#include<stdio.h>
	int valid=1;
	extern FILE *yyin;
	extern FILE *yyout;
	extern char* yytext;
	extern int lineNo,scope,isInt,isFloat;
	/* Structure for symbol table */
	struct symTable{
		char variable[50];
		int type;
		int intVal;
		float floatVal;
		int scope;
		int lineNo;
	};
	/* Structure for AST node */
	struct node{
		char* var;
		char* val;
		struct node * left;
		struct node* right;
	};
	struct symTable symbTable[50];
	int temp;
	int index=0;
	int flotC=0;
	int intC=0;
	float fltTemp;
	char tempStr[50];
	struct node* createLeafNode(char* val,char* var);
	struct node* createNode(char* val,struct node* left,struct node* right);
%}

%token airth assig library UOP UOM assigP assigM assigMu assigD dataType
%token IF FOR ELSE WHILE INCLUDE MAIN FO FC BO BC SeCo prin com plus mult minus divide mod brak s_ f_ d_ SOP CLASS
%union
{
	      float floot;
              char *text;
	      struct rtrn{int val;float flt;struct node* nd;}rtrn;
}
%type <rtrn> E F T AssigExpr cond Ie print Iw W A Fo UE IFo init initDaEx step CLASS
%token <text> integer id comp string logical
%token <floot> flot
%%
S:
 CLASS id FO func FC	    {}	

func: MAIN FO A FC          {printf("\n\nAST\n\n");printTree($3.nd);}
    |;
A:dataType AssigExpr SeCo A  	
 |W A				
 |Fo A				
 |print	A			
 |AssigExpr SeCo A		
 |Ie A				
 |UE SeCo A			
 |;
AssigExpr:id assig E		{int ex=Exists($1);
				struct node* tempNode=(struct node*)malloc(sizeof(struct node));
				//If variable doesn't exist
				if(ex==-1){
					
					if(isInt){
						addInt($1,$3.val);intC=0;isInt=0; //Add to ST
						sprintf(tempStr,"%d",$3.val);
						tempNode=createLeafNode(tempStr,$1);//Create a leaf node with var name and value
					}
					else if(isFloat){
						addFlt($1,&($3.flt));flotC=0;isFloat=0;
						sprintf(tempStr,"%f",$3.flt);
						tempNode=createLeafNode(tempStr,$1);
					}
					else{
						myError("Varibale Not defined");
					}
				}
				//If it's already been defined
				else if(symbTable[ex].scope<=scope){
					if(isInt || isFloat){//exists but redifine
						myError("Identifier already defined");
				}
				else if(symbTable[ex].type==0){
					symbTable[ex].intVal=$3.val;
					sprintf(tempStr,"%d",$3.val);
					tempNode=createLeafNode(tempStr,$1);
				}																											    
				else if(symbTable[ex].type==1){								
					symbTable[ex].floatVal=$3.flt;
					sprintf(tempStr,"%f",$3.flt);
					tempNode=createLeafNode(tempStr,$1);							
				}
			}																						
			$$.nd=createNode("=",tempNode,$3.nd); //Create node; x=expression --> x on LHS and expression on RHS
			}
			|id assigP E	{	//x+=some_expression --> x = x + some_expression
						int ex=Exists($1);
					 	char tempAns[20];
					 	if(ex!=-1){
							if(symbTable[ex].type==0){
							symbTable[ex].intVal+=$3.val;
							sprintf(tempStr,"%d",symbTable[ex].intVal);
							sprintf(tempAns,"%d",$3.val);
							}
							else if(symbTable[ex].type==1){
								symbTable[ex].floatVal+=$3.flt;
								sprintf(tempStr,"%f",symbTable[ex].floatVal);
								sprintf(tempAns,"%f",$3.flt);
							}
						//Leaf nodes for x
						struct node* temp1=createLeafNode($1,tempStr); 
 						struct node* temp2=createLeafNode($1,tempStr);
						//Node for x + some_expression (aka value)
 						struct node* temp3=createNode("+",temp2,$3.nd); 
						//Node for x = some_expression
 						$$.nd=createNode("=",temp1,temp3);
						} else {
							myError("Varibale Not defined");
						}
				 	}
			|id assigM E	{	int ex=Exists($1);
					 	char* tempAns;
					 	if(ex!=-1){
							if(symbTable[ex].type==0){
								symbTable[ex].intVal-=$3.val;
								sprintf(tempStr,"%d",symbTable[ex].intVal);
								sprintf(tempAns,"%d",$3.val);
							}
							else if(symbTable[ex].type==1){
								symbTable[ex].floatVal-=$3.flt;
								sprintf(tempStr,"%f",symbTable[ex].floatVal);
								sprintf(tempAns,"%f",$3.flt);
							}
							struct node* temp1=createLeafNode($1,tempStr);
 							struct node* temp2=createLeafNode($1,tempStr);
							struct node* temp3=createNode("-",temp2,$3.nd);
 							$$.nd=createNode("=",temp1,temp3);
						}
						else{
							myError("Varibale Not defined");
						}
				 	}
			|id assigMu E	{	int ex=Exists($1);
					 	char* tempAns;
					 	if(ex!=-1){
							if(symbTable[ex].type==0){
								symbTable[ex].intVal*=$3.val;
								sprintf(tempStr,"%d",symbTable[ex].intVal);
								sprintf(tempAns,"%d",$3.val);
							}
							else if(symbTable[ex].type==1){
								symbTable[ex].floatVal*=$3.flt;
								sprintf(tempStr,"%f",symbTable[ex].floatVal);
								sprintf(tempAns,"%f",$3.flt);
							}
							struct node* temp1=createLeafNode($1,tempStr);
 							struct node* temp2=createLeafNode($1,tempStr);
 							struct node* temp3=createNode("*",temp2,$3.nd);
 							$$.nd=createNode("=",temp1,temp3);
						}
						else{
							myError("Varibale Not defined");
						}
					}
			|id assigD E	{	int ex=Exists($1);
					 	char* tempAns;
 						if(ex!=-1){
							if(symbTable[ex].type==0){
								symbTable[ex].intVal/=$3.val;
								sprintf(tempStr,"%d",symbTable[ex].intVal);
								sprintf(tempAns,"%d",$3.val);
							}
							else if(symbTable[ex].type==1){
								symbTable[ex].floatVal/=$3.flt;
								sprintf(tempStr,"%f",symbTable[ex].floatVal);
								sprintf(tempAns,"%f",$3.flt);
							}
							struct node* temp1=createLeafNode($1,tempStr);
 							struct node* temp2=createLeafNode($1,tempStr); 								struct node* temp3=createNode("/",temp2,$3.nd);
 							$$.nd=createNode("=",temp1,temp3);
						}
						else{
							myError("Varibale Not defined");
						}
 					}
		       	|id		{	int ex=Exists($1);		 			
						struct node* temp1;
				 		if(ex==-1){
 							if(isInt){addInt($1,0);intC=0;isInt=0;temp1=createLeafNode("int","0");}
							else if(isFloat){
								fltTemp=0;
								addFlt($1,&fltTemp);
								flotC=0;
								isFloat=0;
								//If it's just an identifier, initialize to 0
								temp1=createLeafNode("float","0.0"); 
							}
				 		}
 												
						else if(symbTable[ex].scope<=scope){
 							if(isInt || isFloat){//exists but redifine
								intC=0;isInt=0;flotC=0;isFloat=0;
								myError("Identifier already defined");
 							}
						}
						$$.nd=createNode("=",$1,temp1);
					}
E:				T plus E	{//For arithmetic ops, create a node with LHS on L and expression on R
							$$.nd=createNode("+",$1.nd,$3.nd);if(intC==1){$$.val=$1.val+$3.val;}else if(flotC==1){$$.flt=$1.flt+$3.flt;}}
 				|T minus E	{$$.nd=createNode("-",$1.nd,$3.nd);if(intC==1){$$.val=$1.val-$3.val;}else if(flotC==1){$$.flt=$1.flt-$3.flt;}}
				|T		{$$.nd=$1.nd;$$.val=$1.val;$$.flt=$1.flt;}
T:				F mult T	{$$.nd=createNode("*",$1.nd,$3.nd);if(intC==1){$$.val=$1.val*$3.val;}else if(flotC==1){$$.flt=$1.flt*$3.flt;}}
 				|F divide T	{$$.nd=createNode("/",$1.nd,$3.nd);if(intC==1){$$.val=$1.val/$3.val;}else if(flotC==1){$$.flt=$1.flt/$3.flt;}}
				|F		{$$.nd=$1.nd;$$.val=$1.val;$$.flt=$1.flt;}
F:				BO E BC		{$$.nd=$2.nd;$$.val=$2.val;$$.flt=$2.flt;}
				|id		{	int ex=get($1);
							if(ex!=-1){
								if(symbTable[ex].type==0){
									$$.val=symbTable[ex].intVal;
									sprintf(tempStr,"%d",symbTable[ex].intVal);
									$$.nd=createLeafNode($1,tempStr);//Create a leaf node with var name &val
								}
								else if(symbTable[ex].type==1){
									$$.flt=symbTable[ex].floatVal;
									sprintf(tempStr,"%f",symbTable[ex].floatVal);
									$$.nd=createLeafNode($1,tempStr);
								}
							}
							else{
								myError("Variable not defined");
							}

						}
 				|minusinteger 	{char tempStr1[20]="-";strcat(tempStr1,$2);intC=1;$$.nd=createLeafNode(tempStr1,"int");
						$$.val=atoi(tempStr1);
						}
				|minus flot	{sprintf(tempStr,"%f",$2);char tempStr1[20]="-";strcat(tempStr1,tempStr);flotC=1;
						$$.nd=createLeafNode(tempStr1,"float");$$.flt=-$2;
						}
 				|integer	{intC=1;$$.nd=createLeafNode($1,"int");$$.val=atoi($1);}
 				|string
				|flot		{sprintf(tempStr,"%f",$1);flotC=1;$$.nd=createLeafNode(tempStr,"float");$$.flt=$1;}

W:				WHILE BO cond BC FO Iw FC		{//Condition on L and Statements on R
									$$.nd=createNode("while",$3.nd,$6.nd);}
Iw:				brak SeCo
				|A		{$$.nd=$1.nd;}
UE:				UOP id		{	//++i -> i=i+1
							int ex=Exists($2);
	                           			if(ex!=-1){
								if(symbTable[ex].type==0){
									symbTable[ex].intVal+=1;
									sprintf(tempStr,"%d",symbTable[ex].intVal);
								}											 									else if(symbTable[ex].type==1){
									symbTable[ex].floatVal+=1;
									sprintf(tempStr,"%f",symbTable[ex].floatVal);}
									struct node* temp1=createLeafNode($2,tempStr);
									struct node* temp2=createLeafNode($2,tempStr);
																			 									struct node* temp3=createLeafNode("int","1");
																			 									struct node* temp4=createNode("+",temp2,temp3);
																			 									$$.nd=createNode("=",temp1,temp4);
							}
							else{myError("Varibale Not defined");}
						}
  				|id UOP		{int ex=Exists($1);
		                           		if(ex!=-1){									 									if(symbTable[ex].type==0){
								         symbTable[ex].intVal+=1;
									 sprintf(tempStr,"%d",symbTable[ex].intVal);
								}else if(symbTable[ex].type==1){
									symbTable[ex].floatVal+=1;
									sprintf(tempStr,"%f",symbTable[ex].floatVal);}
									struct node* temp1=createLeafNode($1,tempStr);
									struct node* temp2=createLeafNode($1,tempStr);
									struct node* temp3=createLeafNode("int","1");
									struct node* temp4=createNode("+",temp2,temp3);
									$$.nd=createNode("=",temp1,temp4);
								}
							else{myError("Varibale Not defined");}
						}
				|UOM id		{int ex=Exists($2);
		                           		if(ex!=-1){
								if(symbTable[ex].type==0){
									symbTable[ex].intVal+=1;
									sprintf(tempStr,"%d",symbTable[ex].intVal);
								}
								else if(symbTable[ex].type==1){
									symbTable[ex].floatVal+=1;
									sprintf(tempStr,"%f",symbTable[ex].floatVal);}
									struct node* temp1=createLeafNode($2,tempStr);
									struct node* temp2=createLeafNode($2,tempStr);
									struct node* temp3=createLeafNode("int","1");
									struct node* temp4=createNode("-",temp2,temp3);
									$$.nd=createNode("=",temp1,temp4);
								 }
								else{myError("Varibale Not defined");}
						}
				|id UOM		{int ex=Exists($1);
				                         if(ex!=-1){
								if(symbTable[ex].type==0){
									symbTable[ex].intVal+=1;
									sprintf(tempStr,"%d",symbTable[ex].intVal);}
								else if(symbTable[ex].type==1){
									symbTable[ex].floatVal+=1;
									sprintf(tempStr,"%f",symbTable[ex].floatVal);}
									struct node* temp1=createLeafNode($1,tempStr);
									struct node* temp2=createLeafNode($1,tempStr);
									struct node* temp3=createLeafNode("int","1");
									struct node* temp4=createNode("-",temp2,temp3);
									$$.nd=createNode("=",temp1,temp4);
								 }																
							else{myError("Varibale Not defined");}
						}
Fo:	FOR BO init SeCo cond SeCo step BC FO IFo FC
						{
							struct node* temp1,*temp2,*temp3;
							temp3=createNode("for",$5.nd,$10.nd);
							temp1=createNode(";",$3.nd,temp3);
							temp2=createNode(";",temp1,$7.nd);
							$$.nd=temp2;
						}
IFo:	brak SeCo 
	| A					{$$.nd=$1.nd;}
Ie:	IF BO cond BC FO A FC ELSE FO A FC	{struct node *temp1,*temp2;
						temp1=createNode("if",$3.nd,$6.nd);
						temp2=createNode("else",NULL,$10.nd);
						$$.nd=createNode(";",temp1,temp2);
						}
  	|IF BO cond BC FO A FC			{$$.nd=createNode("if",$3.nd,$6.nd);}
step:	AssigExpr
    	|UE
	|;
init:	dataType AssigExpr initDaEx	
		|AssigExpr initDaEx						
		|;
initDaEx:com init|;
cond:E comp cond						{$$.nd=createNode($2,$1.nd,$3.nd);}
    |E logical cond						{$$.nd=createNode($2,$1.nd,$3.nd);}
	  |E												{$$.nd=$1.nd;}
	  |AssigExpr
	  |UE SeCo
		|;
print:prin BO string BC  SeCo						{$$.nd=createLeafNode("print",$3);}
     | SOP BO string BC SeCo						{$$.nd=createLeafNode("print",$3);}

%%

int yyerror(char *msg)
 {
	
  printf("Error at line no.=>%d: %s\n",lineNo,msg);
		

  valid=0;
  //exit(0);
 }
int Exists(char* ide){
		for(int i=0;i<index;i++){
			if(strcmp(symbTable[i].variable,ide)==0){
				return i;
			}
		}
		return -1;
}



void addInt(char *va,int val){
		strcpy(symbTable[index].variable,va);
		symbTable[index].type=0;
		symbTable[index].intVal=val;
		symbTable[index].scope=scope;
		symbTable[index++].lineNo=lineNo;
}
void addFlt(char *va,float* v){
	  strcpy(symbTable[index].variable,va);
		symbTable[index].type=1;
		symbTable[index].floatVal=*v;
		symbTable[index].scope=scope;
		symbTable[index++].lineNo=lineNo;
}
void myError(char* str){
	
	printf("Error at line no-%d: %s\n",lineNo,str);
	
	valid=0;
}
int get(char *var){
	for(int i=0;i<index;i++){
		if(strcmp(symbTable[i].variable,var)==0)
			return i;
	}
	return -1;
}
struct node* createLeafNode(char* val,char* var){
	struct node* n=(struct node*)malloc(sizeof(struct node));
	n->var=var;
	n->val=val;
	n->left=NULL;
	n->right=NULL;
	return n;
}
struct node* createNode(char* val,struct node* left,struct node* right){
	struct node* n=(struct node*)malloc(sizeof(struct node));
	n->var='\0';
	n->val=val;
	n->left=left;
	n->right=right;
	return n;
}

void printTree(struct node* n){
	if(n!=NULL){
		printTree(n->left);
		printf(" (%s,%s) ",n->var,n->val);
		printTree(n->right);
	}
}
//driver code
main()
 {
    /// yyin=fopen("inp.java", "r");
    //yyout=fopen("out.txt","w");
  yyparse();
	printf("\n");
	if(valid)
		{
			printf("\n\nSymbol Table\n\n");
			printf("Variable\tType\tInt val\tFloat val\tScope\tLine No\n");
			for(int i=0;i<index;i++){
			printf("%s\t\t%d\t%d\t%f\t%d\t %d\n",symbTable[i].variable,symbTable[i].type,symbTable[i].intVal,symbTable[i].floatVal,symbTable[i].scope,symbTable[i].lineNo);
		}

    printf ("\n\nValid\n\n");}
 }
