{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.

Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.

AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control deunicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que se quiere agregar ya exista se debe informar “ya existe la distribución”.

BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”}

program ej8;

const
    valorAlto = 999;

Type
    distribucion = record
        nombre:String;
        anio:integer;
        version:integer;
        desarrolladores:integer;
        descripcion:String;
    end;

    archivo = file of distribucion;

procedure mostrarMaestro(var mae:archivo);
var
    D:distribucion;
begin
    reset(mae);
    while (not eof(mae)) do
    begin
        read(mae, D);
        writeln('Nombre: ', D.nombre, ' Desarrolladores: ', D.desarrolladores);
    end;
    close(mae);
end;

procedure leer(var D:distribucion);
begin
    writeln('Ingrese el nombre de la distribucion');
        readln(D.nombre);
    if (D.nombre <> 'zzz') then
    begin
        //writeln('Ingrese el anio de lanzamiento de la distribucione');
        D.anio:= random(51)+1950;
        //writeln('Ingrese la version de la distribucion');
        D.version:= random(5);
        writeln('Ingrese la cantidad de desarrolladores que participaron');
        readln(D.desarrolladores);
        writeln('Ingrese la descripcion de la distribucion');
        readln(D.descripcion);
    end;
end;

procedure generarMaestro(var mae:archivo);
var
    D:distribucion;
begin
    assign(mae, 'maestro.bin');
    rewrite(mae);
    D.nombre:= 'cabecera';
    D.anio:= 0;
    D.version:= 0;
    D.desarrolladores:= 0;          //EL CAMPO DESARROLLADORES ES EL QUE GUARDA LAS POSICIONES A RECUPERAR
    D.descripcion:= 'cabecera';
    write(mae, D);
    leer(D);
    while(D.nombre <> 'zzz') do
    begin
        write(mae, D);
        leer(D);
    end;
end;

function existeDistribucion(var mae:archivo ; buscado:String):boolean;
var
    D:distribucion;
begin
    reset(mae);
    existeDistribucion:= false;
    while (not eof(mae)) do
    begin
        read(mae, D);
        if (D.nombre = buscado) then
        begin
            existeDistribucion:= true;
        end;
    end;
    close(mae);
end;

procedure bajaDistribucion(var mae:archivo);

    procedure baja(var mae:archivo ; buscado:String);
    var
        D, cabecera:distribucion;
        posEliminado:integer;
        elimine:boolean;
    begin
        elimine:= false;
        reset(mae);
        read(mae, cabecera);                            //ME GUARDO LA CABECERA
        while ( (not eof(mae)) and (not elimine) ) do
        begin
            read(mae, D);                               //LEO EL PRIMER REGISTRO DE INFORMACION VALIDA
            if (D.nombre = buscado) then
            begin
                posEliminado:= filePos(mae)-1;                  //ME GUARDO LA POSICION DEL ELEMENTO A ELIMINAR
                D.desarrolladores:= cabecera.desarrolladores;   //ACTUALIZO EL REGISTRO ELIMINADO
                seek(mae, posEliminado);                        //VUELVO A POSICIONARME EN LA POSICION DEL ELEMENTO A ELIMINAR
                write(mae, D);                                  //ESCRIBO EL DATO MODIGICADO PARA MANTENER LA LISTA INVERTIDA
                cabecera.desarrolladores:= posEliminado * -1;   //ACTUALIZO EL DATO QUE VA EN LA CABECERA
                seek(mae, 0);                                   //VUELVO A POSICIONARME EN LA CABECERA DEL ARCHIVO
                write(mae, cabecera);                           //ACTUALIZO LA CABECERA
                elimine:= true;
            end;
        end;
        close(mae);
    end;

var
    buscado:String;
begin
    writeln('Ingrese el nombre de distribucion que desea buscar');
    readln(buscado);
    if (existeDistribucion(mae, buscado)) then
        baja(mae, buscado)
    else
        writeln('Distribucion no existente');
end;

procedure altaDistribucion(var mae:archivo);

    procedure alta(var mae:archivo ; D:distribucion);
    var
        cabecera, aux:distribucion;
        posLibre:integer;
    begin
        reset(mae);
        read(mae, cabecera);
        if (cabecera.desarrolladores = 0) then
        begin
            seek(mae, fileSize(mae));
            write(mae, D);
        end
        else
        begin
            posLibre:= cabecera.desarrolladores * -1;
            seek(mae, posLibre);
            read(mae, aux);
            seek(mae, filePos(mae)-1);
            write(mae, D);
            cabecera.desarrolladores:= aux.desarrolladores;
            seek(mae, 0);
            write(mae, cabecera); 
        end;
        close(mae);
    end;

var
    D:distribucion;
begin
    leer(D);
    if (existeDistribucion(mae, D.nombre)) then
        writeln('La distribucion ya existe')
    else
        alta(mae, D);
end;

VAR
    mae:archivo;
BEGIN
    generarMaestro(mae);
    mostrarMaestro(mae);
    writeln('');

    //writeln('Ingrese el nombre de distribucion que desea buscar');
    //readln(buscado);
    //writeln(existeDistribucion(mae, buscado));
    //writeln('');

    bajaDistribucion(mae);
    mostrarMaestro(mae);
    writeln('');

    altaDistribucion(mae);
    mostrarMaestro(mae);
    
END.