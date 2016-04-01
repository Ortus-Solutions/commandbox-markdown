/**
* Copyright 2013 Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* @author Luis Majano
* Convert markdown to HTML via the MarkdownJ Java library
*/
component accessors="true" singleton{

	/**
	* MarkdownJ processor
	*/
	property name="processor";
	
	// Static lib path
	LIB_PATH = "lib/markdownj-core-0.4.jar";

	/**
	* Constructor
	*/
	function init(){
		// Setup markdown processor
		variables.processor = createObject( "java", "org.markdownj.MarkdownProcessor", LIB_PATH  ).init();
		return this;
	}

	/**
	* Convert markdown to HTML
	* @txt The markdown text to convert
	*/
	function toHTML( required txt ){
		return trim( variables.processor.markdown( trim( arguments.txt ) ) );
	}
	
}