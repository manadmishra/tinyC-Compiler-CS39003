%{ 
	#include <string.h>
	#include <stdio.h>

	extern int yylex();
	void yyerror(char *s);
%}

%union {
int intval;
}


%token STAR_EQ INC DEC ACC AND DOTS REQ_SHIFT LEQ_SHIFT PLUS_EQ MINUS_EQ 
%token BIN_AND_EQ OR LTE GTE EQ NEQ DIV_EQ MOD_EQ BIN_XOR_EQ BIN_OR_EQ R_SHIFT L_SHIFT 
%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT RETURN
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token _BOOL _COMPLEX _IMAGINARY  STRUCT UNION ENUM CURL_BRACKET_CLOSE DOT AMP MUL ADD SUB
%token BREAK CASE CONTINUE DEFAULT DO IF ELSE FOR GOTO WHILE SWITCH SIZEOF
%token SQR_BRACKET_CLOSE SQR_BRACKET_OPEN RD_BRACKET_OPEN RD_BRACKET_CLOSE CURL_BRACKET_OPEN
%token NEG EXCLAMATION DIV MOD BIT_SHIFT_L BIT_SHIFT_R ASSIGN COMMA HASH
%token QUESTION COLON SEMICOLON 
%token ID STRING_LITERAL PUNCTUATOR SINGLE_LINE_COMMENT MULTI_LINE_COMMENT
%token INTEGER_CONSTANT FLOATING_CONSTANT ENUMERATION_CONSTANT CHARACTER_CONSTANT

%start translation_unit

%%

primary_expression
	: ID
	| constant
	| STRING_LITERAL
	| RD_BRACKET_OPEN expression RD_BRACKET_CLOSE
	{printf("primary_expression\n");}
	;

constant
	: INTEGER_CONSTANT 
	| CHARACTER_CONSTANT
	| FLOATING_CONSTANT 
	| ENUMERATION_CONSTANT 
	;

postfix_expression
	: primary_expression
	| postfix_expression SQR_BRACKET_OPEN expression SQR_BRACKET_CLOSE
	| postfix_expression RD_BRACKET_OPEN RD_BRACKET_CLOSE
	| postfix_expression DOT ID
	| postfix_expression ACC ID
	| postfix_expression RD_BRACKET_OPEN argument_expression_list RD_BRACKET_CLOSE
	| postfix_expression INC
	| postfix_expression DEC
	| RD_BRACKET_OPEN type_name RD_BRACKET_CLOSE CURL_BRACKET_OPEN initializer_list CURL_BRACKET_CLOSE
	|  RD_BRACKET_OPEN type_name RD_BRACKET_CLOSE CURL_BRACKET_OPEN initializer_list COMMA CURL_BRACKET_CLOSE
	{printf("postfix_expression\n");}
	;

unary_expression
	: postfix_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| INC unary_expression
	| DEC unary_expression
	| SIZEOF RD_BRACKET_OPEN type_name RD_BRACKET_CLOSE
	{printf("unary_expression\n");}
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list COMMA assignment_expression
	{printf("argument_expression_list\n");}
	;

unary_operator
	: AMP
	| SUB
	| NEG
	| MUL
	| ADD
	| EXCLAMATION
	{printf("unary_operator\n");}
	;

cast_expression
	: unary_expression
	| RD_BRACKET_OPEN type_name RD_BRACKET_CLOSE cast_expression
	{printf("cast_expression\n");}
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression MUL cast_expression
	| multiplicative_expression DIV cast_expression
	| multiplicative_expression MOD cast_expression
	{printf("multiplicative_expression\n");}
	;

additive_expression
	: multiplicative_expression
	| additive_expression ADD multiplicative_expression
	| additive_expression SUB multiplicative_expression
	{printf("additive_expression\n");}
	;

shift_expression
	: additive_expression
	| shift_expression L_SHIFT additive_expression
	| shift_expression R_SHIFT additive_expression
	{printf("shift_expression\n");}
	;

relational_expression
	: shift_expression
	| relational_expression BIT_SHIFT_L shift_expression
	| relational_expression BIT_SHIFT_R shift_expression
	| relational_expression LTE shift_expression
	| relational_expression GTE shift_expression
	{printf("relational_expression\n");}
	;

