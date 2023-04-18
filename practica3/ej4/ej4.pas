program Ej4Ej5;


Type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;

    tArchFlores = file of reg_flor;

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
    nuevo, aux:reg_flor;
    posEliminado:integer;
begin
    reset(a);
    nuevo.nombre:= nombre;
    nuevo.codigo:= codigo;
    read(a, aux);
    if (aux.codigo = 0) then
    begin
        seek(a, fileSize(a));
        write(a, nuevo);
    end
    else
    begin
        posEliminado:= aux.codigo * -1; //ENCUENTRO EL INDICE
        seek(a, posEliminado);          //VUELVO A POSICIONARME DONDE ESTABA EL ELEMENTO A ELIMINAR
        read(a, aux);                   //ME GUARDO EL REGISTRO DEL ELEMENTO A ELIMINAR
        seek(a, posEliminado);          //VUELVO A LA POSICION DEL ELEMENTO A ELIMINAR
        write(a, nuevo);                //DEJO MI NUEVO REGISTRO(ALTA) EN LA POSICION QUE ESTABA "ELIMINADA"
        seek(a, 0);                     //VUELVO EL PUNTERO AL COMIENZO DEL ARCHIVO
        write(a, aux);                  {ESCRIBO EN LA CABECERA LOS DATOS QUE OBTUVE DEL REGISTRO QUE
                                        ESTABA ORIGINALMENTE DONDE SE REALIZO LA BAJA PARA DE ESA MANERA SABER
                                        SI HABIA OTRAS POSICIONES LOGICAMENTE ELIMINADAS}
    end;
    close(a);
end;

procedure hacerBaja(var arch:tArchFlores);
var
    buscado, posEliminado:integer;
    elimine:boolean;
    cabecera, F:reg_flor;
begin
    reset(arch);
    elimine:= false;
    writeln('Ingrese el codigo de Flor que desea eliminar');
    readln(buscado);
    while (not eof(arch)) and (not elimine) do
    begin
        read(arch, F);
        if (F.codigo = buscado) then
        begin
            posEliminado:= filePos(arch)-1;     //POS TIENE EL INDICE DEL ELEMENTO A ELIMINAR
            seek(arch, 0);                      //EL PUNTERO ESTA AL PRINCIPIO DLE ARCHIVO
            read(arch, cabecera);               //OBTENGO LA CABECERA
            seek(arch, posEliminado);           //PUNTERO ESTA NUEVAMENTE EN LA POSICION A ELIMINAR
            write(arch, cabecera);              //ESCRIBO LO QUE TENIA EN LA CABECERA EN LA POSICION ELIMINADA
            seek(arch, 0);
            cabecera.codigo:= posEliminado*-1;
            write(arch, cabecera);
            elimine:= true;
        end;
    end;
    close(arch);
end;

procedure hacerBaja2(var arch:tArchFlores ; flor:reg_flor);
var
    posEliminado:integer;
    elimine:boolean;
    cabecera, F:reg_flor;
begin
    reset(arch);
    elimine:= false;
    while (not eof(arch)) and (not elimine) do
    begin
        read(arch, F);
        if (F.codigo = flor.codigo) then
        begin
            posEliminado:= filePos(arch)-1;     //POS TIENE EL INDICE DEL ELEMENTO A ELIMINAR
            seek(arch, 0);                      //EL PUNTERO ESTA AL PRINCIPIO DLE ARCHIVO
            read(arch, cabecera);               //OBTENGO LA CABECERA
            seek(arch, posEliminado);           //PUNTERO ESTA NUEVAMENTE EN LA POSICION A ELIMINAR
            write(arch, cabecera);              //ESCRIBO LO QUE TENIA EN LA CABECERA EN LA POSICION ELIMINADA
            seek(arch, 0);
            cabecera.codigo:= posEliminado*-1;
            write(arch, cabecera);
            elimine:= true;
        end;
    end;
    close(arch);
end;

procedure generarArchivo(var arch:tArchFlores);

    procedure leerFlor(var F:reg_flor);
    begin
        writeln('Ingrese el nombre de la flor');
        readln(F.nombre);
        if (F.nombre <> 'zzz') then
        begin
            writeln('Ingrese el codigo de la Flor');
            readln(F.codigo);
        end;
    end;

var
    F:reg_flor;
begin
    assign(arch, 'archivo.bin');
    rewrite(arch);
    F.nombre:= 'cabecera';
    F.codigo:= 0;
    write(arch, F);
    leerFlor(F);
    while (F.nombre <> 'zzz') do
    begin
        write(arch, F);
        leerFlor(F);
    end;
    close(arch);
end;


procedure mostrarArchivosNoEliminados(var arch:tArchFlores);
var
    F:reg_flor;
begin
    reset(arch);
    while (not eof(arch)) do
    begin
        read(arch, F);
        if (F.codigo > 0) then
        begin
            writeln('--------------------');
            writeln('Nombre: ', F.nombre, ' Codigo: ', F.codigo);
        end;
    end;
    close(arch);
end;

VAR
    arch:tArchFlores;
    buscado:reg_flor;
BEGIN
    generarArchivo(arch);

    writeln('LISTADO GENERADO');
    mostrarArchivosNoEliminados(arch);
    writeln('--------------------');

    writeln('Ingrese el codigo de flor que desea eliminar');
    readln(buscado.codigo);
    hacerBaja2(arch, buscado);

    writeln('LISTADO DESPUES DE ELIMINADO UN ELEMENTO');
    mostrarArchivosNoEliminados(arch);
    writeln('--------------------');

    agregarFlor(arch, 'nombre5', 5);

    writeln('LISTADO DESPUES DE HACER UN ALTA');
    mostrarArchivosNoEliminados(arch);
END.

{4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
tArchFlores = file of reg_flor;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descripta anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado}