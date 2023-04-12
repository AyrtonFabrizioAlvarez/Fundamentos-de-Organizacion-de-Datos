program ej11;

const
    valorAlto = 'zzz';

Type
    {A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
    archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
    alfabetizadas y total de encuestados.}
    provincia = record
        nombre:String;
        alfabetizados:integer;
        encuestados:integer;
    end;
    
    maestro = file of provincia;

    {Se reciben dos archivos detalle provenientes de dos
    agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
    localidad, cantidad de alfabetizados y cantidad de encuestados.}
    censo = record
        nombre:String;
        codLocalidad:integer;
        alfabetizados:integer;
        encuestados:integer;
    end;

    detalle = file of censo;

    
procedure generarMaeDet(var mae:maestro ; var d1, d2:detalle);
var
    regMae:provincia;
    regDet:censo;
    txtMae, txtDet1, txtDet2:text;
begin
    assign(mae, 'maestro.bin');
    assign(d1, 'detalle1.bin');
    assign(d2, 'detalle2.bin');
    assign(txtMae, 'maestro.txt');
    assign(txtDet1, 'detalle1.txt');
    assign(txtDet2, 'detalle2.txt');
    reset(txtMae);reset(txtDet1);reset(txtDet2);
    rewrite(mae);rewrite(d1);rewrite(d2);
    while (not eof(txtMae)) do
    begin
        with regMae do
        begin
            readln(txtMae, nombre);
            readln(txtMae, alfabetizados, encuestados);
            write(mae, regMae);
        end;
    end;
    while (not eof(txtDet1)) do
    begin
        with regDet do
        begin
            readln(txtDet1, nombre);
            readln(txtDet1, codLocalidad, alfabetizados, encuestados);
            write(d1, regDet);
        end;
    end;
    while (not eof(txtDet1)) do
    begin
        with regDet do
        begin
            readln(txtDet1, nombre);
            readln(txtDet1, codLocalidad, alfabetizados, encuestados);
            write(d1, regDet);
        end;
    end;
    while (not eof(txtDet2)) do
    begin
        with regDet do
        begin
            readln(txtDet2, nombre);
            readln(txtDet2, codLocalidad, alfabetizados, encuestados);
            write(d2, regDet);
        end;
    end;
    close(mae);
    close(d1);
    close(d2);
end;

{Se pide realizar los módulos
    necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
    NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
    pueden venir 0, 1 ó más registros por cada provincia}

procedure leer(var arch:detalle ; var dato:censo);
begin
    if (not eof(arch)) then
        read(arch, dato)
    else
        dato.nombre:= valorAlto;
end;

procedure minimo(var d1, d2:detalle ; var regD1, regD2, min:censo);
begin
    if (regD1.nombre < regD2.nombre) or ( (regD1.nombre = regD2.nombre) and (regD1.codLocalidad < regD2.codLocalidad))then
    begin
        min:=regD1;
        leer(d1, regD1)
    end
    else
    begin
        min:= regD2;
        leer(d2, regD2);
    end;
end;

procedure mostrarMaestro(var mae:maestro);
var
    regMae:provincia;
begin
    reset(mae);
    while(not eof(mae))do
    begin
        read(mae, regMae);
        writeln('Nombre: ', regMae.nombre, ' alfabetizados: ', regMae.alfabetizados, ' encuestados: ', regMae.encuestados);
    end;
    close(mae);
end;

VAR
    mae:maestro;
    d1, d2:detalle;
    regD1, regD2, min:censo;
    regMae:provincia;
BEGIN
    generarMaeDet(mae, d1, d2);
    mostrarMaestro(mae);
    writeln('');
    reset(mae);reset(d1);reset(d2);
    leer(d1, regD1);leer(d1, regD2);
    minimo(d1, d2, regD1, regD2, min);
    while(min.nombre <> valorAlto) do
    begin
        read(mae, regMae);
        while(regMae.nombre <> min.nombre) do
            read(mae, regMae);
        while(regMae.nombre = min.nombre)do
        begin
            regMae.alfabetizados:= regMae.alfabetizados + min.alfabetizados;
            regMae.encuestados:= regMae.encuestados + min.encuestados;
            minimo(d1, d2, regD1, regD2, min);
        end;
        seek(mae, filePos(mae)-1);
        write(mae, regMae);
    end;
    close(mae);close(d1);close(d2);
    mostrarMaestro(mae);
END.

{11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia}