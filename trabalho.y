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
    int ndim; // ndim == 0 ? não é array : é array;
    int t_dim[2];

    Tipo(){}
    Tipo(string nome, int ndim = 0, int t_dim1 = 0, int t_dim2 = 0) : nome(nome), ndim(ndim) {
      t_dim[0] = t_dim1;
      t_dim[1] = t_dim2;
    }
};

struct Atributo {
    string v; // Valor
    Tipo t;   // Tipo
    string c; // Código

    Atributo() {}
    Atributo(string v, string t = "", string c = "") : v(v), t(t), c(c) {}
    Atributo(string v, Tipo t, string c = "") : v(v), t(t), c(c) {}
};

struct SimboloVariavel{
    string nome;
    Tipo t;
    int bloco;

    SimboloVariavel() {}
    SimboloVariavel(string nome, string tipo, int bloco)
        : nome(nome), t(tipo), bloco(bloco) {}
    SimboloVariavel(string nome, Tipo tipo, int bloco)
        : nome(nome), t(tipo), bloco(bloco) {}
};

#define YYSTYPE     Atributo

#define COLOR_RED   "\x1B[31m"
#define COLOR_RESET "\x1B[0m"
#define TAB         "    "

#define C_INT       "int"
#define C_DOUBLE    "double"
#define C_FLOAT     "float"
#define C_CHAR      "char"
#define C_STRING    "string"
#define C_BOOL      "bool"
#define C_VOID      "void"

#define MAX_STR     256

void yyerror(const char*);
void erro(string msg);
int yylex();
int yyparse();

int id_bloco = 0;
string codigoVarsProcedimento = "";
int id_label = 0;

typedef map<string, SimboloVariavel> TSV;
vector<TSV> tabelaVariaveis;

vector<string> split(string s, char delim);
string toStr(int n);
void replaceAll(string &s, const string &search, const string &replace);

string validarAcessoArray(string var, string dims);
vector<string> traduzDimensoesArray(string aux);
string gerarIncludeC(string bib);
string declararVariavel(string tipo_base, string vars, int bloco);
void inserirVariavelTabela(TSV &tabela, Tipo tipo, string nome, int bloco);
bool variavelDeclarada(const TSV &tabela, string nome);
Atributo buscaVariavel(string nome);
void removerBlocoVars();
void adicionarNovaTabelaVariaveis();

void adicionarVariaveisProcedimento(string codigo);
void resetVariaveisProcedimento();

void inicializaResultadoOperador();
Tipo tipoResultado(const Tipo &a, string op, const Tipo &b);
void resetVarsTemp();
string geraCodigoVarsTemp();
string geraVarTemp(const Tipo &t);
void geraCodigoOperadorBinario(Atributo &SS, const Atributo &S1, const Atributo &S2, const Atributo &S3);
string gerarCodigoPrint(Atributo &S);

string gerarLabel();
string gerarCodigoIfElse(const Atributo &expr, const Atributo &cod_if, const Atributo &cod_else);

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
        << "\n"
        << $3.c // prototipos
        << $4.c // vars_globais
        << $5.c + $7.c // funcoes
        << $6.c // main
        << endl;
      }
  ;

MAIN : COMECA_MAIN CORPO TK_TERMINA_MAIN
        {
            $$ = Atributo();
            $$.c = "\n"
                   "int main() {\n" +
                   geraCodigoVarsTemp() +
                   codigoVarsProcedimento + '\n' +
                   $2.c +
                   '\n' + TAB + "return 0;\n"
                   "}\n";
            resetVarsTemp();
            removerBlocoVars();
            resetVariaveisProcedimento();
        }
     ;

COMECA_MAIN : TABELA_VARS TK_MAIN
            ;

FUNCOES : FUNCAO FUNCOES { $$.c = $1.c + $2.c; }
        | { $$ = Atributo(); }
        ;

FUNCAO : TIPO TK_ID '(' LISTA_ARGUMENTOS ')' BLOCO
        {
            // TODO falta argumentos!
            $$ = Atributo();
            $$.c = "\n" +
                   $1.v + " " + $2.v + "(" + $4.c + ") {\n" +
                   geraCodigoVarsTemp() +
                   codigoVarsProcedimento + '\n' +
                   $6.c +
                   "}\n";
            resetVarsTemp();
            resetVariaveisProcedimento();
        }
       ;

