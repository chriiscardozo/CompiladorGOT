%{

#include <string>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

struct Tipo {
  string nome;

  Tipo(){}
  Tipo(string nome){ this->nome = nome; }
};
struct Atributo {
  string v; // Valor
  Tipo t;   // Tipo
  string c; // Código

  Atributo(){}
  Atributo(string v, string t="", string c =""){
    this->v = v;
    this->t.nome = t;
    this->c = c;
  }
};

#define YYSTYPE Atributo

void yyerror(const char*);
int yylex();
int yyparse();

string gerarIncludeC(string bib);

%}

%token TK_INICIO TK_INCLUDE TK_BIB_INCLUDE TK_PROTOTIPO
%token TK_ID TK_CTE_INT TK_CTE_DOUBLE TK_CTE_FLOAT TK_CTE_CHAR TK_CTE_STRING TK_CTE_BOOL_TRUE TK_CTE_BOOL_FALSE
%token TK_INT TK_DOUBLE TK_FLOAT TK_STRING TK_CHAR TK_BOOL TK_VOID TK_NULL
%token TK_DECLARAR_VAR TK_AS
%token TK_MAIN TK_COMECA_BLOCO TK_TERMINA_BLOCO TK_TERMINA_MAIN TK_COMECA_FUNCAO TK_TERMINA_FUNCAO
%token TK_ADICAO TK_SUBTRACAO TK_MULTIPLICACAO TK_DIVISAO TK_MODULO
%token TK_COMP_MENOR TK_COMP_MAIOR TK_COMP_MENOR_IGUAL TK_COMP_MAIOR_IGUAL TK_COMP_IGUAL TK_COMP_DIFF
%token TK_OR TK_AND TK_NOT
%token TK_ATRIBUICAO
%token TK_IF TK_ELSE TK_FOR TK_DO TK_WHILE TK_SWITCH TK_CASE TK_DEFAULT TK_BREAK
%token TK_RETURN
%token TK_PRINT TK_SCAN

%right TK_ATRIBUICAO
%left TK_AND TK_OR
%nonassoc TK_COMP_IGUAL TK_COMP_DIFF
%nonassoc TK_COMP_MENOR TK_COMP_MAIOR TK_COMP_MENOR_IGUAL TK_COMP_MAIOR_IGUAL
%left TK_ADICAO TK_SUBTRACAO
%left TK_MULTIPLICACAO TK_DIVISAO TK_MODULO
%right TK_NOT

%%

S : TK_INICIO INCLUDES PROT VARS_GLOBAIS FUNCOES MAIN FUNCOES	
      { cout << "// *****Welcome to the Game Of Thrones*****\n\n\n"
        << $2.c << "#include <stdio.h>\n"
                   "#include <stdlib.h>\n"
                   "#include <string.h>\n"
        << $6.c;
      }
  ;

MAIN : TK_MAIN CORPO TK_TERMINA_MAIN { $$ = Atributo(); $$.c = "int main(){\n" + $2.c + "  return 0;\n}\n"; }
     ;

FUNCOES : FUNCAO FUNCOES
        |
        ;

FUNCAO : TIPO TK_ID '(' LISTA_ARGUMENTOS ')' BLOCO
       ;

INCLUDES : TK_INCLUDE TK_BIB_INCLUDE INCLUDES { $$ = Atributo(); $$.c = gerarIncludeC($2.v) + $3.c;}
         | { $$ = Atributo(); }
         ;

PROT : TK_PROTOTIPO TIPO TK_ID '(' LISTA_ARGUMENTOS ')' ';' PROT {}
     | {}
     ;

TIPO : TK_INT
     | TK_DOUBLE
     | TK_FLOAT
     | TK_STRING
     | TK_CHAR
     | TK_BOOL
     | TK_VOID
     ;

LISTA_ARGUMENTOS : ARGUMENTOS
                 |
                 ;

ARGUMENTOS : TIPO TK_ID ARRAY ',' ARGUMENTOS
           | TIPO TK_ID ARRAY
           ;

VARS_GLOBAIS : VAR_GLOBAL ';' VARS_GLOBAIS
             |
             ;

VAR_GLOBAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO
           ;

LISTA_IDS : TK_ID ARRAY ',' LISTA_IDS
          | TK_ID ARRAY;

ARRAY : '[' TK_CTE_INT ']' ARRAY
      |
      ;

BLOCO : TK_COMECA_BLOCO CORPO TK_TERMINA_BLOCO
      | TK_COMECA_FUNCAO CORPO TK_TERMINA_FUNCAO
      ;

