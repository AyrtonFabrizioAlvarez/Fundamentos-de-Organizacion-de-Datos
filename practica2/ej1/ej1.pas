program ej1;

const
    valorAlto = 999;
Type
    empleado = record
        codigo:integer;
        nombre:String;
        monto:double;
    end;

    archivo = file of empleado;


procedure leer(var arch:archivo ; var dato:empleado);
begin
    if (not eof(arch)) then
        read(arch, dato)
    else
        dato.codigo:= valorAlto;
end;

procedure generarBinario(var arch:archivo ; var archFisico:String);
var
    E:empleado;
begin
    writeln('Ingrese el nombre que desea ponerle al .dat');
    readln(archFisico);
    assign(arch, archFisico);
    rewrite(arch);
    writeln('Ingrese el codigo del empleado');
    readln(E.codigo);
    while (E.codigo <> 0) do
    begin
        writeln('Ingrese el nombre del empleado');
        readln(E.nombre);
        writeln('Ingrese el monto de la comision');
        readln(E.monto);
        write(arch, E);
        writeln('Ingrese el codigo del empleado');
        readln(E.codigo);
    end;
    close(arch);
end;

procedure procesar (var arch:archivo ; var archNuevo:archivo);
var
    E:empleado;
    eNuevo:empleado;
begin
    leer(arch, E);
    while (E.codigo <> valorAlto) do
    begin
        eNuevo:= E;
        eNuevo.monto:= 0;
        while (eNuevo.codigo = E.codigo) do
        begin
            eNuevo.monto:= eNuevo.monto + E.monto;
            leer(arch, E);
        end;
        write(archNuevo, eNuevo);
    end;
end;

procedure mostrar(var arch:archivo);
var
    E:empleado;
begin
    while (not eof(arch)) do
    begin
        read(arch, E);
        writeln('codigo: ', E.codigo, ' nombre: ', E.nombre, ' monto: ', E.monto:2:2);
    end;
end;


VAR
    arch:archivo;
    archNuevo:archivo;
    archFisico:String;
BEGIN
    generarBinario(arch, archFisico);

    assign(arch, archFisico);           //asigno el archivo
    assign(archNuevo, 'archivoNuevo');  //asigno el archivoNuevo
    reset(arch);                        //me paro al comienzo del archivo
    rewrite(archNuevo);                 //creo el archivoNuevo
    procesar(arch, archNuevo);          //genero el nuevo archivo
    close(arch);                        //cierro el archivo
  

    reset(archNuevo);
    mostrar(archNuevo);
    close(archNuevo);
END.