INCLUDES : TK_INCLUDE TK_BIB_INCLUDE INCLUDES { $$ = Atributo(); $$.c = gerarIncludeC($2.v) + $3.c; }
         | { $$ = Atributo(); }
         ;

PROT : TK_PROTOTIPO TIPO TK_ID '(' LISTA_ARGUMENTOS ')' ';' PROT
     | { $$ = Atributo(); }
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
                 | { $$ = Atributo(); }
                 ;

ARGUMENTOS : TIPO TK_ID ARRAY ',' ARGUMENTOS
           | TIPO TK_ID ARRAY
           ;

VARS_GLOBAIS : TABELA_VARS VAR_GLOBAL VARS_GLOBAIS { $$ = Atributo();  $$.c = $1.c + $2.c; }
             | { $$ = Atributo(); }
             ;

TABELA_VARS : { adicionarNovaTabelaVariaveis(); }
            ;

VAR_GLOBAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO ';' { $$ = Atributo(); $$.c = declararVariavel($4.v, $2.c, 0) + ";\n"; }
           ;

LISTA_IDS : TK_ID ARRAY ',' LISTA_IDS { $$ = Atributo(); $$.c = $1.v + $2.c + "," + $4.c; } // FALTA ARRAY
          | TK_ID ARRAY { $$ = Atributo(); $$.c = $1.v + $2.c; }
          ;

ARRAY : '[' TK_CTE_INT ']' ARRAY { $$ = Atributo(); $$.c = "[" + $2.v + "]" + $4.c; }
      | { $$ = Atributo(); }
      ;

BLOCO : COMECA_BLOCO CORPO TK_TERMINA_BLOCO      { $$.c = $2.c; removerBlocoVars(); }
      | COMECA_BLOCO CORPO TK_TERMINA_FUNCAO   	 { $$.c = $2.c; removerBlocoVars(); }
      ;

COMECA_BLOCO : TABELA_VARS TK_COMECA_BLOCO  { }
             | TABELA_VARS TK_COMECA_FUNCAO { }
             ;

CORPO : VARS_LOCAIS COMANDOS { adicionarVariaveisProcedimento($1.c); $$.c = $2.c; }
      ;

VARS_LOCAIS : VAR_LOCAL VARS_LOCAIS  { $$ = Atributo(); $$.c = $1.c + $2.c; }
            | { $$ = Atributo(); }
            ;

VAR_LOCAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO ';' { $$ = Atributo(); $$.c = declararVariavel($4.v, $2.c, id_bloco) + ";\n"; }
          ;

COMANDOS : COMANDO COMANDOS { $$.c = $1.c + $2.c; }
         | { $$ = Atributo(); }
         ;

COMANDO : EXPRESSAO ';' { $$.c = $1.c; }
        | COMANDO_IF
        | COMANDO_WHILE
        | COMANDO_DO_WHILE ';'
        | COMANDO_FOR
        | COMANDO_SWITCH
        | COMANDO_RETURN ';'
        | COMANDO_SCAN ';'
        | COMANDO_PRINT ';' { $$ = Atributo(); $$.c = $1.c; }
        | COMANDO_BREAK ';'
        | BLOCO	{ $$.c = $1.c; }
        | ';'
        ;

COMANDO_BREAK : TK_BREAK
              ;

CHAMADA_FUNCAO : TK_ID '(' LISTA_PARAMETROS ')'
               ;

LISTA_PARAMETROS : PARAMETROS
                 | { $$ = Atributo(); }
                 ;

PARAMETROS : EXPRESSAO ',' PARAMETROS
           | EXPRESSAO
           ;

EXPRESSAO : EXPRESSAO TK_ADICAO EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_SUBTRACAO EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_MULTIPLICACAO EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_DIVISAO EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_MODULO EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MENOR EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MAIOR EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MENOR_IGUAL EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_MAIOR_IGUAL EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_IGUAL EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_COMP_DIFF EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_OR EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | EXPRESSAO TK_AND EXPRESSAO
            { geraCodigoOperadorBinario($$, $1, $2, $3); }
          | TK_NOT EXPRESSAO
          | TK_ID ARRAY TK_ATRIBUICAO EXPRESSAO
            { 
              Atributo A = buscaVariavel($1.v);
              string posicaoAcesso = validarAcessoArray($1.v, $2.c); 
              A.v = A.v + posicaoAcesso;
              geraCodigoOperadorBinario($$, A, $3, $4); } // TODO Falta atribuir para array
          | CHAMADA_FUNCAO
          | TERMINAL
            { $$ = $1; }
          ;

