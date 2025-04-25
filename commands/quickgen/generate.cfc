component{
    property name="quickGen" inject="quickGen@quickGen";

    /***
     * Generates a simple Quick entity based on the submitted table name and datasource
     * 
     * @datasource The datasource to use. Can be configured in `configure datasource`
     * @tableName The name of the table to be the basis of the new entity
     * 
     * */
    function run(required string datasource, required string tableName, string dbname, outputPath = getCwd() & "models/entities" ){
        print.line("Generating entity from #arguments.tableName# using the #arguments.datasource#").toConsole();
        quickGen.generateOne(arguments.tableName, arguments.dataSource, arguments.dbname, arguments.outputPath);
    }
}