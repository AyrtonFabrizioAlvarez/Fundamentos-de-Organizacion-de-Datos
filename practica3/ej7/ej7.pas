{7. Realice un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program ej7;

Type

    ave = record
        codigo:integer;
        nombre:String;
        familia:String;
        descripcion:String;
        zona:String;
    end;

    archivo = file of ave;

procedure generarMaestro(var mae:archivo);

    procedure leer(var A:ave);
    begin
        writeln('Ingrese el codigo del ave');
        readln(A.codigo);
        if (A.codigo <> 0) then
        begin
            writeln('Ingrese el nombre del ave');
            readln(A.nombre);
            writeln('Ingrese la familia del ave');
            readln(A.familia);
            writeln('Ingrese la descripcion del ave');
            readln(A.descripcion);
            writeln('Ingrese la zona geografica del ave');
            readln(A.zona);
        end;
    end;

var
    A:ave;
begin
    assign(mae, 'maestro.bin');
    rewrite(mae);
    leer(A);
    while(A.codigo <> 0) do
    begin
        write(mae, A);
        leer(A);
    end;
end;

procedure mostrarMaestro(var mae:archivo);
var
    A:ave;
begin
    reset(mae);
    while (not eof(mae)) do
    begin
        read(mae, A);
        writeln('Codigo: ', A.codigo, ' Nombre: ', A.nombre);
    end;
    close(mae);
end;


procedure eliminar(var mae:archivo);

    procedure buscarYeliminar(var mae:archivo ; buscado:integer ; var pude:boolean);
    var
        A:ave;
        posEliminado:integer;
    begin
        reset(mae);
        while ( (not eof(mae)) and (not pude) ) do
        begin
            read(mae, A);                                         
            if (A.codigo = buscado) then
            begin
                A.codigo:= A.codigo * -1;           //MARCO EL CODIGO COMO NEGATIVO
                posEliminado:= filePos(mae)-1;      //ME GUARDO LA POSICION
                seek(mae, posEliminado);            //VUELVO A LA POSICION
                write(mae, A);                      //ESCRIBO EL DATO YA MARCADO (NEGATIVO)
                pude:= true;                        //DEVUELVO UN TRUE PARA MARCAR EXITOSA LA ELIMINACION
            end;
        end;
        close(mae);
    end;

var
    buscado:integer;
    pude:boolean;
begin
    writeln('Ingrese el codigo del ave que desea eliminar');
    readln(buscado);
    while(buscado <> 0) do
    begin
        pude:= false;
        buscarYeliminar(mae, buscado, pude);
        if (pude) then
            writeln('La eliminacion del codigo ', buscado, ' fue exitosa')
        else
            writeln('No se encontro el codigo ', buscado);
        writeln('Ingrese el codigo del ave que desea eliminar');
        readln(buscado);
    end;
end;


procedure compactarMaestro(var mae:archivo);
var
    A:ave;
    posEliminado:integer;
begin
    reset(mae);
    while(not eof (mae)) do
    begin
        read(mae, A);
        if (A.codigo < 0) then
        begin
            posEliminado:= FilePos(mae)-1;
            seek(mae, fileSize(mae)-1);
            read(mae, A);
            seek(mae, posEliminado);
            write(mae, A);
            seek(mae, fileSize(mae)-1);
            Truncate(mae);
            seek(mae, posEliminado+1);
        end;
    end;
    close(mae);
end;

VAR
    mae:archivo;
BEGIN
    generarMaestro(mae);
    mostrarMaestro(mae);
    writeln('');

    eliminar(mae);
    mostrarMaestro(mae);
    writeln('');

    compactarMaestro(mae);
    mostrarMaestro(mae);
END.