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
    Tipo(string nome) : nome(nome) {}
};

struct Atributo {
    string v; // Valor
    Tipo t;   // Tipo
    string c; // Código

    Atributo(){}
    Atributo(string v, string t = "", string c = "") : v(v), t(t), c(c) {}
    Atributo(string v, Tipo t, string c = "") : v(v), t(t), c(c) {}
};

struct SimboloVariavel{
    string nome;
    Tipo t;
    int bloco;

    SimboloVariavel(){}
    SimboloVariavel(string nome, string tipo, int bloco)
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

int id_bloco = 1;

typedef map<string, SimboloVariavel> TSV;
vector<TSV> tabelaVariaveis;

vector<string> split(string s, char delim);
string toStr(int n);

string gerarIncludeC(string bib);
string declararVariavel(string tipo, string vars, int bloco);
void inserirVariavelTabela(TSV &tabela, string tipo, string nome, int bloco);
bool variavelDeclarada(const TSV &tabela, string nome);
Atributo buscaVariavel(string nome);
void removerBlocoVars();

void inicializaResultadoOperador();
Tipo tipoResultado(const Tipo &a, string op, const Tipo &b);
void resetVarsTemp();
string geraCodigoVarsTemp();
string geraVarTemp(const Tipo &t);
void geraCodigoOperadorBinario(Atributo &SS, const Atributo &S1, const Atributo &S2, const Atributo &S3);

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
        << $5.c // funcoes
        << $6.c // main
        << $7.c // funcoes
        ;
      }
  ;

MAIN : TK_MAIN CORPO TK_TERMINA_MAIN
        {
            $$ = Atributo();
            $$.c = "\n"
                   "int main() {\n" +
                   geraCodigoVarsTemp() +
                   $2.c +
                   TAB "return 0;\n"
                   "}\n";
            resetVarsTemp();
            removerBlocoVars();
        }
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
                   $6.c +
                   "}\n";
            resetVarsTemp();
            removerBlocoVars();
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

VARS_GLOBAIS : VAR_GLOBAL VARS_GLOBAIS { $$ = Atributo();  $$.c = $1.c + $2.c; }
             | { $$ = Atributo(); }
             ;

VAR_GLOBAL : TK_DECLARAR_VAR LISTA_IDS TK_AS TIPO ';' { $$ = Atributo(); $$.c = declararVariavel($4.v, $2.c, 0) + ";\n"; }
           ;

LISTA_IDS : TK_ID ARRAY ',' LISTA_IDS { $$ = Atributo(); $$.c = $1.v + "," + $4.c; } // FALTA ARRAY
          | TK_ID ARRAY { $$ = Atributo(); $$.c = $1.v; }
          ;

ARRAY : '[' TK_CTE_INT ']' ARRAY
      | { $$ = Atributo(); }
      ;

BLOCO : TK_COMECA_BLOCO CORPO TK_TERMINA_BLOCO      { $$.c = $2.c; }
      | TK_COMECA_FUNCAO CORPO TK_TERMINA_FUNCAO    { $$.c = $2.c; }
      ;

CORPO : VARS_LOCAIS COMANDOS { $$.c = $1.c + $2.c; }
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
        | COMANDO_PRINT ';'
        | COMANDO_BREAK ';'
        | TK_COMECA_BLOCO CORPO TK_TERMINA_BLOCO
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
          | CHAMADA_FUNCAO
          | TERMINAL
            { $$ = $1; }
          ;

TERMINAL : TK_ID ARRAY
            { $$ = buscaVariavel($1.v); }
         | TK_CTE_INT
         | TK_CTE_DOUBLE
         | TK_CTE_FLOAT
         | TK_CTE_CHAR
         | TK_CTE_STRING
         | TK_CTE_BOOL_TRUE
         | TK_CTE_BOOL_FALSE
         | TK_NULL
         | '(' EXPRESSAO ')'
            { $$ = $2; }
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

COMANDO_PRINT : TK_PRINT '(' EXPRESSAO ')'
              ;

%%

int contadorLinha = 1;

map<string, Tipo> resultadoOperador;
map<string, int> n_var_temp;

