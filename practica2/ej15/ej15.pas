program ej15;

const
    dimF = 10;
    valorAlto = 999;

Type
    {15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
    carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
    como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
    de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
    agua,# viviendas sin sanitarios.}
    provincia = record
        codProvincia:integer;
        nombreProvincia:String;
        codLocalidad:integer;
        nombreLocalidad:String;
        sinLuz:integer;
        sinGas:integer;
        deChapa:integer;
        sinAgua:integer;
        sinSanitario:integer;
    end;

    maestro = file of provincia;

    {Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
    de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
    de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
    construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.}
    reporte = record
        codProvincia:integer;
        codLocalidad:integer;
        conLuz:integer;
        construidas:integer;
        conAgua:integer;
        conGas:integer;
        conSanitario:integer;
    end;

    detalle = file of reporte;

    vDetalle = array [1..dimF] of detalle;
    vRegistro = array [1..dimF] of reporte;

procedure generarBinarios(var mae:maestro ; var vDet:vDetalle);
var
    regMae:provincia;
    regDet:reporte;
    txtMae, txtDet:text;
    i:integer;
    iString:String;
begin
    assign(mae, 'maestro.bin');
    assign(txtMae, 'maestro.txt');
    reset(txtMae);
    rewrite(mae);
    while(not eof(txtMae))do
    begin
        with regMae do
        begin
            readln(txtMae, codProvincia, nombreProvincia);
            readln(txtMae, codLocalidad, nombreLocalidad);
            readln(txtMae, sinLuz, sinGas, deChapa, sinAgua, sinSanitario);
            write(mae, regMae);
        end;
    end;
    close(mae);
    for i:=1 to dimF do
    begin
        Str(i, iString);
        assign(txtDet, 'detalle'+iString+'.txt');
        assign(vDet[i], 'detalle'+iString+'.bin');
        reset(txtDet);
        rewrite(vDet[i]);
        while(not eof(txtDet))do
        begin
            with regDet do
            begin
                readln(txtDet, codProvincia, codLocalidad, conLuz, construidas, conAgua, conGas, conSanitario);
                write(vDet[i], regDet);
            end;
        end;
        close(txtDet);
        close(vDet[i]);
    end;
end;

procedure leer(var arch:detalle ; var dato:reporte);
begin
    if(not eof(arch)) then
        read(arch, dato)
    else
        dato.codProvincia:= valorAlto
end;



procedure procesar(var mae:maestro ; var vDet:vDetalle ; var vReg:vRegistro);

    procedure minimo(var vDet:vDetalle ; var vReg:vRegistro ; var min:reporte);
    var
        i, pos:integer;
    begin
        min.codProvincia:= valorAlto;
        for i:=1 to dimF do
        begin
            if (vReg[i].codProvincia < min.codProvincia) or
            ( (vReg[i].codProvincia = min.codProvincia) and (vReg[i].codLocalidad < min.codLocalidad) ) then
            begin
                min:= vReg[i];
                pos:= i;
            end;
        end;
        if (min.codProvincia <> valorAlto) then
            leer(vDet[pos], vReg[pos])
    end;

    procedure listarSiCumple(dato:provincia ; var contador:integer);
    begin
        if(dato.deChapa <= 0) then
        begin
            writeln('Provincia: ', dato.codProvincia, ' Localidad: ', dato.codLocalidad, ' deChapa: ', dato.deChapa);
            contador:= contador + 1;
        end;
    end;

var
    i, contador:integer;
    regMae:provincia;
    min:reporte;
begin
    contador:= 0;
    reset(mae);
    for i:=1 to dimF do
    begin
        reset(vDet[i]);
        leer(vDet[i], vReg[i]);
    end;
    minimo(vDet, vReg, min);
    while(not eof(mae))do
    begin
        read(mae, regMae);
        while(not eof(mae)) and ( (regMae.codProvincia <> min.codProvincia) or (regMae.codLocalidad <> min.codLocalidad) )do
        begin
            listarSiCumple(regMae, contador);
            read(mae, regMae);
        end;
        while(regMae.codProvincia = min.codProvincia) and (regMae.codLocalidad = min.codLocalidad)do
        begin
            regMae.sinLuz:= regMae.sinLuz - min.conLuz;
            regMae.sinGas:= regMae.sinGas - min.conGas;
            regmae.dechapa:= regMae.deChapa - min.construidas;
            regMae.sinAgua:= regMae.sinAgua - min.conAgua;
            regMae.sinSanitario:= regMae.sinSanitario - min.conSanitario;
            minimo(vDet, vReg, min);
        end;
        listarSiCumple(regMae, contador);
        if(min.codProvincia <> valorAlto) then
        begin
            seek(mae, filePos(mae)-1);
            write(mae, regMae);
        end;
    end;
    writeln('La cantidad de localidades sin casas con techo de chapa son: ', contador);
end;

VAR
    mae:maestro;
    vDet:vDetalle;
    vReg:vRegistro;
BEGIN
    writeln(1);
    generarBinarios(mae, vDet);
    writeln(2);
    procesar(mae, vDet, vReg);
    writeln(3);
END.
{15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua,# viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización se debe proceder de la siguiente manera:
1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
2. Idem para viviendas con agua, gas y entrega de sanitarios.
3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}