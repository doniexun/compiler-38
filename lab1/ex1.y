%{
#include "Node.h"
#define YYSTYPE Node*
#include "lex.yy.c"
#include "stdio.h"
#include "stdbool.h"
 #include <stdarg.h>
bool success = true;
Node n;
#define size_of_node ((char *)&n.int_value-(char *)&n)
Node *init_grammer_node(char *name,int num,...);
void print_tree(Node *r,int num);
void destroy_tree(Node *r);
%}
/*regular definition*/
%token INT FLOAT SEMI COMMA TYPE LC RC STRUCT RETURN IF WHILE ID
%nonassoc IFX
%nonassoc ELSE
%right ASSIGNOP 
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP LB RB DOT
%%
Program : ExtDefList {$$=init_grammer_node("Program",1,$1); if(success)print_tree($$,0);} 
	;
ExtDefList : ExtDef ExtDefList {$$=init_grammer_node("ExtDefList",2,$1,$2);} 
	| {$$=init_grammer_node("ExtDefList",0);}
	;
ExtDef : Specifier ExtDecList SEMI  {$$=init_grammer_node("ExtDef",3,$1,$2,$3);}
	| Specifier SEMI  {$$=init_grammer_node("ExtDef",2,$1,$2);}
	| Specifier FunDec CompSt  {$$=init_grammer_node("ExtDef",3,$1,$2,$3);}
	| error SEMI  { yyerrok; }
	;
ExtDecList : VarDec  {$$=init_grammer_node("ExtDecList",1,$1);}
	| VarDec COMMA ExtDecList {$$=init_grammer_node("ExtDecList",3,$1,$2,$3);}
	;
Specifier : TYPE {$$=init_grammer_node("Specifier",1,$1);}
	| StructSpecifier {$$=init_grammer_node("Specifier",1,$1);}
	;
StructSpecifier : STRUCT OptTag LC DefList RC {$$=init_grammer_node("StructSpecifier",5,$1,$2,$3,$4,$5);}
	| STRUCT Tag {$$=init_grammer_node("StructSpecifier",2,$1,$2);}
	;
OptTag : ID {$$=init_grammer_node("OptTag",1,$1);}
	| {$$=init_grammer_node("OptTag",0);}
	;
Tag : ID {$$=init_grammer_node("Tag",1,$1);} 
	;
VarDec : ID {$$=init_grammer_node("VarDec",1,$1);}
	| VarDec LB INT RB {$$=init_grammer_node("VarDec",4,$1,$2,$3,$4);} 
	| VarDec LB error RB {yyerrok;}
	;
FunDec	: ID LP VarList RP {$$=init_grammer_node("FunDec",4,$1,$2,$3,$4);}
	| ID LP RP {$$=init_grammer_node("FunDec",3,$1,$2,$3);}
	| error SEMI  { yyerrok; }
	| ID LP VarList error {yyerrok;}
	| ID LP error {yyerrok;}
	;
VarList : ParamDec COMMA VarList {$$=init_grammer_node("VarList",3,$1,$2,$3);}
	| ParamDec {$$=init_grammer_node("VarList",1,$1);} 
	;
ParamDec : Specifier VarDec {$$=init_grammer_node("ParamDec",2,$1,$2);} 
	;
CompSt	: LC DefList StmtList RC {$$=init_grammer_node("CompSt",4,$1,$2,$3,$4);}
	| error RC    { yyerrok; }
	;
StmtList : Stmt StmtList {$$=init_grammer_node("StmtList",2,$1,$2);}
	| {$$=init_grammer_node("StmtList",0);}	
	;
Stmt :Exp SEMI {$$=init_grammer_node("Stmt",2,$1,$2);}
	| CompSt {$$=init_grammer_node("Stmt",1,$1);}
	| RETURN Exp SEMI {$$=init_grammer_node("Stmt",3,$1,$2,$3);}
	| IF LP Exp RP Stmt %prec IFX{$$=init_grammer_node("Stmt",5,$1,$2,$3,$4,$5);}
	| IF LP Exp RP Stmt ELSE Stmt %prec ELSE{$$=init_grammer_node("Stmt",7,$1,$2,$3,$4,$5,$6,$7);}
	| WHILE LP Exp RP Stmt {$$=init_grammer_node("Stmt",5,$1,$2,$3,$4,$5);}
	| error SEMI    { yyerrok; }
	;