equality_expression
	: relational_expression
	| equality_expression EQ relational_expression
	| equality_expression NEQ relational_expression
	{printf("equality_expression\n");}
	;

and_expression
	: equality_expression
	| and_expression AMP equality_expression
	{printf("and_expression\n");}
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression
	{printf("exclusive_or_expression\n");}
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	{printf("inclusive_or_expression\n");}
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND inclusive_or_expression
	{printf("logical_and_expression\n");}
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR logical_and_expression
	{printf("logical_or_expression\n");}
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression QUESTION expression COLON conditional_expression
	{printf("conditional_expression\n");}
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	{printf("assignment_expression\n");}
	;

assignment_operator
	: ASSIGN
	{printf("assignment_operator\n");}
	| STAR_EQ
	| DIV_EQ
	| REQ_SHIFT
	| BIN_AND_EQ
	| BIN_XOR_EQ
	| MOD_EQ
	| PLUS_EQ
	| MINUS_EQ
	| LEQ_SHIFT
	| BIN_OR_EQ
	{printf("assignment_operator\n");}
	;

expression
	: assignment_expression
	| expression COMMA assignment_expression
	{printf("expression\n");}
	;

constant_expression
	: conditional_expression
	{printf("constant_expression\n");}
	;

declaration
	: declaration_specifiers SEMICOLON
	| declaration_specifiers init_declarator_list SEMICOLON
	{printf("declaration\n");}
	;

declaration_specifiers
	: storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	| function_specifier 
	| function_specifier declaration_specifiers
	{printf("declaration_specifiers\n");}
	;

init_declarator_list
	: init_declarator
	| init_declarator_list COMMA init_declarator
	{printf("init_declarator_list\n");}
	;

init_declarator
	: declarator
	| declarator ASSIGN initializer
	{printf("init_declarator\n");}
	;

storage_class_specifier
	: EXTERN
	| STATIC
	| AUTO
	| REGISTER
	{printf("storage_class_specifier\n");}
	;

type_specifier
	: VOID
	| CHAR
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| _BOOL
	| _COMPLEX
	| _IMAGINARY
	| enum_specifier
	{printf("type_specifier\n");}
	;



specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	{printf("specifier_qualifier_list\n");}
	;


enum_specifier
	: ENUM CURL_BRACKET_OPEN enumerator_list CURL_BRACKET_CLOSE
	| ENUM ID CURL_BRACKET_OPEN enumerator_list CURL_BRACKET_CLOSE
	| ENUM CURL_BRACKET_OPEN enumerator_list COMMA CURL_BRACKET_CLOSE
	| ENUM ID CURL_BRACKET_OPEN enumerator_list COMMA CURL_BRACKET_CLOSE
	| ENUM ID
	{printf("enum_specifier\n");}
	;

enumerator_list
	: enumerator
	| enumerator_list COMMA enumerator
	{printf("enumerator_list\n");}
	;

enumerator
	: ID
	| ID ASSIGN constant_expression
	{printf("enumerator\n");}
	;

type_qualifier
	: CONST
	| VOLATILE
	| RESTRICT
	{printf("type_qualifier\n");}
	;
function_specifier
	: INLINE
	{printf("function_specifier\n");}
	;
declarator
	: pointer direct_declarator
	| direct_declarator
	{printf("declarator\n");}
	;

direct_declarator
	: ID
	| RD_BRACKET_OPEN declarator RD_BRACKET_CLOSE
	| direct_declarator SQR_BRACKET_OPEN  type_qualifier_list_opt assignment_expression_opt SQR_BRACKET_CLOSE
	| direct_declarator SQR_BRACKET_OPEN STATIC type_qualifier_list_opt assignment_expression SQR_BRACKET_CLOSE
	| direct_declarator SQR_BRACKET_OPEN type_qualifier_list_opt MUL SQR_BRACKET_CLOSE
	| direct_declarator RD_BRACKET_OPEN parameter_type_list RD_BRACKET_CLOSE
	| direct_declarator RD_BRACKET_OPEN identifier_list RD_BRACKET_CLOSE
	| direct_declarator RD_BRACKET_OPEN RD_BRACKET_CLOSE
	{printf("direct_declarator\n");}
	;

