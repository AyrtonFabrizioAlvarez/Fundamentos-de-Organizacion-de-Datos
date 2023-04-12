{14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.}
program ej14;
Const
    valorAlto = 'zzz';
Type
    vuelo = record
        destino:String;
        fecha:String;
        horaSalida:integer;
        asientos:integer;
    end;
    archivo = file of vuelo;

    vueloL = record
        destino:String;
        fecha:String;
        horaSalida:integer;
    end;

    lista=^nodo;
    nodo=record
        dato: vueloL;
        sig:lista;
    end;
procedure agregarAtras(var l,ult: lista;v:vuelo);
var
 nue:lista;
begin
    new(nue);
    nue^.dato.destino:= v.destino;
    nue^.dato.fecha:=v.fecha;
    nue^.dato.horaSalida:=v.horaSalida;
    nue^.sig:=nil;
    if(l=nil)then
        l:=nue
    else
        ult^.sig:= nue;
    ult:=nue;
end;    
procedure agregarAdelante(var l: lista;v:vueloL);
var
 nue:lista;
begin
    new(nue);
    nue^.dato:= v;
    nue^.sig:= l;
    l:=nue;
end;    
procedure leer(var a:archivo ; var V:vuelo);
begin
    if (not eof(a)) then
        read(a, V)
    else
        V.destino:= valorAlto
end;

procedure procesarArchivos(var m,d1,d2 :archivo;var l:lista);

    procedure minimo(var d1, d2:archivo ; var min, regD1, regD2:vuelo);
    begin
        if (regD1.destino < regD2.destino) or 
        ((regD1.destino = regD2.destino) and (regD1.fecha < regD2.fecha)) or 
        ((regD1.destino = regD2.destino) and (regD1.fecha = regD2.fecha) and (regD1.horaSalida < regD2.horaSalida) ) then
        begin
            min:= regD1;
            leer(d1, regD1);
        end
        else
        begin
            min:= regD2;
            leer(d2, regD2);
        end;
    end;

    procedure entraLista(var l, ultimo:lista;regM:vuelo;asientos:integer);
    begin
        if(regM.asientos<asientos)then
            agregarAtras(l, ultimo, regM);
    end;

var
    min, regM, regD1, regD2:vuelo;
    asientos:integer;
    ult:lista;
begin
    writeln('Ingrese la cantidad de asientos que desea filtrar: ');
    readln(asientos);
    reset(m);
    reset(d1);
    reset(d2);
    leer(m, regM);
    leer(d1, regD1);
    leer(d2, regD2);
    minimo(d1, d2, min, regD1, regD2);
    while(min.destino <> valorAlto) do
    begin
        while(regM.destino <> min.destino) or (regM.fecha <> min.fecha) or (regM.horaSalida <> min.horaSalida)do begin
            entraLista(l,ult,regM,asientos);
            leer(m, regM);
        end;
        while(regM.destino = min.destino) and (regM.fecha = min.fecha) and (regM.horaSalida = min.horaSalida)do
        begin
            regM.asientos:= regM.asientos - min.asientos;
            minimo(d1, d2, min, regD1, regD2);
        end;
        seek(m,FilePos(m)-1);
        write(m,regM);
    end;
    entraLista(l,ult,regM,asientos);
    while(not eof(m)) do begin
        read(m,regM);
        entraLista(l,ult,regM,asientos);
    end;
    close(m);
    close(d1);
    close(d2);
end;
 
procedure imprimirL(l:lista);
begin
    while(l<>nil)do begin 
        writeln('Destino: ',l^.dato.destino,'; fecha: ',l^.dato.fecha,'; hora de salida: ',l^.dato.horaSalida);
        l:=l^.sig;
    end;
end;

Procedure crearBin(Var m,d1,d2:archivo);
    Var 
      txt: Text;
      aux: vuelo;
    Begin
      assign(m,'maestro');
      Rewrite(m);
      assign(txt,'maestro.txt');
      reset(txt);
      While Not eof (txt) Do Begin
          With aux Do
            Begin
              readln(txt,destino);
              readln(txt,fecha);
              readln(txt,horaSalida,asientos);
            End;
          Write(m,aux);
        End;
      close(m);
      close(txt);
      assign(d1,'detalle1.dat');
      Rewrite(d1);
      assign(d2,'detalle2.dat');
      Rewrite(d2);
      assign(txt,'detalle.txt');
      reset(txt);
      While Not eof (txt) Do
        Begin
          With aux Do Begin
            readln(txt,destino);
            readln(txt,fecha);
            readln(txt,horaSalida,asientos);
            End;
          Write(d1,aux);
          Write(d2,aux);
        End;
      close(d1);
      close(d2);
      close(txt);
      WriteLn('binarios creados con exito');
End;

VAR
    m,d1,d2:archivo;
    l:lista;
BEGIN
    l:=nil;
    crearBin(m,d1,d2);
    procesarArchivos(m,d1,d2,l);
    imprimirL(l);
END.