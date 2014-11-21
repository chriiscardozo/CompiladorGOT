%option case-insensitive

DELIM				[ \t]
LINHA				[\n]
NUMERO				[0-9]
LETRA				[A-Za-z_]

ID					{LETRA}({LETRA}|{NUMERO})*

CTE_INT				{NUMERO}+("n")?
CTE_DOUBLE			{NUMERO}+("."{NUMERO}+)?("n")?
CTE_FLOAT			{NUMERO}+("."{NUMERO}+)?("n")?("f")
CTE_CHAR			"\'"."\'"
CTE_STRING			"\""[^"\n]*"\""
CTE_BOOL_TRUE		"FIRE"
CTE_BOOL_FALSE		"ICE"

COMENTARIO 			"#HODOR".*"\n"

TIPO_INTEIRO		"stark"
TIPO_DOUBLE			"baratheon"
TIPO_FLOAT			"tully"
TIPO_CHAR			"lannister"
TIPO_STRING			"targaryen"
TIPO_BOOL			"martell"
TIPO_VOID			"unsullied"

ATRIBUICAO			"="


PRINCIPAL_FUNCAO	"first_of_his_name()"
COMECA_BLOCO		"{"
TERMINA_BLOCO		"}"

TERMINA_MAIN		"and_now_his_watch_is_ended"

COMECA_FUNCAO		"winter_is_coming"
TERMINA_FUNCAO		"all_functions_must_die"|"valar_morghulis"

IF					"what_do_we_say_to_death"
ELSE				"not_today"
FOR					"for_the_lord_of_winterfell"
DO					"and_so_he_spokes"
WHILE				"while_the_proud_lord_says"
SWITCH				"which_house_do_you_belong_in"
CASE 				"house"
DEFAULT				"free_folk"

RETURN				"the_lannister_send_their_regards"

SCAN				"maester_read"
PRINT				"maester_write"

OR 					"||"
AND 				"&&"
NOT 				"!"

COMP_MAIOR 			">"
COMP_MENOR 			"<"
COMP_MAIOR_IGUAL 	">="
COMP_MENOR_IGUAL 	"<="
COMP_IGUAL 			"=="
COMP_DIFF			"!="

ADICAO				"+"
SUBTRACAO			"-"
MULTIPLICACAO		"*"
DIVISAO				"/"
MODULO				"%"

PROTOTIPO			"squire"

NULL				"YOU_KNOW_NOTHING"
BREAK				"breaker_of_chains"
DECLARAR_VAR		"its_known"
AS 					"as"

INICIO				"When you play the game of thrones, you win or you die"
INCLUDE				"#dracarys"
BIB_INCLUDE			(("<")({LETRA})*(".h")?(">")|(\")({LETRA})*(".h")?(\"))

%%

{DELIM}				{}
{LINHA}				{ contadorLinha++; }
{COMENTARIO}		{}

{CTE_INT}			{ return TK_CTE_INT; }
{CTE_DOUBLE}		{ return TK_CTE_DOUBLE; }
{CTE_FLOAT}			{ return TK_CTE_FLOAT; }
{CTE_CHAR}			{ return TK_CTE_CHAR; }
{CTE_STRING}		{ return TK_CTE_STRING; }
{CTE_BOOL_TRUE}		{ return TK_CTE_BOOL_TRUE; }
{CTE_BOOL_FALSE}	{ return TK_CTE_BOOL_FALSE; }

{TIPO_INTEIRO}		{ return TK_INT; }
{TIPO_DOUBLE}		{ return TK_DOUBLE; }
{TIPO_FLOAT}		{ return TK_FLOAT; }
{TIPO_CHAR}			{ return TK_CHAR; }
{TIPO_STRING}		{ return TK_STRING; }
{TIPO_BOOL}			{ return TK_BOOL; }
{TIPO_VOID}			{ return TK_VOID; }

{ATRIBUICAO}		{ return TK_ATRIBUICAO; }

{PRINCIPAL_FUNCAO}	{ return TK_MAIN; }
{COMECA_BLOCO}		{ return TK_COMECA_BLOCO; }
{TERMINA_BLOCO}		{ return TK_TERMINA_BLOCO; }
{TERMINA_MAIN}		{ return TK_TERMINA_MAIN; }
{COMECA_FUNCAO}		{ return TK_COMECA_FUNCAO; }
{TERMINA_FUNCAO}	{ return TK_TERMINA_FUNCAO; }

{IF}				{ return TK_IF; }
{ELSE}				{ return TK_ELSE; }
{FOR}				{ return TK_FOR; }
{DO}				{ return TK_DO; }
{WHILE}				{ return TK_WHILE; }
{SWITCH}			{ return TK_SWITCH; }
{CASE} 				{ return TK_CASE; }
{DEFAULT}			{ return TK_DEFAULT; }

{RETURN}			{ return TK_RETURN; }

{SCAN}				{ return TK_SCAN; }
{PRINT}				{ return TK_PRINT; }


{OR}				{ return TK_OR; }
{AND} 				{ return TK_AND; }
{NOT} 				{ return TK_NOT; }

{COMP_MAIOR}		{ return TK_COMP_MAIOR; }
{COMP_MENOR} 		{ return TK_COMP_MENOR; }
{COMP_MAIOR_IGUAL}	{ return TK_COMP_MAIOR_IGUAL; }
{COMP_MENOR_IGUAL} 	{ return TK_COMP_MENOR_IGUAL; }
{COMP_IGUAL} 		{ return TK_COMP_IGUAL; }
{COMP_DIFF}			{ return TK_COMP_DIFF; }

{ADICAO}			{ return TK_ADICAO; }
{SUBTRACAO}			{ return TK_SUBTRACAO; }
{MULTIPLICACAO}		{ return TK_MULTIPLICACAO; }
{DIVISAO}			{ return TK_DIVISAO; }
{MODULO}			{ return TK_MODULO; }

{PROTOTIPO}			{ return TK_PROTOTIPO; }

{NULL} 				{ return TK_NULL; }
{BREAK} 			{ return TK_BREAK; }
{DECLARAR_VAR}		{ return TK_DECLARAR_VAR; }
{AS}				{ return TK_AS; }

{INICIO}			{ return TK_INICIO; }
{INCLUDE}			{ return TK_INCLUDE; }
{BIB_INCLUDE}		{ yylval = Atributo(yytext); return TK_BIB_INCLUDE; }

{ID}				{ yylval = Atributo(yytext); return TK_ID;}

.					{ return *yytext; }

%%