TERMINAL : TK_ID ARRAY
            { $$ = buscaVariavel($1.v); string posicaoAcesso = validarAcessoArray($1.v, $2.c); 
              $$.v = $$.v + posicaoAcesso;
            }
         | TK_CTE_INT
            { $$ = Atributo($1.v, C_INT); }
         | TK_CTE_DOUBLE
            { $$ = Atributo($1.v, C_DOUBLE); }
         | TK_CTE_FLOAT
            { $$ = Atributo($1.v, C_FLOAT); }
         | TK_CTE_CHAR
            { $$ = Atributo($1.v, C_CHAR); }
         | TK_CTE_STRING
            { $$ = Atributo($1.v, C_STRING); }
         | TK_CTE_BOOL_TRUE
            { $$ = Atributo(/*$1.v*/"1", C_BOOL); }
         | TK_CTE_BOOL_FALSE
            { $$ = Atributo(/*$1.v*/"0", C_BOOL); }
         | TK_NULL
            { }
         | '(' EXPRESSAO ')'
            { $$ = $2; }
         ;

COMANDO_IF : TK_IF '(' EXPRESSAO ')' BLOCO
            { $$.c = gerarCodigoIfElse($3, $5, Atributo()); }
           | TK_IF '(' EXPRESSAO ')' BLOCO TK_ELSE BLOCO
            { $$.c = gerarCodigoIfElse($3, $5, $7); }
           ;

COMANDO_WHILE : TK_WHILE '(' EXPRESSAO ')' BLOCO
              ;

COMANDO_DO_WHILE : TK_DO BLOCO TK_WHILE '(' EXPRESSAO ')'
                 ;

COMANDO_FOR : TK_FOR '(' EXPRESSAO_FOR ';' EXPRESSAO_FOR ';' EXPRESSAO_FOR ')' BLOCO
            ;

EXPRESSAO_FOR : EXPRESSAO
              | { $$ = Atributo(); }
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

COMANDO_PRINT : TK_PRINT '(' EXPRESSAO ')' { $$.c = gerarCodigoPrint($3); }
              ;

%%

int contadorLinha = 1;

map<string, Tipo> resultadoOperador;
map<string, int> n_var_temp;

