%{
#include <stdio.h>
#include <string.h>
%}

%{
#define	INT			17
#define CONST 		18
#define AUTO		19
#define ENUM		20
#define RESTRICT	21
#define UNSIGNED	22
#define BREAK		23
#define EXTERN		24
#define RETURN		25
#define VOID		26
#define CASE		27
#define FLOAT		28
#define SHORT		29
#define VOLATILE	30
#define CHAR		31
#define FOR			32
#define SIGNED		33
#define WHILE		34
#define GOTO		35
#define SIZEOF		36
#define _BOOL		37
#define CONTINUE	38
#define IF			39
#define STATIC		40
#define _COMPLEX	41
#define DEFAULT		42
#define INLINE		43
#define STRUCT		44
#define _IMAGINARY	45
#define DO			46
#define SWITCH		47
#define DOUBLE		48
#define LONG		49
#define TYPEDEF		50
#define ELSE		51
#define REGISTER	52
#define UNION		53

#define DIGIT					54
#define IDENTIFIER_NONDIGIT 	55
#define IDENTIFIER 				56

#define NONZERO_DIGIT				57
#define NONZERO_INTEGER_CONSTANT	58
#define INTEGER_CONSTANT			59
#define CONSTANT					60
#define DIGIT_SEQUENCE				61
#define SIGN 						62
#define EXPONENT_PART				63
#define FRACTIONAL_CONSTANT			64
#define FLOATING_CONSTANT			65
#define ENUMERATION_CONSTANT		66
#define ESCAPE_SEQUENCE				67
#define C_CHAR 						68
#define C_CHAR_SEQUENCE				69
#define CHARACTER_CONSTANT			70

#define S_CHAR  			71
#define S_CHAR_SEQUENCE		72
#define STRING_LITERAL 		73

#define SQ_BRACKET_OPEN		74
#define SQ_BRACKET_CLOSE	75
#define RO_BRACKET_OPEN		76
#define RO_BRACKET_CLOSE	77
#define CUR_BRACKET_OPEN	78
#define CUR_BRACKET_CLOSE	79
#define DOT 			80
#define ACC				81
#define INC 			82
#define DEC 			83
#define AMP 			84
#define MUL 			85
#define ADD 			86
#define SUB 			87
#define NEG 			88
#define EXCLAIM 		89
#define DIV 			90
#define MODULO 			91
#define SHIFT_L 		92
#define SHIFT_R 		93
#define BIT_SHIFT_L 	94
#define BIT_SHIFT_R		95
#define LTE 			96
#define GTE 			97
#define EQ 				98
#define NEQ 			99
#define AND 			100
#define OR 				101
#define QUESTION    	102
#define COLON 			103
#define SEMICOLON 		104
#define DOTS 			105
#define ASSIGN			106
#define STAR_EQ 		107
#define DIV_EQ 			108
#define MOD_EQ 			109
#define PLUS_EQ			110
#define MINUS_EQ  		111
#define SHIFT_LEQ       112
#define SHIFT_REQ 		113
#define BIN_AND_EQ 		114
#define BIN_XOR_EQ		115
#define BIN_OR_EQ 		116
#define COMMA 			117
#define HASH 			118

#define SINGLE_LINE_COMMENT			119
#define MULTI_LINE_COMMENT			120
#define COMMENT 					121

%}

/* KEYWORDS */
AUTO		"auto"
ENUM		"enum"
RESTRICT	"restrict"
UNSIGNED	"unsigned"
BREAK		"break"
EXTERN		"extern"
RETURN		"return"
VOID		"void"
CASE		"case"
FLOAT		"float"
SHORT		"short"
VOLATILE	"volatile"
CHAR		"char"
FOR			"for"
SIGNED		"signed"
WHILE		"while"
CONST		"const"
GOTO		"goto"
SIZEOF		"sizeof"
_BOOL		"_Bool"
CONTINUE	"continue"
IF			"if"
STATIC		"static"
_COMPLEX	"_Complex"
DEFAULT		"default"
INLINE		"inline"
STRUCT		"struct"
_IMAGINARY	"_Imaginary"
DO			"do"
INT			"int"
SWITCH		"switch"
DOUBLE		"double"
LONG		"long"
TYPEDEF		"typedef"
ELSE		"else"
REGISTER	"register"
UNION		"union"