void inicializaResultadoOperador() {
    // +
    resultadoOperador["int+int"] = Tipo("int");
    resultadoOperador["double+double"] = Tipo("double");
    resultadoOperador["float+float"] = Tipo("float");
    resultadoOperador["double+int"] = Tipo("double");
    resultadoOperador["int+double"] = Tipo("double");

    // -
    resultadoOperador["int-int"] = Tipo("int");
    resultadoOperador["double-double"] = Tipo("double");
    resultadoOperador["float-float"] = Tipo("float");
    resultadoOperador["double-int"] = Tipo("double");
    resultadoOperador["int-double"] = Tipo("double");

    // *
    resultadoOperador["int*int"] = Tipo("int");
    resultadoOperador["double*double"] = Tipo("double");
    resultadoOperador["float*float"] = Tipo("float");
    resultadoOperador["double*int"] = Tipo("double");
    resultadoOperador["int*double"] = Tipo("double");

    // /
    resultadoOperador["int/int"] = Tipo("int");
    resultadoOperador["double/double"] = Tipo("double");
    resultadoOperador["float/float"] = Tipo("float");
    resultadoOperador["double/int"] = Tipo("double");
    resultadoOperador["int/double"] = Tipo("double");

    // <
    resultadoOperador["int<int"] = Tipo("bool");
    resultadoOperador["double<double"] = Tipo("bool");
    resultadoOperador["float<float"] = Tipo("bool");
    resultadoOperador["double<int"] = Tipo("bool");
    resultadoOperador["int<double"] = Tipo("bool");

    // >
    resultadoOperador["int>int"] = Tipo("bool");
    resultadoOperador["double>double"] = Tipo("bool");
    resultadoOperador["float>float"] = Tipo("bool");
    resultadoOperador["double>int"] = Tipo("bool");
    resultadoOperador["int>double"] = Tipo("bool");

    // <=
    resultadoOperador["int<=int"] = Tipo("bool");
    resultadoOperador["double<=double"] = Tipo("bool");
    resultadoOperador["float<=float"] = Tipo("bool");
    resultadoOperador["double<=int"] = Tipo("bool");
    resultadoOperador["int<=double"] = Tipo("bool");

    // >=
    resultadoOperador["int>=int"] = Tipo("bool");
    resultadoOperador["double>=double"] = Tipo("bool");
    resultadoOperador["float>=float"] = Tipo("bool");
    resultadoOperador["double>=int"] = Tipo("bool");
    resultadoOperador["int>=double"] = Tipo("bool");

    // ==
    resultadoOperador["int==int"] = Tipo("bool");
    resultadoOperador["double==double"] = Tipo("bool");
    resultadoOperador["float==float"] = Tipo("bool");
    resultadoOperador["double==int"] = Tipo("bool");
    resultadoOperador["int==double"] = Tipo("bool");

    // !=
    resultadoOperador["int!=int"] = Tipo("bool");
    resultadoOperador["double!=double"] = Tipo("bool");
    resultadoOperador["float!=float"] = Tipo("bool");
    resultadoOperador["double!=int"] = Tipo("bool");
    resultadoOperador["int!=double"] = Tipo("bool");

    // ||
    resultadoOperador["bool||bool"] = Tipo("bool");

    // &&
    resultadoOperador["bool&&bool"] = Tipo("bool");
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

string declararVariavel(string tipo, string vars, int bloco) {
    vector<string> vetorVars = split(vars, ',');

    string codigo = bloco ? TAB : "";
    if (tipo == C_STRING)
        codigo += string(C_CHAR) + " ";
    else
        codigo += tipo + " ";

    TSV tabela;
    for (int i = 0; i < vetorVars.size(); i++) {
        if (i > 0) codigo += ", ";

        string nomeVar = vetorVars[i] + "_" + toStr(bloco);
        inserirVariavelTabela(tabela, tipo, vetorVars[i], bloco);

        if (tipo == C_STRING)
            codigo += nomeVar + "[" + toStr(MAX_STR) +"]";
        else
            codigo += nomeVar;
    }

    tabelaVariaveis.push_back(tabela);
    return codigo;
}

void inserirVariavelTabela(TSV &tabela, string tipo, string nome, int bloco){
    string nome_bloco = nome + "_" + toStr(bloco);
    if (!variavelDeclarada(tabela, nome_bloco))
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
    const TSV &bloco = tabelaVariaveis.back();
    auto it = bloco.begin();
    if (it != bloco.end() && it->second.bloco == id_bloco) {
        tabelaVariaveis.pop_back();
        id_bloco++;
    }
}

vector<string> split(string s, char delim){
    vector<string> elems;
    stringstream ss(s);
    string item;
    while (getline(ss, item, delim))
        elems.push_back(item);
    return elems;
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

void geraCodigoOperadorBinario(Atributo &SS, const Atributo &S1, const Atributo &S2, const Atributo &S3) {
    //SS.t = tipoResultado(S1.t, S2.v, S3.t);
    SS.t = Tipo("int");
    SS.v = geraVarTemp(SS.t);
    if (SS.t.nome == C_STRING) { //TODO falta string
    }
    else {
        SS.c = S1.c + S3.c +
               TAB + SS.v + " = " + S1.v + " " + S2.v + " " + S3.v + ";\n";
    }
}

int main (int argc, char *argv[]){
    inicializaResultadoOperador();
    yyparse();
}
