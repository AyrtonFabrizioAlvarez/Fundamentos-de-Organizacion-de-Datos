program ej2;

const
    valorAlto = 999;

TYPE
    asistente = record
        numero:integer;
        apellido:String;
        nombre:String;
        email:String;
        tel:integer;
        dni:integer;
    end;

    archivo = file of asistente;

procedure generarArchivo(var arch:Archivo);

    procedure leerAsistente(var A:asistente);
    begin
        writeln('Ingrese el numero de asistente');
        readln(A.numero);
        if (A.numero <> 0) then
        begin
            writeln('Ingrese el apellido del asistente');
            readln(A.apellido);
            writeln('Ingrese el nombre del asistente');
            readln(A.nombre);
            writeln('Ingrese el email del asistente');
            readln(A.email);
            //writeln('Ingrese el telefono del asistente');
            A.tel:= random(9999);
            //writeln('Ingrese el DNI del asistente');
            A.dni:= random(1000);
        end;
    end;

var
    A:asistente;
begin
    assign(arch, 'maestro.bin');
    rewrite(arch);
    leerAsistente(A);
    while (A.numero <> 0) do
    begin
        write(arch, A);
        leerAsistente(A);
    end;
    close(arch);
end;

procedure eliminarNumerosMenores1000(var arch:archivo);
var
    A:asistente;
begin
    reset(arch);
    read(arch, A);
    while(not eof(arch)) do
    begin
        if (A.numero < 1000) then
        begin
            A.nombre:= '@' + A.nombre;
            seek(arch, filePos(arch)-1);
            write(arch, A);
        end;
        read(arch, A);
    end;
    close(arch);
end;

procedure mostrarArchivo(var arch:Archivo);
var
    A:asistente;
begin
    reset(arch);
    while (not eof(arch)) do
    begin
        read(arch, A);
        writeln('--------------------');
        writeln('Numero: ', A.numero, ' Nombre: ', A.nombre);
    end;
    close(arch);
end;

VAR
    mae:archivo;
BEGIN
    generarArchivo(mae);
    mostrarArchivo(mae);
    writeln('');
    eliminarNumerosMenores1000(mae);
    mostrarArchivo(mae);
END.