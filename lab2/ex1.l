%{
#include "ex1.tab.h"
#include "string.h"
#include "stdbool.h"
#include <stdlib.h>
extern bool success;
Node *init_lex_node(char *,char*,int);
%}
/*regular definition*/
%option yylineno
letter [A-Za-z\_]
digit [0-9]
digit_0 [1-9]
id {letter}({letter}|{digit})*
int ({digit_0}{digit}*)|0
oct 0[1-7][0-7]*
hex 0[xX][0-9a-fA-F]+
float {digit}+\.{digit}+([eE][+-]?{digit}+)?
SingleLineComment \/\/.*\n
MultiLineComment \/\*[^\*\/]*((\*[^\/][^\*\/]*)|(\/[^\*][^\/\*]*))*\*\/
IncorrectComment1 \/\*.*\*\/
IncorrectComment2 [^\/]*(\/[^\*][^\/]*)*\*\/
IncorrectComment3 \/\*[^\*]*(\*[^\/][^\*]*)*
IncorrectComment {IncorrectComment1}|{IncorrectComment2}|{IncorrectComment3}
%%
{SingleLineComment} {/*no action*/}
{MultiLineComment} {/*no action*/}
{IncorrectComment} {  success=false;	fprintf(stderr, "Error type 3 at line %d: Incorrect Comments!\n" , yylineno);}
[ \t]+ {/*no action*/}
[\n] {/*no action*/}
{int} {yylval=init_lex_node("INT",yytext,yylineno);return INT;}
{oct} {yylval=init_lex_node("OCT",yytext,yylineno);return INT;}
{hex} {yylval=init_lex_node("HEX",yytext,yylineno);return INT;}
{float} {yylval=init_lex_node("FLOAT",yytext,yylineno);return FLOAT;}
";" {yylval=init_lex_node("SEMI",yytext,yylineno);return SEMI;}
"," {yylval=init_lex_node("COMMA",yytext,yylineno);return COMMA;}
"=" {yylval=init_lex_node("ASSIGNOP",yytext,yylineno);return ASSIGNOP;}
">" {yylval=init_lex_node("RELOP",yytext,yylineno);return RELOP;}
"<" {yylval=init_lex_node("RELOP",yytext,yylineno);return RELOP;}
">=" {yylval=init_lex_node("RELOP",yytext,yylineno);return RELOP;}
"<=" {yylval=init_lex_node("RELOP",yytext,yylineno);return RELOP;}
"==" {yylval=init_lex_node("RELOP",yytext,yylineno);return RELOP;}
"!=" {yylval=init_lex_node("RELOP",yytext,yylineno);return RELOP;}
"+" {yylval=init_lex_node("PLUS",yytext,yylineno);return PLUS;}
"-" {yylval=init_lex_node("MINUS",yytext,yylineno);return MINUS;}
"*" {yylval=init_lex_node("STAR",yytext,yylineno);return STAR;}
"/" {yylval=init_lex_node("DIV",yytext,yylineno);return DIV;}
"&&" {yylval=init_lex_node("AND",yytext,yylineno);return AND;}
"||" {yylval=init_lex_node("OR",yytext,yylineno);return OR;}
"." {yylval=init_lex_node("DOT",yytext,yylineno);return DOT;}
"!" {yylval=init_lex_node("NOT",yytext,yylineno);return NOT;}
"int" {yylval=init_lex_node("TYPE",yytext,yylineno);return TYPE;}
"float" {yylval=init_lex_node("TYPE",yytext,yylineno);return TYPE;}
"(" {yylval=init_lex_node("LP",yytext,yylineno);return LP;}
")" {yylval=init_lex_node("RP",yytext,yylineno);return RP;}
"[" {yylval=init_lex_node("LB",yytext,yylineno);return LB;}
"]" {yylval=init_lex_node("RB",yytext,yylineno);return RB;}
"{" {yylval=init_lex_node("LC",yytext,yylineno);return LC;}
"}" {yylval=init_lex_node("RC",yytext,yylineno);return RC;}
"struct" {yylval=init_lex_node("STRUCT",yytext,yylineno);return STRUCT;}
"return" {yylval=init_lex_node("RETURN",yytext,yylineno);return RETURN;}
"if" {yylval=init_lex_node("IF",yytext,yylineno);return IF;}
"else" {yylval=init_lex_node("ELSE",yytext,yylineno);return ELSE;}
"while" {yylval=init_lex_node("WHILE",yytext,yylineno);return WHILE;}
{id} {yylval=init_lex_node("ID",yytext,yylineno);return ID;}
. {char s[50]="Mysterious character '"; 
	success = false;
 	fprintf(stderr, "Error type 1 at line %d: %s\n" , yylineno,strcat(strcat(s,yytext),"'"));}
%%
int yywarp()
{
	return 1;
}

Node *init_lex_node(char *name,char *yytext,int lineno)
{
	Node* p;
	p=malloc(sizeof(Node));
	if(p==NULL)
		yyerror("out of memory!\n");
	p->type = 0;
	strcpy(p->name,name);
	p->lineno=lineno;
	if(strcmp(name,"ID")==0)
		strcpy(p->id,yytext);
	else if(strcmp(name,"TYPE")==0)
		strcpy(p->type_n,yytext);
	else if(strcmp(name,"INT")==0)
		p->int_value=atoi(yytext);
	else if(strcmp(name,"OCT")==0)
	{
		strcpy(p->name,"INT");
		p->int_value=(int)strtol(yytext,NULL,8);
	}
	else if(strcmp(name,"HEX")==0)
	{
		strcpy(p->name,"INT");
		p->int_value=(int)strtol(yytext,NULL,16);
	}
	else if(strcmp(name,"FLOAT")==0)
	{
		p->float_value=(float)atof(yytext);
	}
	return p;
}	