void inicializaResultadoOperador() {
    // = 
    resultadoOperador["int=int"] = Tipo("int");
    resultadoOperador["double=double"] = Tipo("double");
    resultadoOperador["float=float"] = Tipo("float");
    resultadoOperador["double=int"] = Tipo("double");
    resultadoOperador["float=int"] = Tipo("float");
    resultadoOperador["double=float"] = Tipo("double");
    resultadoOperador["string=string"] = Tipo("string");
    resultadoOperador["string=char"] = Tipo("string");
    resultadoOperador["char=char"] = Tipo("char");
    resultadoOperador["char=int"] = Tipo("char");
    resultadoOperador["int=char"] = Tipo("int");
    resultadoOperador["bool=bool"] = Tipo("bool");

    // +
    resultadoOperador["int+int"] = Tipo("int");
    resultadoOperador["double+double"] = Tipo("double");
    resultadoOperador["float+float"] = Tipo("float");
    resultadoOperador["double+int"] = Tipo("double");
    resultadoOperador["int+double"] = Tipo("double");
    resultadoOperador["float+int"] = Tipo("float");
    resultadoOperador["int+float"] = Tipo("float");
    resultadoOperador["double+float"] = Tipo("double");
    resultadoOperador["float+double"] = Tipo("double");
    resultadoOperador["string+string"] = Tipo("string");
    resultadoOperador["string+char"] = Tipo("string");
    resultadoOperador["char+string"] = Tipo("string");
    resultadoOperador["char+char"] = Tipo("string");
    resultadoOperador["char+int"] = Tipo("char");
    resultadoOperador["int+char"] = Tipo("char");


    // -
    resultadoOperador["int-int"] = Tipo("int");
    resultadoOperador["double-double"] = Tipo("double");
    resultadoOperador["float-float"] = Tipo("float");
    resultadoOperador["double-int"] = Tipo("double");
    resultadoOperador["int-double"] = Tipo("double");
    resultadoOperador["float-int"] = Tipo("float");
    resultadoOperador["int-float"] = Tipo("float");
    resultadoOperador["double-float"] = Tipo("double");
    resultadoOperador["float-double"] = Tipo("double");
    resultadoOperador["char-int"] = Tipo("char");
    resultadoOperador["int-char"] = Tipo("char");

    // *
    resultadoOperador["int*int"] = Tipo("int");
    resultadoOperador["double*double"] = Tipo("double");
    resultadoOperador["float*float"] = Tipo("float");
    resultadoOperador["double*int"] = Tipo("double");
    resultadoOperador["int*double"] = Tipo("double");
    resultadoOperador["float*int"] = Tipo("float");
    resultadoOperador["int*float"] = Tipo("float");
    resultadoOperador["double*float"] = Tipo("double");
    resultadoOperador["float*double"] = Tipo("double");

    // /
    resultadoOperador["int/int"] = Tipo("int");
    resultadoOperador["double/double"] = Tipo("double");
    resultadoOperador["float/float"] = Tipo("float");
    resultadoOperador["double/int"] = Tipo("double");
    resultadoOperador["int/double"] = Tipo("double");
    resultadoOperador["float/int"] = Tipo("float");
    resultadoOperador["int/float"] = Tipo("float");
    resultadoOperador["double/float"] = Tipo("double");
    resultadoOperador["float/double"] = Tipo("double");

    // <
    resultadoOperador["int<int"] = Tipo("bool");
    resultadoOperador["double<double"] = Tipo("bool");
    resultadoOperador["float<float"] = Tipo("bool");
    resultadoOperador["double<int"] = Tipo("bool");
    resultadoOperador["int<double"] = Tipo("bool");
    resultadoOperador["float<int"] = Tipo("bool");
    resultadoOperador["int<float"] = Tipo("bool");
    resultadoOperador["double<float"] = Tipo("bool");
    resultadoOperador["float<double"] = Tipo("bool");
    resultadoOperador["string<string"] = Tipo("bool");
    resultadoOperador["char<char"] = Tipo("bool");
    resultadoOperador["char<int"] = Tipo("bool");
    resultadoOperador["int<char"] = Tipo("bool");

    // >
    resultadoOperador["int>int"] = Tipo("bool");
    resultadoOperador["double>double"] = Tipo("bool");
    resultadoOperador["float>float"] = Tipo("bool");
    resultadoOperador["double>int"] = Tipo("bool");
    resultadoOperador["int>double"] = Tipo("bool");
    resultadoOperador["float>int"] = Tipo("bool");
    resultadoOperador["int>float"] = Tipo("bool");
    resultadoOperador["double>float"] = Tipo("bool");
    resultadoOperador["float>double"] = Tipo("bool");
    resultadoOperador["string>string"] = Tipo("bool");
    resultadoOperador["char>char"] = Tipo("bool");
    resultadoOperador["char>int"] = Tipo("bool");
    resultadoOperador["int>char"] = Tipo("bool");

    // <=
    resultadoOperador["int<=int"] = Tipo("bool");
    resultadoOperador["double<=double"] = Tipo("bool");
    resultadoOperador["float<=float"] = Tipo("bool");
    resultadoOperador["double<=int"] = Tipo("bool");
    resultadoOperador["int<=double"] = Tipo("bool");
    resultadoOperador["float<=int"] = Tipo("bool");
    resultadoOperador["int<=float"] = Tipo("bool");
    resultadoOperador["double<=float"] = Tipo("bool");
    resultadoOperador["float<=double"] = Tipo("bool");
    resultadoOperador["string<=string"] = Tipo("bool");
    resultadoOperador["char<=char"] = Tipo("bool");
    resultadoOperador["char<=int"] = Tipo("bool");
    resultadoOperador["int<=char"] = Tipo("bool");

    // >=
    resultadoOperador["int>=int"] = Tipo("bool");
    resultadoOperador["double>=double"] = Tipo("bool");
    resultadoOperador["float>=float"] = Tipo("bool");
    resultadoOperador["double>=int"] = Tipo("bool");
    resultadoOperador["int>=double"] = Tipo("bool");
    resultadoOperador["float>=int"] = Tipo("bool");
    resultadoOperador["int>=float"] = Tipo("bool");
    resultadoOperador["double>=float"] = Tipo("bool");
    resultadoOperador["float>=double"] = Tipo("bool");
    resultadoOperador["string>=string"] = Tipo("bool");
    resultadoOperador["char>=char"] = Tipo("bool");
    resultadoOperador["char>=int"] = Tipo("bool");
    resultadoOperador["int>=char"] = Tipo("bool");

    // ==
    resultadoOperador["int==int"] = Tipo("bool");
    resultadoOperador["double==double"] = Tipo("bool");
    resultadoOperador["float==float"] = Tipo("bool");
    resultadoOperador["double==int"] = Tipo("bool");
    resultadoOperador["int==double"] = Tipo("bool");
    resultadoOperador["float==int"] = Tipo("bool");
    resultadoOperador["int==float"] = Tipo("bool");
    resultadoOperador["double==float"] = Tipo("bool");
    resultadoOperador["float==double"] = Tipo("bool");
    resultadoOperador["string==string"] = Tipo("bool");
    resultadoOperador["char==char"] = Tipo("bool");
    resultadoOperador["char==int"] = Tipo("bool");
    resultadoOperador["int==char"] = Tipo("bool");

    // !=
    resultadoOperador["int!=int"] = Tipo("bool");
    resultadoOperador["double!=double"] = Tipo("bool");
    resultadoOperador["float!=float"] = Tipo("bool");
    resultadoOperador["double!=int"] = Tipo("bool");
    resultadoOperador["int!=double"] = Tipo("bool");
    resultadoOperador["float!=int"] = Tipo("bool");
    resultadoOperador["int!=float"] = Tipo("bool");
    resultadoOperador["double!=float"] = Tipo("bool");
    resultadoOperador["float!=double"] = Tipo("bool");
    resultadoOperador["string!=string"] = Tipo("bool");
    resultadoOperador["char!=char"] = Tipo("bool");
    resultadoOperador["char!=int"] = Tipo("bool");
    resultadoOperador["int!=char"] = Tipo("bool");

    // ||
    resultadoOperador["bool||bool"] = Tipo("bool");

    // &&
    resultadoOperador["bool&&bool"] = Tipo("bool");

    // !
    resultadoOperador["!bool"] = Tipo("bool");

    // %
    resultadoOperador["int%int"] = Tipo("int");
}

