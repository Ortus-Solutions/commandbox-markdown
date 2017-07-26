/**
* Copyright 2013 Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* @author Luis Majano
* Convert markdown to HTML
*/
component accessors="true" singleton{

	/**
	* MarkdownJ processor
	*/
	property name="processor";
	
	// Static lib path
	LIB_PATHS = directoryList( 
		getDirectoryFromPath( getMetadata( this ).path ) & "lib",
		false,
		"path"
	);

	/**
	* Constructor
	*/
	function init(){
		//systemOutput( LIB_PATHS );
		// store references
		variables.staticParser = createObject( "java", "com.vladsch.flexmark.parser.Parser", LIB_PATHS );
		
		var parserOptions = createOptions( {} );
		variables.parser = staticParser.builder( parserOptions ).build();
		variables.renderer = createObject( "java", "com.vladsch.flexmark.html.HtmlRenderer", LIB_PATHS )
			.builder( parserOptions )
			.build();
		return this;
	}

	/**
	* Convert markdown to HTML
	* @txt The markdown text to convert
	*/
	function toHTML( required txt ){
		var document = variables.parser.parse( trim( arguments.txt ) );
		return trim( variables.renderer.render( document ) );
	}

	/**
	* Create a parser options object for the FlexMark parser.
	*
	* @options A struct of options for the parser.
	*
	* @return  A parser options object.
	*/
	private function createOptions( required struct options ) {
		structAppend( arguments.options, defaultOptions() );

		var staticTableExtension = createObject( "java", "com.vladsch.flexmark.ext.tables.TablesExtension", LIB_PATHS );
		return createObject( "java", "com.vladsch.flexmark.util.options.MutableDataSet", LIB_PATHS )
			.init()
			.set(
				staticTableExtension.COLUMN_SPANS,
				javacast( "boolean", arguments.options.tableOptions.columnSpans )
			)
        	.set(
        		staticTableExtension.APPEND_MISSING_COLUMNS,
        		javacast( "boolean", arguments.options.tableOptions.appendMissingColumns )
        	)
        	.set(
        		staticTableExtension.DISCARD_EXTRA_COLUMNS,
        		javacast( "boolean", arguments.options.tableOptions.discardExtraColumns )
        	)
        	.set(
        		staticTableExtension.CLASS_NAME,
        		arguments.options.tableOptions.className
        	)
        	.set(
        		staticTableExtension.HEADER_SEPARATOR_COLUMN_MATCH,
        		javacast( "boolean", arguments.options.tableOptions.headerSeparationColumnMatch )
        	)
        	.set(
        		variables.staticParser.EXTENSIONS,
        		[ staticTableExtension.create() ]
        	);
	}

	/**
	* Return the default parser options to merge with the user's options.
	*
	* @return The default parser options struct.
	*/
	private struct function defaultOptions() {
		return {
			tableOptions = {
				// Treat consecutive pipes at the end of a column as defining spanning column.
				columnSpans = true,
				// Whether table body columns should be at least the number or header columns.
				appendMissingColumns = true,
				// Whether to discard body columns that are beyond what is defined in the header
				discardExtraColumns = true,
				// Class name to use on tables
				className = "table",
				// When true only tables whose header lines contain the same number of columns as the separator line will be recognized
				headerSeparationColumnMatch = true
			}
		};
	}
	
}