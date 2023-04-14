program ej16;

const
    dimF = 10;
    valorAlto = 'zzz';

Type
    {La editorial X, autora de diversos semanarios, posee un archivo maestro con la
    información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
    registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
    ejemplares y total de ejemplares vendido.}
    emision = record
        fecha:String;
        codigoSeminario:integer;
        nombreSeminario:String;
        descripcion:String;
        precio:integer;
        ejemplares:integer;
        vendidos:integer;
    end;

    maestro = file of emision;

    {Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
    país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
    cantidad de ejemplares vendidos.}
    venta = record
        fecha:String;
        codigoSeminario:integer;
        vendidos:integer;
    end;

    detalle = file of venta;

    vDetalle = array[1..dimF] of detalle;
    vRegistro = array[1..dimF] of venta;

procedure generarBin(var mae:maestro ; var vDet:vDetalle);
var
    txtMae, txtDet:text;
    regM:emision;
    regD:venta;
    i:integer;
    iString:String;
begin
    assign(txtMae, 'maestro.txt');
    assign(mae, 'maestro.bin');
    reset(txtMae);
    rewrite(mae);
    while(not eof(txtMae))do
    begin
        with regM do
        begin
            readln(txtMae, fecha);
            readln(txtMae, codigoSeminario, nombreSeminario);
            readln(txtMae, descripcion);
            readln(txtMae, precio, ejemplares, vendidos);
            write(mae, regM);
        end;
    end;
    close(mae);

    assign(txtDet, 'detalle.txt');
    for i:=1 to dimF do
    begin
        reset(txtDet);
        Str(i, iString);
        assign(vDet[i], 'detalle'+iString+'.bin');
        rewrite(vDet[i]);
        while(not eof(txtDet))do
        begin
            with regD do
            begin
                readln(txtDet, fecha);
                readln(txtDet, codigoSeminario, vendidos);
                write(vDet[i], regD);
            end;
        end;
        close(vDet[i]);
    end;
end;

procedure leer(var arch:detalle ; var dato:venta);
begin
    if(not eof(arch))then
        read(arch, dato)
    else
        dato.fecha:= valorAlto;
end;

procedure actualizarMaestro(var mae:maestro ; var vDet:vDetalle ; var vReg:vRegistro);

    procedure minimo(var vDet:vDetalle ; var vReg:vRegistro ; var min:venta);
    var
        i, pos:integer;
    begin
        min.fecha:= valorAlto;
        pos:= -1;
        for i:=1 to dimF do
        begin
            if (vReg[i].fecha < min.fecha) or ( (vReg[i].fecha = min.fecha) and (vReg[i].codigoSeminario < min.codigoSeminario) ) then
            begin
                min:= vReg[i];
                pos:= i
            end;
        end;
        if (min.fecha <> valorAlto)then
            leer(vDet[pos], vReg[pos])
    end;

    procedure maxVenta( regMae:emision ; var max:venta);
    begin
        if (regMae.vendidos > max.vendidos) then
        begin
            max.fecha:= regMae.fecha;
            max.codigoSeminario:= regMae.codigoSeminario;
            max.vendidos:= regMae.vendidos;
        end;
    end;

    procedure minVenta( regMae:emision ; var min:venta);
    begin
        if (regMae.vendidos < min.vendidos) then
        begin
            min.fecha:= regMae.fecha;
            min.codigoSeminario:= regMae.codigoSeminario;
            min.vendidos:= regMae.vendidos;
        end;
    end;

var
    min, maxVentas, minVentas:venta;
    regMae:emision;
    fechaActual:String;
    seminarioActual, i:integer;
begin
    maxVentas.vendidos:= -1;
    minVentas.vendidos:= 999;
    reset(mae);
    for i:=1 to dimF do
    begin
        reset(vDet[i]);
        leer(vDet[i], vReg[i]);
    end;
    minimo(vDet, vReg, min);
    while(min.fecha <> valorAlto)do
    begin
        read(mae, regMae);
        while( (regMae.fecha <> min.fecha) and (regMae.codigoSeminario <> min.codigoSeminario) ) do
        begin
            minVenta(regMae, minVentas);
            maxVenta(regMae, maxVentas);
            read(mae, regMae);
        end;
        fechaActual:= min.fecha;
        while(fechaActual = min.fecha)do
        begin
            seminarioActual:= min.codigoSeminario;
            while (fechaActual = min.fecha) and (seminarioActual = min.codigoSeminario)do
            begin
                regMae.vendidos:= regMae.vendidos + min.vendidos;
                minimo(vDet, vReg, min);
            end;
            seek(mae, filePos(mae)-1);
            write(mae, regMae);
            minVenta(regMae, minVentas);
            maxVenta(regMae, maxVentas);
        end;
    end;
    while(not eof(mae))do
    begin
        read(mae, regMae);
        minVenta(regMae, minVentas);
        maxVenta(regMae, maxVentas);
    end;
    close(mae);
    for i:=1 to dimF do
        close(vDet[i]);
    writeln('El seminario con mas ventas fue: ', maxVentas.fecha);
    writeln('Codigo: ', maxVentas.codigoSeminario);
    writeln('Vendio: ', maxVentas.vendidos);
    writeln('');
    writeln('El seminario con menos ventas fue: ', minVentas.fecha);
    writeln('Codigo: ', minVentas.codigoSeminario);
    writeln('Vendio: ', minVentas.vendidos);
end;

VAR
    mae:maestro;
    vDet:vDetalle;
    vReg:vRegistro;
BEGIN
    generarBin(mae, vDet);
    actualizarMaestro(mae, vDet, vReg);
END.

{16. La editorial X, autora de diversos semanarios, posee un archivo maestro con la
información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
ejemplares y total de ejemplares vendido.Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos.
Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}