CORPO : VARS_LOCAIS COMANDOS
      ;

VARS_LOCAIS : VAR_LOCAL ';' VARS_LOCAIS
            |
            ;

VAR_LOCAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO
          ;

COMANDOS : COMANDO COMANDOS
         |
         ;

COMANDO : EXPRESSAO ';'
        | COMANDO_IF
        | COMANDO_WHILE
        | COMANDO_DO_WHILE ';'
        | COMANDO_FOR
        | COMANDO_SWITCH
        | COMANDO_RETURN ';'
        | COMANDO_SCAN ';'
        | COMANDO_PRINT ';'
        | COMANDO_BREAK ';'
        | ';'
        | TK_COMECA_BLOCO CORPO TK_TERMINA_BLOCO
        ;

COMANDO_BREAK : TK_BREAK
              ;

CHAMADA_FUNCAO : TK_ID '(' LISTA_PARAMETROS ')'
               ;

LISTA_PARAMETROS : PARAMETROS
                 |
                 ;

PARAMETROS : EXPRESSAO ',' PARAMETROS
           | EXPRESSAO
           ;

EXPRESSAO : EXPRESSAO TK_ADICAO EXPRESSAO
          | EXPRESSAO TK_SUBTRACAO EXPRESSAO
          | EXPRESSAO TK_MULTIPLICACAO EXPRESSAO
          | EXPRESSAO TK_DIVISAO EXPRESSAO
          | EXPRESSAO TK_MODULO EXPRESSAO
          | EXPRESSAO TK_COMP_MENOR EXPRESSAO
          | EXPRESSAO TK_COMP_MAIOR EXPRESSAO
          | EXPRESSAO TK_COMP_MENOR_IGUAL EXPRESSAO
          | EXPRESSAO TK_COMP_MAIOR_IGUAL EXPRESSAO
          | EXPRESSAO TK_COMP_IGUAL EXPRESSAO
          | EXPRESSAO TK_COMP_DIFF EXPRESSAO
          | EXPRESSAO TK_OR EXPRESSAO
          | EXPRESSAO TK_AND EXPRESSAO
          | TK_NOT EXPRESSAO
          | TK_ID ARRAY TK_ATRIBUICAO EXPRESSAO
          | CHAMADA_FUNCAO
          | TERMINAL
          ;

TERMINAL : TK_ID ARRAY
         | TK_CTE_INT
         | TK_CTE_DOUBLE
         | TK_CTE_FLOAT
         | TK_CTE_CHAR
         | TK_CTE_STRING
         | TK_CTE_BOOL_TRUE
         | TK_CTE_BOOL_FALSE
         | '(' EXPRESSAO ')'
         | TK_NULL
         ;

COMANDO_IF : TK_IF '(' EXPRESSAO ')' BLOCO
           | TK_IF '(' EXPRESSAO ')' BLOCO TK_ELSE BLOCO
           ;

COMANDO_WHILE : TK_WHILE '(' EXPRESSAO ')' BLOCO
              ;

COMANDO_DO_WHILE : TK_DO BLOCO TK_WHILE '(' EXPRESSAO ')'
                 ;

COMANDO_FOR : TK_FOR '(' EXPRESSAO_FOR ';' EXPRESSAO_FOR ';' EXPRESSAO_FOR ')' BLOCO
            ;

EXPRESSAO_FOR : EXPRESSAO
              |
              ;

COMANDO_SWITCH : TK_SWITCH '(' EXPRESSAO ')' TK_COMECA_BLOCO LISTA_CASE TK_TERMINA_BLOCO
               ;

LISTA_CASE : CASE LISTA_CASE
           | DEFAULT
           |
           ;

CASE : TK_CASE EXPRESSAO ':' CORPO
     ;

DEFAULT : TK_DEFAULT ':' CORPO
        ;

COMANDO_RETURN : TK_RETURN EXPRESSAO
               ;

COMANDO_SCAN : TK_SCAN '(' TK_ID ')'
             ;

COMANDO_PRINT : TK_PRINT '(' EXPRESSAO ')'
              ;

%%

int contadorLinha = 1;

#include "lex.yy.c"

void yyerror( const char* st ){
  puts( st );
  //cout << "Perto de " << yytext;
  printf( "Na linha: %d. Perto de: '%s'\n", contadorLinha, yytext );
}

string gerarIncludeC(string bib){
  return "#include "+bib+"\n";
}

int main( int argc, char* argv[] ){
//  inicializaResultadoOperador();
  yyparse();
}
