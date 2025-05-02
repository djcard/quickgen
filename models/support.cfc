component {

    function mapDBTypetoQBGrammar(type) {
        var types = {
            'mssql': 'SQLServerGrammar@qb',
            'mySql': 'MySQLGrammar@qb',
            'oracle': 'OracleGrammar@qb',
            'postgres': 'PostgresGrammar@qb',
            'sqlite': 'SQLiteGrammar@qb'
        };
        return types.keyExists(arguments.type) ? types[type] : '';
    }

    public function allDirectoriesMade(outputPath){
        try {
            //var newdirectorypath = replace(filename, #replace(arguments.destination,'\','\\','all')#, '');
            var testpathArr = outputPath.listtoarray('\/');
            arrayDeleteAt(testpathArr, arraylen(testpathArr));
            var testPath = #replace(arguments.outputPath,'\','\\','all')#;
            for (var x = 1; x <= arraylen(testpathArr); x = x + 1) {
                testPath = listappend(testPath, testpathArr[x], '\\');
                if (!directoryExists(testPath)) {
                    directoryCreate(testPath);
                }
            }
            return true;
        }
        catch(any err){
            return false;
        }
    }
}