/* IDENTIFIERS */
DIGIT						[0-9]
IDENTIFIER_NONDIGIT 		[a-zA-Z_]+
IDENTIFIER 					{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

/* CONSTANTS */
NONZERO_DIGIT				[1-9]
NONZERO_INTEGER_CONSTANT	{NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*
INTEGER_CONSTANT			{NONZERO_INTEGER_CONSTANT}|"0"
CONSTANT					{INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{ENUMERATION_CONSTANT}|{CHARACTER_CONSTANT}
DIGIT_SEQUENCE				[0-9]+
SIGN 						"+"|"-"
EXPONENT_PART				("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT			({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
FLOATING_CONSTANT			({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})
ENUMERATION_CONSTANT		{IDENTIFIER}
ESCAPE_SEQUENCE				"\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR 						{ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT			"\'"{C_CHAR_SEQUENCE}"\'"

/* STRING LITERALS */
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				"\""{S_CHAR_SEQUENCE}?"\""

/* PUNCTUATORS */
PUNCTUATORA					"["|"]"|"("|")"|"{"|"}"|"."|"->"
PUNCTUATORB					"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"
PUNCTUATORC					"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"
PUNCTUATORD					"?"|":"|";"|"..."|","|"#"
PUNCTUATORE					"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="
PUNCTUATOR 					{PUNCTUATORA}|{PUNCTUATORB}|{PUNCTUATORC}|{PUNCTUATORD}|{PUNCTUATORE}

/* COMMMENTS */
SINGLE_LINE_COMMENT			"//"[^("\n")]*
MULTI_LINE_COMMENT			"/*"([^*]|\*+[^*/])*\*+"/"
COMMENT 					{SINGLE_LINE_COMMENT}|{MULTI_LINE_COMMENT}

/* WHITE SPACE */
WS 		[ \t\n]

%%
{AUTO}			{ return AUTO; }
{ENUM}			{ return ENUM; }
{RESTRICT}		{ return RESTRICT; }
{UNSIGNED}		{ return UNSIGNED; }
{BREAK}			{ return BREAK; }
{EXTERN}		{ return EXTERN; }
{RETURN}		{ return RETURN; }
{VOID}			{ return VOID; }
{CASE}			{ return CASE; }
{FLOAT}			{ return FLOAT; }
{SHORT}			{ return SHORT; }
{VOLATILE}		{ return VOLATILE; }
{CHAR}			{ return CHAR; }
{FOR}			{ return FOR; }
{SIGNED}		{ return SIGNED; }
{WHILE}			{ return WHILE; }
{CONST}			{ return CONST; }
{GOTO}			{ return GOTO; }
{SIZEOF}		{ return SIZEOF; }
{_BOOL}			{ return _BOOL; }
{CONTINUE}		{ return CONTINUE; }
{IF}			{ return IF; }
{STATIC}		{ return STATIC; }
{_COMPLEX}		{ return _COMPLEX; }
{DEFAULT}		{ return DEFAULT; }
{INLINE}		{ return INLINE; }
{STRUCT}		{ return STRUCT; }
{_IMAGINARY}	{ return _IMAGINARY; }
{DO}			{ return DO; }
{INT}			{ return INT; }
{SWITCH}		{ return SWITCH; }
{DOUBLE}		{ return DOUBLE; }
{LONG}			{ return LONG; }
{TYPEDEF}		{ return TYPEDEF; }
{ELSE}			{ return ELSE; }
{REGISTER}		{ return REGISTER; }
{UNION}			{ return UNION; }

{IDENTIFIER}	{ return IDENTIFIER; }

{INTEGER_CONSTANT}	{ return INTEGER_CONSTANT; }

{FLOATING_CONSTANT}	{ return FLOATING_CONSTANT; }

{CHARACTER_CONSTANT} { return CHARACTER_CONSTANT; }

{STRING_LITERAL} { return STRING_LITERAL; }

{PUNCTUATOR}	{
	if(strcmp(yytext,"[") == 0) return SQ_BRACKET_OPEN;
	if(strcmp(yytext,"]") == 0) return SQ_BRACKET_CLOSE;
	if(strcmp(yytext,"(") == 0) return RO_BRACKET_OPEN;
	if(strcmp(yytext,")") == 0) return RO_BRACKET_CLOSE;
	if(strcmp(yytext,"{") == 0) return CUR_BRACKET_OPEN;
	if(strcmp(yytext,"}") == 0) return CUR_BRACKET_CLOSE;
	if(strcmp(yytext,".") == 0) return DOT;
	if(strcmp(yytext,"->") == 0) return ACC;

	if(strcmp(yytext,"++") == 0) return INC;
	if(strcmp(yytext,"--") == 0) return DEC;
	if(strcmp(yytext,"&") == 0) return AMP;
	if(strcmp(yytext,"*") == 0) return MUL;
	if(strcmp(yytext,"+") == 0) return ADD;
	if(strcmp(yytext,"-") == 0) return SUB;
	if(strcmp(yytext,"~") == 0) return NEG;
	if(strcmp(yytext,"!") == 0) return EXCLAIM;

	if(strcmp(yytext,"/") == 0) return DIV;
	if(strcmp(yytext,"%") == 0) return MODULO;
	if(strcmp(yytext,"<<") == 0) return SHIFT_L;
	if(strcmp(yytext,">>") == 0) return SHIFT_R;
	if(strcmp(yytext,"<") == 0) return BIT_SHIFT_L;
	if(strcmp(yytext,">") == 0) return BIT_SHIFT_R;
	if(strcmp(yytext,"<=") == 0) return LTE;
	if(strcmp(yytext,">=") == 0) return GTE;
	if(strcmp(yytext,"==") == 0) return EQ;
	if(strcmp(yytext,"!=") == 0) return NEQ;
	if(strcmp(yytext,"&&") == 0) return AND;
	if(strcmp(yytext,"||") == 0) return OR;

	if(strcmp(yytext,"?") == 0) return QUESTION;
	if(strcmp(yytext,":") == 0) return COLON;
	if(strcmp(yytext,";") == 0) return SEMICOLON;
	if(strcmp(yytext,"...") == 0) return DOTS;
	if(strcmp(yytext,"=") == 0) return ASSIGN;
	if(strcmp(yytext,"*=") == 0) return STAR_EQ;
	if(strcmp(yytext,"/=") == 0) return DIV_EQ;
	if(strcmp(yytext,"%=") == 0) return MOD_EQ;
	if(strcmp(yytext,"+=") == 0) return PLUS_EQ;
	if(strcmp(yytext,"-=") == 0) return MINUS_EQ;
	if(strcmp(yytext,"<<=") == 0) return SHIFT_LEQ;
	if(strcmp(yytext,">>=") == 0) return SHIFT_REQ;
	if(strcmp(yytext,"&=") == 0) return BIN_AND_EQ;
	if(strcmp(yytext,"^=") == 0) return BIN_XOR_EQ;
	if(strcmp(yytext,"|=") == 0) return BIN_OR_EQ;
	if(strcmp(yytext,",") == 0) return COMMA;
	if(strcmp(yytext,"#") == 0) return HASH;
}

{SINGLE_LINE_COMMENT}	{ return SINGLE_LINE_COMMENT; }
{MULTI_LINE_COMMENT} 	{ return MULTI_LINE_COMMENT; }

{WS}		{/* Ignore whitespace */}
%%
