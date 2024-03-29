package Parse;
import ErrorMsg.ErrorMsg;

%% 

%implements Lexer
%function nextToken
%type java_cup.runtime.Symbol
%char

%{
StringBuffer string = new StringBuffer();
int count;
int string2;
private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
  errorMsg.error(pos,s);
}

private void err(String s) {
  err(yychar,s);
}

private java_cup.runtime.Symbol tok(int kind) {
    return tok(kind, null);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {
    return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

private ErrorMsg errorMsg;

Yylex(java.io.InputStream s, ErrorMsg e) {
  this(s);
  errorMsg=e;
}

%}

%eofval{
	{
	 return tok(sym.EOF, null);
        }
%eofval}       


%state COMMENT
%state STRING 
%state STRINGIGNORE
%%
" "	{}
\t {}
\f {}
(\n|\r\n|\r)	{newline();}

<YYINITIAL> "while" {return tok(sym.WHILE, null);}
<YYINITIAL> "for" {return tok(sym.FOR, null);}
<YYINITIAL> "to" {return tok(sym.TO, null);}
<YYINITIAL> "break" {return tok(sym.BREAK, null);}
<YYINITIAL> "let" {return tok(sym.LET, null);}
<YYINITIAL> "in" {return tok(sym.IN, null);}
<YYINITIAL> "end" {return tok(sym.END, null);}
<YYINITIAL> "function" {return tok(sym.FUNCTION, null);}
<YYINITIAL> "var" {return tok(sym.VAR, null);}
<YYINITIAL> "type" {return tok(sym.TYPE, null);}
<YYINITIAL> "array" {return tok(sym.ARRAY, null);}
<YYINITIAL> "if" {return tok(sym.IF, null);}
<YYINITIAL> "then" {return tok(sym.THEN, null);}
<YYINITIAL> "else" {return tok(sym.ELSE, null);}
<YYINITIAL> "do" {return tok(sym.DO, null);}
<YYINITIAL> "of" {return tok(sym.OF, null);}
<YYINITIAL> "nil" {return tok(sym.NIL, null);}

<YYINITIAL> "," {return tok(sym.COMMA, null);}
<YYINITIAL> ":" {return tok(sym.COLON, null);}
<YYINITIAL> ";" {return tok(sym.SEMICOLON, null);}
<YYINITIAL> "(" {return tok(sym.LPAREN, null);}
<YYINITIAL> ")" {return tok(sym.RPAREN, null);}
<YYINITIAL> "[" {return tok(sym.LBRACK, null);}
<YYINITIAL> "]" {return tok(sym.RBRACK, null);}
<YYINITIAL> "{" {return tok(sym.LBRACE, null);}
<YYINITIAL> "}" {return tok(sym.RBRACE, null);}
<YYINITIAL> "." {return tok(sym.DOT, null);}
<YYINITIAL> "+" {return tok(sym.PLUS, null);}
<YYINITIAL> "-" {return tok(sym.MINUS, null);}
<YYINITIAL> "*" {return tok(sym.TIMES, null);}
<YYINITIAL> "/" {return tok(sym.DIVIDE, null);}
<YYINITIAL> "=" {return tok(sym.EQ, null);}
<YYINITIAL> "<>" {return tok(sym.NEQ, null);}
<YYINITIAL> "<" {return tok(sym.LT, null);}
<YYINITIAL> "<=" {return tok(sym.LE, null);}
<YYINITIAL> ">" {return tok(sym.GT, null);}
<YYINITIAL> ">=" {return tok(sym.GE, null);}
<YYINITIAL> "&" {return tok(sym.AND, null);}
<YYINITIAL> "|" {return tok(sym.OR, null);}
<YYINITIAL> ":=" {return tok(sym.ASSIGN, null);}

<YYINITIAL> "/*" { count = 1; yybegin(COMMENT);}
<YYINITIAL> "*/" {err("Comment symbol don't match!");}

<YYINITIAL>[a-zA-Z][a-zA-Z0-9_]* {return tok(sym.ID, yytext());}


<COMMENT> "/*"  { {count++;}  }
<COMMENT>"*/" {if (--count == 0) {yybegin(YYINITIAL); }}
<COMMENT> \n   {}


<YYINITIAL> "\"" {string.setLength(0);yybegin(STRING);}

<YYINITIAL>[0-9]+	{return tok(sym.INT, new Integer(yytext()));}


<STRING>\\[0-9][0-9][0-9] {int tmp = Integer.parseInt(yytext()); if (tmp > 255) {err(" \\ddd");} else string.append((char)tmp);}
<STRING>"\"" {yybegin(YYINITIAL); string2--; return tok(sym.STRING, string.toString());}
<STRING>. {string.append(yytext());}
<STRING>\\n {string.append("\n");}
<STRING>\\t {string.append("\t");}
<STRING>"\\\"" {string.append("\"");}
<STRING>\\\\ {string.append("\\");}
<STRING> [^\n\t\"\\]+ {string.append(yytext());}

<STRING>\\ { yybegin(STRINGIGNORE);}
<STRINGIGNORE>[\n\r\f] {string2++;}

<STRINGIGNORE>\\t {}
<STRINGIGNORE>\\n {}
<STRINGIGNORE>\\r {}
<STRINGIGNORE>"\\\"" {}
<STRINGIGNORE>\\\\ {}
<STRINGIGNORE> . {}
<STRINGIGNORE>\\[0-9][0-9][0-9] {}
<STRINGIGNORE>"\"" {string2 = 0;}
<STRINGIGNORE> [^\n\t\"\\]+ {}



