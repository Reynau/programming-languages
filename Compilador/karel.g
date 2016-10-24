#header
<<
#include <string>
#include <iostream>
#include <map>
#include <vector>
#include <tuple>
using namespace std;

// struct to store information about tokens
typedef struct {
  string kind;
  string text;
} Attrib;

typedef std::tuple<int,int,int> i3tuple;

// function to fill token information (predeclaration)
void zzcr_attr(Attrib *attr, int type, char *text);

// fields for AST nodes
#define AST_FIELDS string kind; string text;
#include "ast.h"

// macro to create a new AST node (and function predeclaration)
#define zzcr_ast(as,attr,ttype,textt) as=createASTnode(attr,ttype,textt)
AST* createASTnode(Attrib* attr,int ttype, char *textt);
>>

<<
#include <cstdlib>
#include <cmath>

//global structures: AST, and domini
AST *root;
enum torient {DLEFT,DRIGHT,DUP,DDOWN};
struct {
  int gx,gy;                                    // dimensions del mon
  int posx,posy;                                 // posicio actual robot
  torient orient;                               // orientacio actual robot
  int nsens;                                    // nombre de sensors que te el robot
  vector<i3tuple>  walls, beepers;   
}domini;

// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
  if (type == ID) {
    attr->kind = "id";
    attr->text = text;
  }
  else {
    attr->kind = text;
    attr->text = "";
  }
}

// function to create a new AST node
AST* createASTnode(Attrib* attr, int type, char* text) {
  AST* as = new AST;
  as->kind = attr->kind; 
  as->text = attr->text;
  as->right = NULL; 
  as->down = NULL;
  return as;
}


/// create a new "list" AST node with one element
AST* createASTlist(AST *child) {
 AST *as=new AST;
 as->kind="list";
 as->right=NULL;
 as->down=child;
 return as;
}

AST *findDefinition(string id) {
  AST *n = root->down->right->right->down;
  while (n != NULL and (n->down->text != id)) n = n->right;
  if (n == NULL) {cout << "NOT FOUND: " << id << " " << endl;}
  return n->down->right;
}

/// get nth child of a tree. Count starts at 0.
/// if no such child, returns NULL
AST* child(AST *a,int n) {
AST *c=a->down;
for (int i=0; c!=NULL && i<n; i++) c=c->right;
return c;
}



/// print AST, recursively, with indentation
void ASTPrintIndent(AST *a,string s)
{
  if (a==NULL) return;

  cout<<a->kind;
  if (a->text!="") cout<<"("<<a->text<<")";
  cout<<endl;

  AST *i = a->down;
  while (i!=NULL && i->right!=NULL) {
    cout<<s+"  \\__";
    ASTPrintIndent(i,s+"  |"+string(i->kind.size()+i->text.size(),' '));
    i=i->right;
  }
  
  if (i!=NULL) {
      cout<<s+"  \\__";
      ASTPrintIndent(i,s+"   "+string(i->kind.size()+i->text.size(),' '));
      i=i->right;
  }
}

/// print AST 
void ASTPrint(AST *a)
{
  while (a!=NULL) {
    cout<<" ";
    ASTPrintIndent(a,"");
    a=a->right;
  }
}

bool foundBeeper(int x, int y){
  for(int i = 0; i < domini.beepers.size(); ++i){
    if(get<0>(domini.beepers[i]) == x and get<1>(domini.beepers[i]) == y) return true;
  }
  return false;
}


bool dinsDominis(int x, int y) {
  return (x <= domini.gx and y <= domini.gy and 0 <= x and 0 <= y);
}

bool hihaparet(int x, int y, int orient){ 
  for(int i = 0; i < domini.walls.size(); ++i){
    if(get<0>(domini.walls[i]) == x and get<1>(domini.walls[i]) == y and get<2>(domini.walls[i]) == orient ) {
      return false;
    }
  }

  return true;
}


bool isClear(int x, int y, int orient) {
  if(orient == 0) return (dinsDominis(x,y-1) and hihaparet(x,y-1,1) and hihaparet(x,y,0));
  if(orient == 1) return (dinsDominis(x,y+1) and hihaparet(x,y+1,0) and hihaparet(x,y,1));
  if(orient == 2) return (dinsDominis(x-1,y) and hihaparet(x-1,y,3) and hihaparet(x,y,2));
  if(orient == 3) return (dinsDominis(x+1,y) and hihaparet(x+1,y,2) and hihaparet(x,y,3));
  
}

