/**
 * Convert Markdown to HTML.  You can pass either direct strings to be converted or a file location
 * .
 * {code:bash}
 * // Direct input
 * markdown "* markdown text"
 * // From File
 * markdown file=test.md
 * // Output to a file
 * markdown file=test.md fileOut=file.html
 * {code}
 *
 **/	
component extends="commandbox.system.BaseCommand" aliases="md" excludeFromHelp=false {

	property name="processor" inject="processor@commandbox-markdown";

	/**
	 * @txt The Markdown to convert to HTML
	 * @file A markdown file to convert to HTML
	 * @fileOut The destination file to write out the converted HTML
	 **/
	function run( string txt, file, fileOut ) {
		var html = "";

		// Text conversion
		if( structKeyExists( arguments, "txt" ) ){
			html = processor.toHTML( arguments.txt );
		}
		// File Conversion
		else if( structKeyExists( arguments, "file" ) ){
			// Resolve Path
			arguments.file = fileSystemUtil.resolvePath( arguments.file );
			// Check it
			if( !fileExists( arguments.file ) ){
				return error( "File: #arguments.file# does not exist!" );
			}
			// Convert it
			html = processor.toHTML( fileRead( arguments.file ) );
		}

		// Print it out
		print.line( html );

		// File out?
		if( structKeyExists( arguments, "fileOut" ) ){
			// Resolve Path
			arguments.fileOut = fileSystemUtil.resolvePath( arguments.fileOut );
			fileWrite( arguments.fileOut, html );
		}	
	}
	
}
