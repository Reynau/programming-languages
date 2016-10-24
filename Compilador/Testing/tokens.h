#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: example1.g
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * ANTLR Version 1.33MR33
 */
#define zzEOF_TOKEN 1
#define NUM 2
#define PLUS 3
#define MINUS 4
#define TIMES 5
#define SPACE 6

#ifdef __USE_PROTOS
void expr(AST**_root);
#else
extern void expr();
#endif

#ifdef __USE_PROTOS
void minus(AST**_root);
#else
extern void minus();
#endif

#ifdef __USE_PROTOS
void times(AST**_root);
#else
extern void times();
#endif

#endif
extern SetWordType setwd1[];
