// Einfaldur form�lut�lkur
// H�fundur: Snorri Agnarsson

// Forrit �etta m� ���a me� Java ���andanum me� eftirfarandi
// skipunarl�nu:
//       javac Formula.java
//
// s��an m� keyra forriti� svona:
//       java Formula <seg�>
// e�a
//       java Formula '<seg�>'
// t.d.:
//       java Formula (1+2)*3
// e�a
//       java Formula '(1+2)*3'

// M�ll�sing � EBNF sni�i:
//   F = L, { "+", L } ;
//   L = T, { "*", T } ;
//   T = tala | "(", F, ")" ;
// � BNF sni�i:
//   <F> ::= <L> <Fm>
//   <Fm> ::= + <L> <Fm>
//   <Fm> ::= e
//   <L> ::= <T> <Lm>
//   <Lm> ::= * <T> <Lm>
//   <Lm> ::= e
//   <T> ::= ( <F> )
//   <T> ::= tala
// �ar sem e stendur fyrir t�ma strenginn og tala er fleytit�lulesfasti.

public class Formula
{

 static class Scanner
 {
  private String nextToken;
  private double nextNumber;
  private java.io.StreamTokenizer tokenizer;

  public String getNextToken()
  {
   return nextToken;
  }

  public double getNextNumber()
  {
   return nextNumber;
  }

  public Scanner( java.io.Reader r )
  {
   tokenizer = new java.io.StreamTokenizer(r);
   tokenizer.ordinaryChars(0,255);
   tokenizer.parseNumbers();
   tokenizer.ordinaryChar('-');
   advance();
  }
 
  public void advance()
  {
   try
   {
    int type = tokenizer.nextToken();
    if( type==java.io.StreamTokenizer.TT_NUMBER )
    {
     nextToken = "number";
     nextNumber = tokenizer.nval;
    }
    else if( type==java.io.StreamTokenizer.TT_EOF )
    {
     nextToken = "eof";
    }
    else
    {
     nextToken = ""+(char)type;
    }
    }
   catch( Exception e )
   {
    throw new Error(e);
   }
  }
 }

 static double F( Scanner s )
 {
  double x=L(s);
  while( s.getNextToken().equals("+") || s.getNextToken().equals("-") )
  {
    if(s.getNextToken().equals("+")){
      s.advance();
      x = x+L(s);
    } else if (s.getNextToken().equals("-")){
      s.advance();
      x = x-L(s);
    }
  }
  return x;
 }

 static double L( Scanner s )
 {
  double x=T(s);
  while( s.getNextToken().equals("*") || s.getNextToken().equals("/"))
  {
    if(s.getNextToken().equals("*")){
      s.advance();
      x = x*T(s);
    } else if(s.getNextToken().equals("/")){
      s.advance();
      x = x / T(s);
    }
  }
  return x;
 }

 static double T(Scanner s){
   double x = P(s);
   while(s.getNextToken().equals("^")){
     s.advance();
     x = Math.pow(x, T(s));
   }
   return x;
 }

 static double P( Scanner s )
 {
  if( s.getNextToken().equals("(") )
  {
   s.advance();
   double x = F(s);
   if( !s.getNextToken().equals(")") )
   {
    throw new Error("expected ), found "+s.nextToken);
   }
   s.advance();
   return x;
  }
  else if( s.getNextToken().equals("number") )
  {
   double x = s.getNextNumber();
   s.advance();
   return x;
  }
  else if (s.getNextToken().equals("-")){
    s.advance();
    double x = -P(s);
    return x;
  }
  else
  {
   throw new Error("expected ( or number, found "+s.nextToken);
  }
 }

 public static void main( String[] args )
  throws Exception
 {
  String arg = "";
  for( int i=0 ; i!=args.length ; i++ )
   arg += args[i];
  Scanner s = new Scanner(new java.io.StringReader(arg));
  try
  {
   double x = F(s);
   if( !s.nextToken.equals("eof") )
    throw new Error("expected eof or operation");
   System.out.println(x);
  }
  catch( Throwable e )
  {
   System.out.println("Error: "+e.getMessage()+", Next token: "+s.nextToken);
  }
 }
}