DefList : Def DefList {$$=init_grammer_node("DefList",2,$1,$2);}
	| {$$=init_grammer_node("DefList",0);}	
	;	
Def : Specifier DecList SEMI {$$=init_grammer_node("Def",3,$1,$2,$3);}
	| error SEMI    { yyerrok; }
	;
DecList : Dec {$$=init_grammer_node("DecList",1,$1);}
	| Dec COMMA DecList {$$=init_grammer_node("DecList",3,$1,$2,$3);}
	;
Dec : VarDec {$$=init_grammer_node("Dec",1,$1);}
	| VarDec ASSIGNOP Exp {$$=init_grammer_node("Dec",3,$1,$2,$3);}
	;
Exp : Exp ASSIGNOP Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| Exp AND Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
  	| Exp OR Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| Exp RELOP Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| Exp PLUS Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| Exp MINUS Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| Exp STAR Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| Exp DIV Exp {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| LP Exp RP {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| MINUS Exp %prec NOT{$$=init_grammer_node("Exp",2,$1,$2);}
	| NOT Exp {$$=init_grammer_node("Exp",2,$1,$2);}
	| ID LP Args RP {$$=init_grammer_node("Exp",4,$1,$2,$3,$4);}
	| ID LP RP {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| Exp LB Exp RB {$$=init_grammer_node("Exp",4,$1,$2,$3,$4);}
	| Exp DOT ID {$$=init_grammer_node("Exp",3,$1,$2,$3);}
	| ID {$$=init_grammer_node("Exp",1,$1);}
	| INT {$$=init_grammer_node("Exp",1,$1);}
	| FLOAT {$$=init_grammer_node("Exp",1,$1);}
	| LP error RP   { yyerrok; }
	| Exp LB error RB { yyerrok; }
	;
Args : Exp COMMA Args {$$=init_grammer_node("Args",3,$1,$2,$3);}
	| Exp {$$=init_grammer_node("Args",1,$1);}
	;
%%
int main(int argc,char **argv) 
{
	if(argc <=1) return 1;
	FILE *f=fopen(argv[1],"r");
	if(!f)
	{
		perror(argv[1]);
		return 1;
	}
	yyrestart(f);
	yyparse();
	destroy_tree(yylval);
	return 0;
}
int yyerror(char* msg)
{
	success = false;
  	fprintf(stderr, "Error type 2 at line %d: %s\n" , yylineno,msg);
}
Node *init_grammer_node(char *name,int num,...)
{
	if(num==0)
		return NULL;
	va_list valist;
	Node* q;
	q=malloc(size_of_node+sizeof(Grammer_Node)+(num-1)*sizeof(Node*));
	if(q==NULL)
		yyerror("out of memory!\n");
	strcpy(q->name,name);
	q->type=1;
	Grammer_Node* p=&q->node_g;;
	p->num=num;
	va_start(valist, num);
	int i;
	for (i = 0; i < num; i++)
		p->child[i] = (Node*)va_arg(valist, struct Node*);
	va_end(valist);
	q->lineno = p->child[0]->lineno;
	return q;
}
void print_t(int num)
{
 	int i;
	for(i=0;i<num;i++) printf("  ");
}
void print_tree(Node *r,int num)
{
	if(r==NULL) return;
	if(r->type==1)
	{
		print_t(num);
		printf("%s (%d)\n",r->name,r->lineno);
		int j=0;
		for(j;j<r->node_g.num;j++)
			print_tree(r->node_g.child[j],num+1);
	}
	else if(r->type==0)
	{
		print_t(num);
		if(strcmp(r->name,"TYPE")==0)
			printf("%s: %s\n",r->name,r->type_n);
		else if(strcmp(r->name,"INT")==0)
			printf("%s: %d\n",r->name,r->int_value);
		else if(strcmp(r->name,"FLOAT")==0)
			printf("%s: %f\n",r->name,r->float_value);
		else if(strcmp(r->name,"ID")==0)
			printf("%s: %s\n",r->name,r->id);
		else
		printf("%s\n",r->name);
	}
	
}
void destroy_tree(Node *r)
{
	if(r==NULL) return;
	if(r->type == 0) free(r);
	else if(r->type==1)
	{
		int j=0;
		for(j;j<r->node_g.num;j++)
			destroy_tree(r->node_g.child[j]);
		free(r);
	}
}