#include "lex.yy.c"

void yyerror( const char* st ){
    puts(st);
    printf("[%sERRO%s] Na linha: %d. Perto de: '%s'\n", COLOR_RED, COLOR_RESET, contadorLinha, yytext);
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
    return "#include " + bib + "\n";
}

string declararVariavel(string tipo_base, string vars, int bloco) {
    vector<string> vetorVars = split(vars, ',');

    string codigo = bloco ? TAB : "";
    if (tipo_base == C_STRING)
        codigo += string(C_CHAR) + " ";
    else if(tipo_base == C_BOOL)
        codigo += string(C_INT) + " ";
    else
        codigo += tipo_base + " ";

    TSV &tabela = tabelaVariaveis.back(); // Tabela do topo da pilha

    for (int i = 0; i < vetorVars.size(); i++) {
        if (i > 0) codigo += ", ";

        string nomeVar = vetorVars[i] + "_" + toStr(bloco);
        Tipo tipo_verificado = tipo_base;
        string nome_verificado = vetorVars[i];

        if (vetorVars[i].find("[") != string::npos) {          
            vector<string> dims = traduzDimensoesArray(vetorVars[i]);

            if (dims.size() > 3)
                erro("Array com dimensoes invalidas. (Max = 2 dimensoes)");

            // posições geradas pelo split => [ 0 => var_nome, 1 =>  dim1, 2 =>  dim2]
            if (dims.size() > 2){
                tipo_verificado.ndim = 2;
                tipo_verificado.t_dim[0] = atoi(dims[1].c_str());
                tipo_verificado.t_dim[1] = atoi(dims[2].c_str());
            }
            else {
                tipo_verificado.ndim = 1;
                tipo_verificado.t_dim[0] = atoi(dims[1].c_str());
            }
            nome_verificado = dims[0];
        }

        inserirVariavelTabela(tabela, tipo_verificado, nome_verificado, bloco);

        int qtd_elementos = 0;

        if (tipo_verificado.ndim == 1)
            qtd_elementos = tipo_verificado.t_dim[0];
        else if (tipo_verificado.ndim == 2)
            qtd_elementos = tipo_verificado.t_dim[0] * tipo_verificado.t_dim[1];

        if (tipo_base == C_STRING) {
            if (qtd_elementos > 0)
                qtd_elementos = qtd_elementos * MAX_STR;
            else
                qtd_elementos = MAX_STR;
        }

        if (qtd_elementos > 0)
            codigo = codigo + nome_verificado + "_" + toStr(bloco) + "[" + toStr(qtd_elementos) + "]";
        else
            codigo = codigo + nome_verificado + "_" + toStr(bloco);;
    }

    return codigo;
}