bool avaluaCondicio(AST *a) {
  if (a->kind == "not") return not(avaluaCondicio(child(a,0)));
  else if (a->kind == "and") return avaluaCondicio(child(a,0)) and avaluaCondicio(child(a,1));
  else if (a->kind == "or") return avaluaCondicio(child(a,0)) or avaluaCondicio(child(a,1));
  // ompliu el codi que falta aqui
  else if(a->kind == "isClear") return isClear(domini.posx, domini.posy, domini.orient);
  else if(a->kind == "anyBeepersInBag") return (domini.nsens > 0);
  else if(a->kind == "foundBeeper") {
    //cout << 22 <<endl;

    return foundBeeper(domini.posx, domini.posy);
  }
}




void omplirWalls(AST *a){
  a = a->down;
  while(a != NULL) {
    int t1, t2, t3;
    t1 = atoi(a->kind.c_str());
    t2 = atoi(a->right->kind.c_str());
    string s = a->right->right->kind;
    if(s == "left") t3 = 0;
    else if(s == "right") t3 = 1;
    else if(s == "up") t3 = 2;
    else if(s == "down") t3 = 3;
    domini.walls.push_back(i3tuple(t1,t2,t3));
    a = a->right->right->right;
  }
}

void omplirBeepers(AST *a){
  a = a->down;
  int t1, t2, t3;
  t1 = atoi(a->kind.c_str());
  t2 = atoi(a->right->kind.c_str());
  t3 = atoi(a->right->right->kind.c_str());
  domini.beepers.push_back(i3tuple(t1,t2,t3));
} 

void omplirDomini() { 
   domini.gx = atoi(root->down->down->kind.c_str());
   domini.gy = atoi(root->down->down->right->kind.c_str());
   domini.posx = atoi(root->down->right->down->kind.c_str());
   domini.posy = atoi(root->down->right->down->right->kind.c_str()); 
   // ompliu el codi que falta aqui  
   domini.nsens = atoi(root->down->right->down->right->right->kind.c_str());
   string rob_ori = root->down->right->down->right->right->right->kind.c_str();
   if (rob_ori == "right") domini.orient = DRIGHT;
   else if(rob_ori == "left") domini.orient = DLEFT;
   else if(rob_ori == "up") domini.orient = DUP;
   else if(rob_ori == "down") domini.orient = DDOWN;


   /* WALLS BEEPERS */
   
   AST *aux = root->down->right->right->down;
   while(aux != NULL){
    if(aux->kind == "walls") omplirWalls(aux);
    else if(aux->kind == "beepers") omplirBeepers(aux);
    aux = aux->right;
   }
}

void prog(AST *a, bool on){
  if(on and (a != NULL)) {
    if(a->kind == "move") {
      if(isClear(domini.posx, domini.posy, domini.orient)) {
        if(domini.orient == 0) domini.posy -= 1;
        else if(domini.orient == 1) domini.posy += 1;
        else if(domini.orient == 2) domini.posx -=1;
        else domini.posx += 1;
      }
    }
    else if(a->kind == "pickbeeper"){
      for(int i = 0; i < domini.beepers.size(); ++i){
        if(domini.posx == get<0>(domini.beepers[i]) and domini.posy == get<1>(domini.beepers[i])){
          domini.nsens++;
          if(get<2>(domini.beepers[i]) == 1) domini.beepers.erase(domini.beepers.begin()+i);
          else get<2>(domini.beepers[i]) -= 1;
        }
      }
    }
    else if(a->kind == "putbeeper"){
      bool entra = false;
      //cout << 22 <<endl;

      if(domini.nsens != 0){
        for(int i = 0; i < domini.beepers.size(); ++i){
          if(domini.posx == get<0>(domini.beepers[i]) and domini.posy == get<1>(domini.beepers[i])){
            get<2>(domini.beepers[i]) += 1;
            domini.nsens -= 1;
            entra = true;
          }
        }
        if(not entra) {
          domini.beepers.push_back(i3tuple(domini.posx,domini.posy,1));
          domini.nsens -= 1;
        }
      }
    }
    else if(a->kind == "turnoff") on = false;
    else if(a->kind == "turnleft") {
      if(domini.orient == 0) domini.orient = DDOWN;
      else if(domini.orient == 1) domini.orient = DUP;
      else if(domini.orient == 2) domini.orient = DLEFT;
      else if(domini.orient == 3) domini.orient = DRIGHT;
    }
    else if(a->kind == "id"){
      AST *aux = findDefinition(a->text);
      prog(aux->down,on);
    }
    else if(a->kind == "iterate"){
      int it = atoi(a->down->kind.c_str());
      for(int i = 0; i < it; ++i) prog(a->down->right->down,on);
    }
    else if(a->kind == "if"){
      if (avaluaCondicio(a->down)) prog(a->down->right->down,on);
    }
    prog(a->right, on);
  }


}

