component {
    property name="command" inject="commandService";
    property name="print" inject="printBuffer";

    function scan(){

    }

    function parseEnv(){
        var env = command("dotenv show").run(returnOutput=true)
        var envArray = env.listToArray(chr(10));
        print.line(envArray[1]);
    }
}