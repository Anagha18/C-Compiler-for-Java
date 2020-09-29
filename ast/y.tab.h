/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    airth = 258,
    assig = 259,
    library = 260,
    UOP = 261,
    UOM = 262,
    assigP = 263,
    assigM = 264,
    assigMu = 265,
    assigD = 266,
    dataType = 267,
    IF = 268,
    FOR = 269,
    ELSE = 270,
    WHILE = 271,
    INCLUDE = 272,
    MAIN = 273,
    FO = 274,
    FC = 275,
    BO = 276,
    BC = 277,
    SeCo = 278,
    prin = 279,
    com = 280,
    plus = 281,
    mult = 282,
    minus = 283,
    divide = 284,
    mod = 285,
    brak = 286,
    s_ = 287,
    f_ = 288,
    d_ = 289,
    SOP = 290,
    CLASS = 291,
    integer = 292,
    id = 293,
    comp = 294,
    string = 295,
    logical = 296,
    flot = 297
  };
#endif
/* Tokens.  */
#define airth 258
#define assig 259
#define library 260
#define UOP 261
#define UOM 262
#define assigP 263
#define assigM 264
#define assigMu 265
#define assigD 266
#define dataType 267
#define IF 268
#define FOR 269
#define ELSE 270
#define WHILE 271
#define INCLUDE 272
#define MAIN 273
#define FO 274
#define FC 275
#define BO 276
#define BC 277
#define SeCo 278
#define prin 279
#define com 280
#define plus 281
#define mult 282
#define minus 283
#define divide 284
#define mod 285
#define brak 286
#define s_ 287
#define f_ 288
#define d_ 289
#define SOP 290
#define CLASS 291
#define integer 292
#define id 293
#define comp 294
#define string 295
#define logical 296
#define flot 297

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 36 "parser.y" /* yacc.c:1909  */

	      float floot;
              char *text;
	      struct rtrn{int val;float flt;struct node* nd;}rtrn;

#line 144 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
