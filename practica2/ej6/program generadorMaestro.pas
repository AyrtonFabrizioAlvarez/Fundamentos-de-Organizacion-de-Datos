program generadorMaestro;
Type
    reporteM = record
        codigoLoc: integer;
        nombreLoc: string[30];
        codigoCepa: integer;
        nombreCepa: string[30];
        cantActivos:integer;
        cantNuevos: integer;
        cantRecuperados:integer; 
        cantFallecidos: integer;
    end;
    maestro = file of reporteM;
    reporteD = record
        codigoLocalidad:integer;
        codigoCepa:integer;
        cantActivos:integer;
        cantNuevos:integer;
        cantRecuperados:integer;
        cantFallecidos:integer;
    end;
    detalle = file of reporteD;
    vDetalle = array [1..10] of detalle;

procedure crearDetalles(var vectorDetalles: vDetalle);
var
    i:integer; txt:text; aux: reporteD;
    iString:string
begin
    assign(txt, 'detalle.txt');
    reset(txt);
    for i:=1 to 10 do begin
        str(i,iString);
        Assign(vectorDetalles[i], ('detalle'+iString));
        Rewrite(vectorDetalles[i]);
        while(not eof(txt)) do begin
            readln(txt, aux.codigoLocalidad, aux.codigoCepa, aux.cantActivos, aux.cantNuevos, aux.cantRecuperados, aux.cantFallecidos);
            write(vectorDetalles[i], aux);
        end;
        Close(vectorDetalles[i]);
    end;
    Close(txt);
    Writeln('Creacion de binarios detalles hecha con exito');
end;
var 
    m:maestro;
    i,j:integer;
    r:reporteM;
    loc,cep:string;
    vectorDetalle: vDetalle;
begin
    assign(m,'maestro');
    rewrite(m);
    for i:=1 to 8 do begin
        str(i,loc);
        for j:=1 to 4 do begin
            str(j,cep);
            r.codigoLoc:=i;
            r.nombreLoc:=('localidad ' + loc);
            r.codigoCepa:=j;
            r.nombreCepa:=('cepa ' + cep);
            r.cantActivos:=random(500);
            r.cantNuevos:=random(500);
            r.cantRecuperados:=random(500);
            r.cantFallecidos:=random(500);
            write(m,r);
        end;
    end;
    close(m);
    crearDetalles(vectorDetalle);
end.