void novaPosicio () {
  omplirDomini();
  // ompliu el codi que falta aqui 

  AST *a = root->down->right->right->right->down;
  bool on = true;
  prog(a, on);
    
}

int main() {
  root = NULL;
  ANTLR(karel(&root), stdin);
  ASTPrint(root);
  novaPosicio(); 

  cout << "POSICIO FINAL ROBOT: (" << domini.posx << ", " << domini.posy << ")" << endl;
  cout << "BEEPERS IN BAG: " << domini.nsens << endl;
  for(int i = 0; i < domini.beepers.size(); ++i) {
    cout << "Beepers: (" << get<0>(domini.beepers[i]) << ", " << get<1>(domini.beepers[i]) << ") SENSORS: " << get<2>(domini.beepers[i]) << endl;
  }
}
>>


#lexclass START
#token WORLD "world"
#token ROBOT "robot"

#token WALLS "walls"
#token BEEPERS "beepers"

#token RIGHT "right"
#token LEFT "left"
#token UP "up"
#token DOWN "down"


#token DEFINE "define"

#token TL "turnleft"

#token ISCLEAR "isClear"
#token ABIB "anyBeepersInBag"
#token MOVE "move"
#token PUTBEEPER "putbeeper"
#token FOUNDBEEPER "foundBeeper"
#token PICKBEEPER "pickbeeper"



#token BEGIN "begin"
#token ITERATE "iterate"
#token IF "if"
#token AND "and"
#token OR "or"
#token NOT "not"

#token TURNOFF "turnoff"
#token END "end"


#token CI "\["
#token CD "\]"
#token COMA "\,"
#token LLI "\{"
#token LLD "\}"
#token PC "\;"
#token NUM "[0-9]+"
#token ID "[a-zA-Z0-9]+"
#token SPACE "[\ \n]" << zzskip();>>



karel: dworld drobot definitions BEGIN! linstr END! <<#0=createASTlist(_sibling);>>;

/* INICIALITZACIO */


dworld: WORLD^ NUM NUM ;

deforientacio: RIGHT|LEFT|DOWN|UP;

drobot: ROBOT^ NUM NUM NUM deforientacio;


/* WALLS BEEPERS AND DEFINES */


definitions:  (defs)*  defdefinies <<#0=createASTlist(_sibling);>>;

defs: defwalls|defbeepers;


/* WALLS */

inwalls: NUM NUM deforientacio ;

defwalls: WALLS^ CI! (inwalls (COMA! |) )* CD! ;

/* BEEPERS */

defbeepers: BEEPERS^ NUM NUM NUM ;

/* DEFINES */


defdefinies: (define_1)* ;

define_1: DEFINE^ ID (define_cuerpo) ;

define_cuerpo: LLI! (cuerpo)* LLD! <<#0=createASTlist(_sibling);>>;

cuerpo:  ITERATE^ NUM LLI! (def_iterate) LLD! | cuerpo_general | IF^ (impl_if) LLI! (if_cuerpo) LLD! ;

cuerpo_general: MOVE PC! | PUTBEEPER PC! | PICKBEEPER PC! | TL PC! | ID PC! | TURNOFF PC! ;

/* GESTIO DELS IFS  */ 

impl_if:  if_type (AND^ if_type| OR^ if_type)* ;

if_type:  (NOT^|) (ISCLEAR|ABIB|FOUNDBEEPER);

if_cuerpo: (cuerpo)*  <<#0=createASTlist(_sibling);>>; 

/* ITERATE */


linstr: (cuerpo)* <<#0=createASTlist(_sibling);>>; 


def_iterate: (cuerpo)* <<#0=createASTlist(_sibling);>>; 