vector<string> traduzDimensoesArray(string aux) {
    replaceAll(aux, "[", ",");
    replaceAll(aux, "]", "");
    vector<string> dims = split(aux, ',');

    return dims;
}

string validarAcessoArray(string var, string dims) {
    string codigo = "";
    vector<string> dimsAcesso = traduzDimensoesArray(dims);

    Atributo variavel = buscaVariavel(var);

    if (dimsAcesso.size() > 0) {
        if (dimsAcesso.size()-1 != variavel.t.ndim) {
            erro("Acesso de indice invalido: A variavel " + var + " possui " + toStr(variavel.t.ndim) +
                " dimensoes. Você usou " + toStr(dimsAcesso.size()) + " dimensoes. Use a quantidade correta.");
        }

        for(int i = 1; i < dimsAcesso.size(); i++){
            if(atoi(dimsAcesso[i].c_str()) >= variavel.t.t_dim[i-1]
                || atoi(dimsAcesso[i].c_str()) < 0)
                erro("Indice fora dos limites. Tentou acessar posição " +  dimsAcesso[i] + " no total de " + toStr(variavel.t.t_dim[i-1]) +
                    "(de 0 a " + toStr(variavel.t.t_dim[i-1]-1) + ") na dimensao " + toStr(i-1));
        }

        if (variavel.t.ndim == 1) {
            codigo = "[" + dimsAcesso[1] + "]";
        }
        else {
            int posicao;
            posicao = variavel.t.t_dim[1]*atoi(dimsAcesso[1].c_str()) + atoi(dimsAcesso[2].c_str());
            codigo = "[" + toStr(posicao) + "]";
        }
    }
    else {
        if (variavel.t.ndim > 0)
            erro("Falta especificar indice do array: " + var);
    }

    // TODO verificar caso de array de strings
    return codigo;
}

void inserirVariavelTabela(TSV &tabela, Tipo tipo, string nome, int bloco){
    string nome_bloco = nome + "_" + toStr(bloco);
    if (!variavelDeclarada(tabela, nome)) 
        tabela[nome] = SimboloVariavel(nome_bloco, tipo, bloco);
    else
        erro("Variavel ja definida: " + nome + "\n");
}

bool variavelDeclarada(const TSV &tabela, string nome){
    return tabela.find(nome) != tabela.end();
}

Atributo buscaVariavel(string nome) {
    for (int i = tabelaVariaveis.size()-1; i >= 0; i--) {
        if (variavelDeclarada(tabelaVariaveis[i], nome)) {
            const SimboloVariavel &var = tabelaVariaveis[i][nome];
            return Atributo(var.nome, var.t);
        }
    }
    erro("Variavel nao declarada: " + nome);
    return Atributo();
}

void removerBlocoVars() {
    if (tabelaVariaveis.empty())
        return;
    tabelaVariaveis.pop_back();
}

void adicionarNovaTabelaVariaveis(){
    TSV tabela;
    tabelaVariaveis.push_back(tabela);
    id_bloco++;
}

