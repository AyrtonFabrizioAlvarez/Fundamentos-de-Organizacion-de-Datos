program ej6;

const
    valorAlto = 999;


TYPE
    {Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
    con la información correspondiente a las prendas que se encuentran a la venta. De
    cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
    precio_unitario.}
    prenda = record
        cod_prenda:integer;
        descripcion:String;
        colores:String;
        tipo_prenda:String;
        stock:integer;
        precio_unitario:integer;
    end;

    maestro = file of prenda;

    {Ante un eventual cambio de temporada, se deben actualizar las prendas
    a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas quequedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
    y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
    correspondiente a valor negativo.}
    prenda_obs = record
        cod_prenda:integer;
    end;

    detalle = file of prenda_obs;

procedure generarMaestro(var mae:maestro);

    procedure leerPrenda(var P:prenda);
    begin
        writeln('Ingrese el codigo de la prenda');
        readln(P.cod_prenda);
        if(P.cod_prenda <> 0) then
        begin
            writeln('Ingrese la descripciono de la prenda');
            readln(P.descripcion);
            writeln('Ingrese los colores disponibles de la prenda');
            readln(P.colores);
            writeln('Ingrese el tipo de la prenda');
            readln(P.tipo_prenda);
            writeln('Ingrese el stock de la prenda');
            readln(P.stock);
            //writeln('Ingrese el precio de la prenda');
            P.precio_unitario:= random(1001);
        end;
    end;

var
    P:prenda;
begin
    assign(mae, 'maestro.bin');
    rewrite(mae);
    leerPrenda(P);
    while(P.cod_prenda <> 0) do
    begin
        write(mae, P);
        leerPrenda(P);
    end;
end;

procedure generarDetalle(var det:detalle);

    procedure leerPrendaObsoleta(var P:prenda_obs);
    begin
        writeln('Ingrese el codigo de la prenda');
        readln(P.cod_prenda);
    end;

var
    P:prenda_obs;
begin
    assign(det, 'detalle.bin');
    rewrite(det);
    leerPrendaObsoleta(P);
    while(P.cod_prenda <> 0) do
    begin
        write(det, P);
        leerPrendaObsoleta(P);
    end;
end;

procedure mostrarMaestro(var mae:maestro);
var
    P:prenda;
begin
    reset(mae);
    while (not eof(mae)) do
    begin
        read(mae, P);
        writeln('Codigo: ', P.cod_prenda, ' Descripcion: ', P.descripcion, ' Stock: ', P.stock);
    end;
    close(mae);
end;

procedure mostrarDetalle(var det:detalle);
var
    P:prenda_obs;
begin
    reset(det);
    while (not eof(det)) do
    begin
        read(det, P);
        writeln('Codigo: ', P.cod_prenda);
    end;
    close(det);
end;

procedure actualizarMaestro(var mae:maestro ; var det:detalle);

    procedure leerDetalle(var det:detalle ; var dato:prenda_obs);
    begin
        if (not eof(det)) then
            read(det, dato)
        else
            dato.cod_prenda:= valorAlto;
    end;

var
    regMae:prenda;
    regDet:prenda_obs;
begin
    reset(mae);
    reset(det);
    leerDetalle(det, regDet);                               //LEO EL DETALLE POR PRIMERA VEZ
    while (regDet.cod_prenda <> valorAlto) do               //MIENTRAS NO LLEGUE AL FINAL DEL DETALLE
    begin
        read(mae, regMae);
        while(regMae.cod_prenda <> regDet.cod_prenda) do    //MIENTRAS EL MAESTRO NO SEA IGUAL AL DETALLE AVANZO EN EL MAESTRO
            read(mae, regMae);

        regMae.cod_prenda:= regMae.cod_prenda * -1;         //MODIFICO EL CAMPO "COD_PRENDA"
        seek(mae, filePos(mae)-1);                          //VUELVO 1 POSICION HACIA ATRAS EN EL ARCHIVO
        write(mae, regMae);                                 //SOBREESCRIBO EL REGISTRO ACTUALIZADO
        leerDetalle(det, regDet);                           //VUELVO A LEER UN DETALLE
    end;
    close(mae);
    close(det);
end;

procedure generarNuevoMaestro(var mae:maestro ; var maeNuevo:maestro);
var
    P:prenda;
begin
    reset(mae);
    assign(maeNuevo, 'maestroActualizado.bin');
    rewrite(maeNuevo);
    while (not eof(mae)) do
    begin
        read(mae, P);
        if (P.cod_prenda > 0) then
            write(maeNuevo, P)
    end;
    close(mae);
    close(maeNuevo);
end;

VAR
    mae:maestro;
    det:detalle;
    maeNuevo:maestro;
BEGIN
    generarMaestro(mae);
    //mostrarMaestro(mae);
    //writeln('');
    generarDetalle(det);
    //mostrarDetalle(det);
    //writeln('');
    actualizarMaestro(mae, det);
    mostrarMaestro(mae);
    writeln('');
    generarNuevoMaestro(mae, maeNuevo);
    mostrarMaestro(maeNuevo);
    erase(mae);
    rename(maeNuevo, 'nuevoMaestro.bin');
    writeln('');
    mostrarMaestro(maeNuevo);
END.

{6.  
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.}