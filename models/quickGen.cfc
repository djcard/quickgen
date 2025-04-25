component {
    property name="qb" inject="provider:QueryBuilder@qb";
    property name="support" inject="support@schemaCompare"; 
    
    function obtainTables(dbname="CNEAssessment"){
        cfdbinfo(name="allTables",datasource="cne",dbname=dbname,type="tables");
        return allTables;
    }

    function obtainFields( required string tableName, required string datasource, required string dbname ){
        cfdbinfo(name="allfields",datasource=arguments.datasource,type="column",dbname=dbname,table=arguments.tableName);
        return allFields;
    }


    function generateProperties(fieldQ){
        var retme=[];
        for(var x in fieldQ){
            retme.append(generatePropertyString(x.COLUMN_NAME));
        }
        return retme;
    }

    function generatePropertyString(name,type){
        return 'property name="#arguments.name#";';
    }

    function isolatePrimaryKeys( data ){
        var retme = [];
        data.each((item)=>{
            if(item.IS_PRIMARYKEY=="YES"){
                retme.append(item.COLUMN_NAME)
            }
        });
        return retme;
    }

    function generateOne(tableName,datasource,dbname, outputPath){
        var columns = obtainFields(tablename, datasource, dbname);
        var keys = isolatePrimaryKeys( columns );
        var props = generateProperties(columns);
        var memento = generateMemento(columns)
       writeEntity(tableName & ".cfc",entityTemplate(tablename, props, keys, memento), outputPath);
    }

    function generateMemento( data ){
        var retme = [];
        data.each((item)=>{
            retme.append('"#item.COLUMN_NAME#"')
        });

        return retme;
    }

    

    function entityTemplate(required string tablename, required array props=[], required array primarykeys=[], memento=[],hint=""){
        var retme = ['component table="#tablename#" extends="quick.models.BaseEntity" accessors="true" {'];
        if(props.len()){
            retme.append(arguments.props.tolist(""),true);
        }
        if(arguments.primarykeys.len()){
            retme.append("");
            retme.append("#chr(9)#variables._key = #serializeJson(primarykeys)#")
        }
        if(memento.len()){
            retme.append("");
            retme.append('#chr(9)#this.memento={defaultIncludes:[#memento.tolist(',')#]}')
        }
        retme.append("}")
        return retme.tolist(chr(10))
    }

    function writeEntity(fileName,contents,directory=expandpath('/')){
        support.allDirectoriesMade(directory);
        filewrite(arguments.directory & "/" & fileName, contents);
    }

    function allTables(dbname, datasource){
        cfdbinfo(datasource=datasource name="allTables" dbname=dbname type="tables");
        return allTables
    }

    function createAllTableEntities( required string dbname, string datasource, string schema="dbo"){
        var retme = {success=false,entities:[]};
        var allT = allTables(dbname, datasource);

        allT.each((item)=>{
            if(item["TABLE_SCHEM"] == schema){
                generateOne(item["TABLE_NAME"]);
                retme.entities.append(item["TABLE_NAME"]);
            }
        });

        retme.success=true;
        return retme;

    }
}