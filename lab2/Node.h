#ifndef _NODE_H_
#define _NODE_H_
typedef struct
{
	/*num is the number of the Grammer_Node's children*/
	int num;
	/*dynamic malloc space for the point matrix*/
	struct NodeT* child[1]; 	
} Grammer_Node;

typedef struct NodeT
{
	/*type=0:Lex_Node, type=1:Grammer_Node*/
	int type;
	int lineno;
	char name[32];
	union
	{
		int int_value;
		float float_value;
		char id[32];
		char type_n[32];
		Grammer_Node node_g;
	};
} Node;
#endif
