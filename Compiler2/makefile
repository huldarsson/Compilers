NanoMorphoLexer.class NanoMorphoParser.class NanoMorphoParserVal.class: NanoMorphoLexer.java NanoMorphoParser.java NanoMorphoParserVal.java
	javac NanoMorphoLexer.java NanoMorphoParser.java NanoMorphoParserVal.java
NanoMorphoLexer.java: nanoMorphoLexer.jflex
	java -jar jflex-full-1.7.0.jar nanoMorphoLexer.jflex

NanoMorphoParser.java NanoMorphoParserVal.java: nanomorpho.byaccj
	./byacc -Jclass=NanoMorphoParser nanomorpho.byaccj


clean:
	rm -rf *~ *.class *.java *.bak yacc.* 