program ej18;

const
    valorAlto = 'zzz';

Type
    {Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
    diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene:
    cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
    nombre_hospital, fecha y cantidad de casos positivos detectados.}
    informe = record
        codLocalidad:integer;
        nomLocalidad:String;
        codMunicipio:integer;
        nomMunicipio:String;
        codHospital:integer;
        nomHospital:String;
        fecha:integer;
        positivos:integer;
    end;

    maestro = file of informe;

procedure leer(var arch:maestro ; var dato:informe);
begin
    if(not eof(arch))then
        read(arch, dato)
    else
        dato.nomLocalidad:= valorAlto;    
end;

procedure exportar(var txt:text ; municipio, localidad:String ; positivos:integer);
begin
    if (positivos > 1500) then
    begin
        writeln(txt, positivos, ' ', municipio);
        writeln(txt, localidad);
    end;
end;

VAR
    mae:maestro;
    regM:informe;
    localidadActual, municipioActual, hospitalActual:String;
    totProv, totLoc, totMun, totHosp:integer;
    txt:text;
BEGIN
    assign(mae, 'maestro.bin');
    reset(mae);
    assign(txt, 'reporte.txt');
    rewrite(txt);
    totProv:= 0;
    leer(mae, regM);
    while(regM.nomLocalidad <> valorAlto) do
    begin
        localidadActual:= regM.nomLocalidad;
        totLoc:= 0;
        writeln(localidadActual);
        while(localidadActual = regM.nomLocalidad) do
        begin
            municipioActual:= regM.nomMunicipio;
            totMun:= 0;
            writeln(municipioActual);
            while( (localidadActual = regM.nomLocalidad) and (municipioActual = regM.nomMunicipio))do
            begin
                hospitalActual:= regM.nomHospital;
                totHosp:= 0;
                while( (localidadActual = regM.nomLocalidad) and (municipioActual = regM.nomMunicipio)
                and (hospitalActual= regM.nomHospital) ) do
                begin
                    totHosp:= totHosp + regM.positivos;
                    leer(mae, regM);
                end;
                writeln(hospitalActual);
                writeln('Cantidad de casos hospital ', totHosp);
                totMun:= totMun + totHosp;
            end;
            writeln('Cantidad de casos Municipio ', totMun);
            exportar(txt, municipioActual, localidadActual, totMun);
            totLoc:= totLoc + totMun;
        end;
        writeln('Cantidad de casos Localidad ', totLoc);
        totProv:= totProv + totLoc;
    end;
    writeln('Cantidad de casos Provincia ', totProv);
    close(mae);
    close(txt);
END.

{18 . 
El archivo está ordenado por localidad, luego por municipio y luego por hospital.
a. Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga
un listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
NombreHospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia
b. Exportar a un archivo de texto la siguiente información nombre_localidad,
nombre_municipio y cantidad de casos de municipio, para aquellos municipios cuya
cantidad de casos supere los 1500. El formato del archivo de texto deberá ser el
adecuado para recuperar la información con la menor cantidad de lecturas posibles.
NOTA: El archivo debe recorrerse solo una vez.}