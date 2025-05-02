component accessors="true" {

    property name="quickGen" inject="quickGen@quickGen";
    property name="common" inject="common@quickgen";
    property name="systemSettings" inject="systemSettings";
    property name="allDatasources";

    /***
     * Generates a simple Quick entity based on the submitted table name and datasource
     *
     * @datasource The datasource to use. Can be configured in `configure datasource`
     * @datasource.optionsUDF obtainDataSources
     * @tableName The name of the table to be the basis of the new entity
     *
     * */
    function run(
        required string datasource,
        required string tableName,
        required string dbname,
        outputPath = getCwd() & 'models/entities'
    ) {
        arguments.datasource = arguments.datasource.listFirst("(");
        var allDS = common.appSettings().datasources;
        if(!allDS.keyExists(arguments.datasource)){
            obtainDataSources();
            var chosenDS = getallDatasources().filter((item)=>{
                return item.name==datasource;
            });
            if(chosenDS.len()){
                allDS[variables.systemSettings.expandDeepSystemSettings(chosenDS[1].name)]=variables.systemSettings.expandDeepSystemSettings(chosenDS[1].dsource);
                application action='update' datasources=allDS;
            }
        }
        print.line('Generating entity from #arguments.tableName# using the #arguments.datasource#').toConsole();
        quickGen.generateOne(
            arguments.tableName,
            arguments.dataSource,
            arguments.dbname,
            arguments.outputPath
        );
    }

    function obtainDataSources(boolean cfconfig = 1, boolean commandbox = 1, boolean cfmigrations = 1) {
        var allDsources = [];
        if (Arguments.commandBox) {
            if (common.appSettings().keyExists('datasources')) {
                common
                    .appSettings()
                    .datasources
                    .each((item) => {
                        allDsources.append({name: item, source: 'commandBox'})
                    })
            } else {
            }
        }
        if (arguments.cfconfig) {
            if (fileExists(getcwd() & '.cfconfig.json')) {
                var configData = fileRead(getcwd() & '.cfconfig.json');
                var configData = deserializeJSON(configData);
                if (configData.keyExists('datasources')) {
                    configData.datasources.each((item) => {
                        var cleanedName = item;
                        if (item.find('${')) {
                            cleanedName = variables.systemSettings.expandDeepSystemSettings(item);
                            var cleaned = variables.systemSettings.expandDeepSystemSettings(
                                configData.datasources[item]
                            );
                        } 
                        allDsources.append({name: '#cleanedName#', dsource:configData.datasources[item], source: 'cfConfig'})
                    })
                }
            }
        }

        if (arguments.cfmigrations) {
            if (fileExists(getcwd() & '.cfmigrations.json')) {
                var configData = fileRead(getcwd() & '.cfmigrations.json');
                var configData = deserializeJSON(configData);
                configData.each((item) => {
                    if (
                        configData[item].keyExists('properties') && configData[item].properties.keyExists('connectionInfo')
                    ) {
                        allDsources.append({name: item, dsource:configData[item].properties.connectionInfo,source: 'migrations'})
                    }
                })
            }
        }
        setAllDataSources(allDsources);
        return allDsources.map((item)=>{
            return item.name & "( #item.source# )";
        });
    }

}