vector<string> split(string s, char delim){
    vector<string> elems;
    stringstream ss(s);
    string item;
    while (getline(ss, item, delim))
        elems.push_back(item);
    return elems;
}

void replaceAll( string &s, const string &search, const string &replace ) {
    for( size_t pos = 0; ; pos += replace.length() ) {
        // Locate the substring to replace
        pos = s.find( search, pos );
        if( pos == string::npos ) break;
        // Replace by erasing and inserting
        s.erase( pos, search.length() );
        s.insert( pos, replace );
    }
}

Tipo tipoResultado(const Tipo &a, string op, const Tipo &b) {
    if (resultadoOperador.find(a.nome + op + b.nome) == resultadoOperador.end())
        erro("Operacao nao permitida: " + a.nome + op + b.nome);
    return resultadoOperador[a.nome + op + b.nome];
}

void resetVarsTemp() {
    n_var_temp.clear();
}

string geraCodigoVarsTemp() {
    // TODO verificar codigo depois de implementar string!
    char buf[1024];
    string cod;
    for (auto it = n_var_temp.begin(); it != n_var_temp.end(); it++) {
        for (int i = 0; i < it->second; i++) {
            string tp = it->first;
            if (tp == "bool")
                tp = "int";
            cod += TAB + tp + " temp_" + it->first + "_" + toStr(i) + ";\n";
        }
    }
    return cod;
}

string geraVarTemp(const Tipo &t) {
    return "temp_" + t.nome + "_" + toStr(n_var_temp[t.nome]++);
}

void adicionarVariaveisProcedimento(string codigo) {
    codigoVarsProcedimento = codigoVarsProcedimento + codigo;
}
void resetVariaveisProcedimento() {
    codigoVarsProcedimento = "";
}

void geraCodigoOperadorBinario(Atributo &SS, const Atributo &S1, const Atributo &S2, const Atributo &S3) {
    SS.t = tipoResultado(S1.t, S2.v, S3.t);

    if (S2.v == "=") {
        if (S1.t.nome == C_STRING && (S3.t.nome == C_STRING || S3.t.nome == C_CHAR)) {
            // TODO implementar atribuição para strings
            erro("Ver TODO implementar atribuicao para strings");
        }
        else {
            SS.v = S1.v;
            SS.c = S1.c + S3.c + 
                   TAB + S1.v + " = " + S3.v + ";\n";
        }
    }
    else {
        SS.v = geraVarTemp(SS.t);
        if (SS.t.nome == C_STRING) { //TODO falta string
        }
        else {
            SS.c = S1.c + S3.c +
                   TAB + SS.v + " = " + S1.v + " " + S2.v + " " + S3.v + ";\n";
        }
    }
}

string gerarCodigoPrint(Atributo &S){
  string codigo = string(TAB) + "printf";

  if(S.t.nome == C_INT)
    codigo += "(\"%d\", " + S.v + ");\n";
  else if(S.t.nome == C_CHAR)
    codigo += "(\"%c\", " + S.v + ");\n";
  else if(S.t.nome == C_FLOAT)
    codigo += "(\"%f\", " + S.v + ");\n";
  else if(S.t.nome == C_DOUBLE)
    codigo += "(\"%lf\", " + S.v + ");\n";
  else if(S.t.nome == C_STRING)
    codigo += "(\"%s\", " + S.v + ");\n";
  else if(S.t.nome == C_BOOL)
    codigo += "(\"%d\", " + S.v + ");\n";

  return codigo;
}

string gerarLabel() {
    return string("LABEL_") + toStr(id_label++);
}

string gerarCodigoIfElse(const Atributo &expr, const Atributo &cod_if, const Atributo &cod_else) {
    if (expr.t.nome != C_BOOL)
        erro("expressao nao booleana");
    string codigo = expr.c;
    string label_if = gerarLabel();
    string label_end = gerarLabel();
    codigo += TAB "if (" + expr.v + ") goto " + label_if + ";\n" +
              cod_else.c +
              TAB "goto " + label_end + ";\n" +
              label_if + ":\n" +
              cod_if.c +
              label_end + ":\n";
    return codigo;
}

int main (int argc, char *argv[]){
    inicializaResultadoOperador();
    yyparse();
}
