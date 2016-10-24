#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: bpmn.g
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * ANTLR Version 1.33MR33
 */
#define zzEOF_TOKEN 1
#define STARTP 2
#define ENDP 3
#define CONN 4
#define FILECONN 5
#define CRIT 6
#define DIFFER 7
#define CORRECTF 8
#define FILEREAD 9
#define FILEWRITE 10
#define OPENP 11
#define CLOSEP 12
#define QUERIES 13
#define GPAR 14
#define GOR 15
#define GXOR 16
#define SEQ 17
#define ID 18
#define SPACE 19

#ifdef __USE_PROTOS
void bpmn(AST**_root);
#else
extern void bpmn();
#endif

#ifdef __USE_PROTOS
void process(AST**_root);
#else
extern void process();
#endif

#ifdef __USE_PROTOS
void conn(AST**_root);
#else
extern void conn();
#endif

#ifdef __USE_PROTOS
void file(AST**_root);
#else
extern void file();
#endif

#ifdef __USE_PROTOS
void file_aux(AST**_root);
#else
extern void file_aux();
#endif

#ifdef __USE_PROTOS
void rols(AST**_root);
#else
extern void rols();
#endif

#ifdef __USE_PROTOS
void prior1(AST**_root);
#else
extern void prior1();
#endif

#ifdef __USE_PROTOS
void prior2(AST**_root);
#else
extern void prior2();
#endif

#ifdef __USE_PROTOS
void prior3(AST**_root);
#else
extern void prior3();
#endif

#ifdef __USE_PROTOS
void prior4(AST**_root);
#else
extern void prior4();
#endif

#ifdef __USE_PROTOS
void prior5(AST**_root);
#else
extern void prior5();
#endif

#ifdef __USE_PROTOS
void queries(AST**_root);
#else
extern void queries();
#endif

#ifdef __USE_PROTOS
void crit(AST**_root);
#else
extern void crit();
#endif

#ifdef __USE_PROTOS
void diff(AST**_root);
#else
extern void diff();
#endif

#ifdef __USE_PROTOS
void correct(AST**_root);
#else
extern void correct();
#endif

#endif
extern SetWordType zzerr1[];
extern SetWordType setwd1[];
extern SetWordType zzerr2[];
extern SetWordType setwd2[];
extern SetWordType setwd3[];
