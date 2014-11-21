%{

#include <string>
#include <iostream>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <vector>

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
struct SimboloVariavel{
  string nome;
  Tipo t;
  int escopo;

  SimboloVariavel(){}
  SimboloVariavel(string nome, string tipo, int escopo){this->nome = nome; this->t = tipo; this->escopo = escopo;}
};

#define YYSTYPE   Atributo

#define COLOR_RED     "\x1B[31m"
#define COLOR_RESET   "\x1B[0m"

#define C_INT     "int"
#define C_DOUBLE  "double"
#define C_FLOAT   "float"
#define C_CHAR    "char"
#define C_STRING  "string"
#define C_BOOL    "bool"
#define C_VOID    "void"

#define MAX_STR   256

void yyerror(const char*);
void erro(string msg);
int yylex();
int yyparse();

vector<string> &split(const string &s, char delim, vector<string> &elems);
vector<string> split(const string &s, char delim);
string toStr(int n);
string gerarIncludeC(string bib);
string declararVariavel(string tipo, string vars, int escopo);
void inserirVariavelTabela(string tipo, string nome, int escopo);
bool buscaVariavelDeclarada(string tipo, string nome, int escopo);

int escopoAtual = 0;

typedef map<string, SimboloVariavel> TSV; // TabelaSimbolosVariavel: Key ==> contat(escopo,nomeVar);
TSV tabelaSimbolosVariavel;

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
        << $4.c
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

TIPO : TK_INT     { $$ = Atributo(C_INT);     }
     | TK_DOUBLE  { $$ = Atributo(C_DOUBLE);  }
     | TK_FLOAT   { $$ = Atributo(C_FLOAT);   }
     | TK_STRING  { $$ = Atributo(C_STRING);  }
     | TK_CHAR    { $$ = Atributo(C_CHAR);    }
     | TK_BOOL    { $$ = Atributo(C_BOOL);    }
     | TK_VOID    { $$ = Atributo(C_VOID);    }
     ;

LISTA_ARGUMENTOS : ARGUMENTOS
                 |
                 ;

ARGUMENTOS : TIPO TK_ID ARRAY ',' ARGUMENTOS
           | TIPO TK_ID ARRAY
           ;

VARS_GLOBAIS : VAR_GLOBAL ';' VARS_GLOBAIS { $$ = Atributo();  $$.c = $1.c + ";\n" + $3.c; }
             | { $$ = Atributo(); }
             ;

VAR_GLOBAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO { $$ = Atributo(); $$.c = declararVariavel($4.v, $2.c, 0); }
           ;

LISTA_IDS : TK_ID ARRAY ',' LISTA_IDS { $$ = Atributo(); $$.c = $1.v + "," + $4.c; } // FALTA ARRAY
          | TK_ID ARRAY { $$ = Atributo(); $$.c = $1.v; }
          ;

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
  printf( "[%sERRO%s] Na linha: %d. Perto de: '%s'\n", COLOR_RED, COLOR_RESET, contadorLinha, yytext );
}

void erro(string msg){
  yyerror(msg.c_str());
  exit(0);
}

string toStr(int n){
  char buf[1024] = "";
  sprintf( buf, "%d", n );
  return buf;
}

string gerarIncludeC(string bib){
  return "#include "+bib+"\n";
}

string declararVariavel(string tipo, string vars, int escopo){
  vector<string> vetorVars = split(vars, ',');
  string codigo =  tipo + " ";
  string decl = vars;

  if(tipo == C_STRING){
    codigo = string(C_CHAR) + " ";
    decl = "";
  }

  for(int i = 0; i < vetorVars.size(); i++){
    inserirVariavelTabela(tipo, vetorVars.at(i), escopo);

    if(tipo == C_STRING){
      decl = decl + vetorVars.at(i) + "[" + toStr(MAX_STR) +"]";
      if(i+1 < vetorVars.size())
        decl = decl + ",";
    }
  }

  codigo = codigo + decl;
  return codigo;
}

void inserirVariavelTabela(string tipo, string nome, int escopo){
  if(!buscaVariavelDeclarada(tipo, nome, escopo)){
    tabelaSimbolosVariavel[toStr(escopo)+nome] = SimboloVariavel(nome, tipo, escopo);
  }
  else{
    erro("Variavel ja definida: " + nome +"\n");
  }
}

bool buscaVariavelDeclarada(string tipo, string nome, int escopo){
  if(tabelaSimbolosVariavel.find(toStr(escopo) + nome) != tabelaSimbolosVariavel.end())
    return true;
  else
    return false;
}

vector<string> &split(const string &s, char delim, vector<string> &elems){
    stringstream ss(s);
    string item;
    while (getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}

vector<string> split(const string &s, char delim){
    vector<string> elems;
    split(s, delim, elems);
    return elems;
}

int main( int argc, char* argv[] ){
//  inicializaResultadoOperador();
  yyparse();
}
