program ej2;

const
    valorAlto = 999;
Type
    alumno = record
        codigo:integer;
        apellido:String;
        cursadaA:integer;
        finalA:integer;
        nombre:String;
    end;
    alumnoDet = record
        codigo:integer;
        cursadaA:integer;
        finalA:integer;
    end;
    archivoMaestro = file of alumno;
    archivoDetalle = file of alumnoDet; 

procedure mostrar(var maestro:archivoMaestro);
var
    A:alumno;
begin
    assign(maestro, 'maestro.dat');
    reset(maestro);
    while(not eof(maestro)) do
    begin
        read(maestro, A);
        writeln('codigo: ', A.codigo, ' apellido: ', A.apellido, ' cursadas: ', A.cursadaA, ' finales: ', A.finalA, ' nombre: ', A.nombre);
    end;
    close(maestro);
end;

procedure mostrarDetalle(var detalle:archivoDetalle);
var
    A:alumnoDet;
begin
    assign(detalle, 'detalle.dat');
    reset(detalle);
    while(not eof(detalle)) do
    begin
        read(detalle, A);
        writeln('codigo: ', A.codigo, ' cursadas: ', A.cursadaA, ' finales: ', A.finalA);
    end;
    close(detalle);
end;

procedure leer(var detalle:archivoDetalle ; var A:alumnoDet);
begin
    if (not eof(detalle)) then
        read(detalle, A)
    else
        A.codigo:= valorAlto;
end;

procedure menu (var opcion:char);
begin
    writeln('---------------');
    writeln('1: actualizar maestro');
    writeln('2: generar .txt con alumnos que tienen mas de 4 materias con cursada aprobada');
    writeln('pulse cualquier otra tecla para salir');
    writeln('---------------');
    readln(opcion);
end;

procedure generarMaestroDesdeTxt(var maestro:archivoMaestro);
var
    A:alumno;
    txt:text;
begin
    assign(txt, 'maestro.txt');
    assign(maestro, 'maestro.dat');
    reset(txt);
    rewrite(maestro);
    while (not eof(txt)) do
    begin
        readln(txt, A.codigo, A.apellido);
        readln(txt, A.cursadaA, A.finalA, A.nombre);
        write(maestro, A);
    end;
    close(maestro);
    close(txt);
end;

procedure generarDetalleDesdeTxt(var detalle:archivoDetalle);
var
    A:alumnoDet;
    txt:Text;
begin
    assign(txt, 'detalle.txt');
    assign(detalle, 'detalle.dat');
    reset(txt);
    rewrite(detalle);
    while (not eof(txt)) do
    begin
        readln(txt, A.codigo, A.cursadaA, A.finalA);
        write(detalle, A);
    end;
    close(detalle);
    close(txt);
end;

procedure actualizarMaestro(var maestro:archivoMaestro ; var detalle:archivoDetalle);
var
    aMaestro:alumno;
    aDetalle:alumnoDet;
begin
    assign(maestro, 'maestro.dat');
    assign(detalle, 'detalle.dat');
    reset(maestro);
    reset(detalle);
    leer(detalle, aDetalle);
    while(aDetalle.codigo <> valorAlto) do
    begin
        read(maestro, aMaestro);
        while (aMaestro.codigo <> aDetalle.codigo) do
            read(maestro, aMaestro);
        while (aMaestro.codigo = aDetalle.codigo) do
        begin
            if (aDetalle.cursadaA = 1) then
                aMaestro.cursadaA:= aMaestro.cursadaA + 1;
            if (aDetalle.finalA = 1) then
                aMaestro.finalA:= aMaestro.finalA + 1;
            leer(detalle, aDetalle);
        end;
        seek(maestro, filepos(maestro)-1);
        write(maestro, aMaestro);
    end;
    close(maestro);
    close(detalle);
end;

procedure generarTxt(var maestro:archivoMaestro);
var
    A:alumno;
    txt:Text;
begin
    assign(maestro, 'maestro.dat');
    assign(txt, 'alumnosConMasDe4Cursadas.txt');
    reset(maestro);
    rewrite(txt);
    while(not eof(maestro)) do
    begin
        read(maestro, A);
        if (A.cursadaA > 4) then
            writeln(txt, A.codigo, ' ', A.apellido, ' ', A.cursadaA, ' ', A.finalA, ' ', A.nombre);
    end;
    close(maestro);
    close(txt);
end;

var
    maestro:archivoMaestro;
    detalle:archivoDetalle;
    opcion:char;
begin
    generarMaestroDesdeTxt(maestro);
    mostrar(maestro);
    generarDetalleDesdeTxt(detalle);
    mostrarDetalle(detalle);

    menu(opcion);
    case opcion of
        '1':begin
                actualizarMaestro(maestro, detalle);
                mostrar(maestro);
            end;
        '2':begin
                generarTxt(maestro);
            end;
        else
            opcion:= 'z';
    end;
end.