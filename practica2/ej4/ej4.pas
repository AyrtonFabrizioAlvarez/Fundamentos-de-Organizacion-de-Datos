program ej4;

const
    valorAlto = 999;

Type
    usuarioParcial = record
        codigo:integer;
        fecha:integer;
        tiempo:integer;
    end;
    usuario = record
        codigo:integer;
        fecha:integer;
        tiempoTotal:integer;
    end;

    maestro = file of usuario;
    detalle = file of usuarioParcial;

    vDetalle = array [1..5] of detalle;
    vRegistro = array [1..5] of usuarioParcial;

procedure generarBinarios(var vDet:vDetalle);
var
    U:usuarioParcial;
    iString:String;
    txt:Text;
    i:integer;
begin
    for i:=1 to 5 do
    begin
        Str(i, iString);
        assign(vDet[i], 'det'+iString);
        assign(txt, 'detalle'+iString+'.txt');
        reset(txt);
        rewrite(vDet[i]);
        while(not eof(txt))do
        begin
            readln(txt, U.codigo, U.fecha);
            readln(txt, U.tiempo);
            write(vDet[i], U);
        end;
    end;
    close(txt);
end;

procedure leer(var det:detalle ; var U:usuarioParcial);
begin
    if (not eof(det)) then
        read(det, U)
    else
        U.codigo:= valorAlto;
end;

procedure minimo(var vDet:vDetalle ; var vReg:vRegistro ; var min:usuarioParcial);
var
    i, pos:integer;
begin
    min.codigo:= valorAlto;
    min.fecha:= valorAlto;
    pos:=-1;
    for i:=1 to 5 do
    begin
        if (vReg[i].codigo <= min.codigo) and (vReg[i].fecha <= min.fecha) then
        begin
            min:= vReg[i];
            pos:= i;
        end;
    end;
    if(min.codigo <> valorAlto) then
        leer(vDet[pos], vReg[pos])
end;

VAR
    vDet: vDetalle;
    vReg: vRegistro;
    mae:maestro;
    min:usuarioParcial;
    U:usuario;
    i, empleadoActual, fechaActual, total:integer;
BEGIN
    generarBinarios(vDet);          //GENERO LOS DETALLES.DAT

    assign(mae, 'maestro');         //ASIGNO Y EMPIEZO CON EL ARCHIVO MAESTRO
    rewrite(mae);

    for i:=1 to 5 do                //RESETEO LOS DETALLES Y LEO 1 REGISTRO DE CADA UNO
    begin
        reset(vDet[i]);
        leer(vDet[i], vReg[i]);
    end;

    minimo(vDet, vReg, min);        //CALCULO EL MINIMO
    while (min.codigo <> valorAlto) do
    begin
        empleadoActual:= min.codigo;    //PARA CORTE DE CONTROL 
        while(empleadoActual = min.codigo) do   //MIENTRAS SEA EL EMPLEADO ACTUAL
        begin
            fechaActual:= min.fecha;            //PARA CORTE DE CONTROL
            total:= 0;                          //CONTADOR DEL TOTAL DE TIEMPO
            while(min.codigo <> valorAlto) and (fechaActual = min.fecha) do // MIENTRAS SEA LA FECHA ACTUAL
            begin
                total:= total + min.tiempo;
                minimo(vDet, vReg, min);
            end;
            U.codigo:= empleadoActual;
            U.fecha:= fechaActual;
            U.tiempoTotal:= total;
            write(mae, U);
        end;
    end;
    
    reset(mae);
    while (not eof(mae)) do
    begin
        read(mae, U);
        writeln('Codigo:', U.codigo, ' Fecha:', U.fecha, ' Tiempo:', U.tiempoTotal)
    end;
    close(mae);
END.