type_qualifier_list_opt
	: %empty
	| type_qualifier_list
	{printf("type_qualifier_list_opt\n");}
	;
assignment_expression_opt
	: %empty
	| assignment_expression
	{printf("assignment_expression_opt\n");}
	;

pointer
	: MUL
	| MUL type_qualifier_list
	| MUL pointer
	| MUL type_qualifier_list pointer
	{printf("pointer\n");}
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	{printf("type_qualifier_list\n");}
	;


parameter_type_list
	: parameter_list
	| parameter_list COMMA DOTS
	{printf("parameter_type_list\n");}
	;

parameter_list
	: parameter_declaration
	| parameter_list COMMA parameter_declaration
	{printf("parameter_list\n");}
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers
	{printf("parameter_declaration\n");}
	;

identifier_list
	: ID
	| identifier_list COMMA ID
	{printf("identifier_list\n");}
	;

type_name
	: specifier_qualifier_list
	{printf("type_name\n");}
	;




initializer
	: assignment_expression
	| CURL_BRACKET_OPEN initializer_list COMMA CURL_BRACKET_CLOSE
	| CURL_BRACKET_OPEN initializer_list CURL_BRACKET_CLOSE
	{printf("initializer\n");}
	;

initializer_list
	: initializer
	| designation initializer
	| initializer_list COMMA initializer
	| initializer_list COMMA designation initializer
	{printf("initializer_list\n");}
	;

designation
	: designator_list ASSIGN
	{printf("designation\n");}
	;

designator_list
	: designator
	| designator_list designator
	{printf("designator_list\n");}
	;

designator
	: SQR_BRACKET_OPEN constant_expression SQR_BRACKET_CLOSE
	| DOT ID
	{printf("designator\n");}
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	{printf("statement\n");}
	;

labeled_statement
	: ID COLON statement
	| CASE constant_expression COLON statement
	| DEFAULT COLON statement
	{printf("labeled_statement\n");}
	;

compound_statement
	: CURL_BRACKET_OPEN CURL_BRACKET_CLOSE
	| CURL_BRACKET_OPEN block_item_list CURL_BRACKET_CLOSE
	{printf("compound_statement\n");}
	;

block_item_list
	: block_item
	| block_item_list block_item
	{printf("block_item_list\n");}
	;

block_item
	: declaration
	| statement
	{printf("block_item\n");}
	;


expression_statement
	: SEMICOLON
	| expression SEMICOLON
	{printf("expression_statement\n");}
	;

selection_statement
	: IF RD_BRACKET_OPEN expression RD_BRACKET_CLOSE statement
	| IF RD_BRACKET_OPEN expression RD_BRACKET_CLOSE statement ELSE statement
	| SWITCH RD_BRACKET_OPEN expression RD_BRACKET_CLOSE statement
	{printf("selection_statement\n");}
	;

iteration_statement
	: WHILE RD_BRACKET_OPEN expression RD_BRACKET_CLOSE statement
	| DO statement WHILE RD_BRACKET_OPEN expression RD_BRACKET_CLOSE SEMICOLON
	| FOR RD_BRACKET_OPEN expression_statement expression_statement RD_BRACKET_CLOSE statement
	| FOR RD_BRACKET_OPEN expression_statement expression_statement expression RD_BRACKET_CLOSE statement
	{printf("iteration_statement\n");}
	;

jump_statement
	: GOTO ID SEMICOLON
	| CONTINUE SEMICOLON
	| BREAK SEMICOLON
	| RETURN SEMICOLON
	| RETURN expression SEMICOLON
	
	{printf("jump_statement\n");}
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	{printf("translation_unit\n");}
	;

external_declaration
	: function_definition
	| declaration
	{printf("external_declaration\n");}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	| declarator declaration_list compound_statement
	| declarator compound_statement
	{printf("function_definition\n");}
	;
declaration_list
	: declaration
	| declaration_list declaration
	{printf("declaration_list\n");}
	;

%%
void yyerror(char *s) {
	printf ("\nERROR: %s\n",s);
}
