{17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
información de las motos que posee a la venta. De cada moto se registra: código, nombre,
descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
archivos detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.}

program tp2ej17;
const 
    valor_alto=9999;
    df=5;
type
    moto=record
        cod:integer;
        nombre:string;
        descripcion:string;
        modelo:string;
        marca:string;
        stock:integer;
    end;

    venta=record
        cod:integer;
        precio:integer;
        fecha:string;
    end;

    maestro=file of moto;
    detalle=file of venta;

    vDetalle=array[1..df]of detalle;
    vRegistro=array[1..df]of venta;

procedure leer(var arch:detalle ; var dato:venta);
begin
    if(not eof(arch))then
        read(arch, dato)
    else
        dato.cod:= valor_alto;
end;

procedure actualizarMaestro(var m:maestro;vD:vDetalle);
    procedure minimo(var vD: vDetalle;var vR:vRegistro;var min: venta );
    var 
        i,pos:integer;
    begin
        min.cod:= valor_alto;
        for i:= 1 to df do begin
            if vR[i].cod < min.cod then begin
            min:= vR[i];
            pos:=i;
            end;
        end; 
        if min.cod<> valor_alto then 
            leer(vD[pos], vR[pos]);
    end;
var
    i,aux,maxCod,maxCant:integer;
    vR:vRegistro;
    mot:moto;
    min:venta;
begin
    maxCant:=-1;
    reset(m);
    for i:=1 to df do begin
        reset(vD[i]);
        leer(vD[i],vR[i]);
    end;
    minimo(vD,vR,min);
    while(min.cod<>valor_alto)do begin 
        read(m,mot);
        while(mot.cod<>min.cod)do
            read(m,mot);
        aux:= 0;
        while(mot.cod=min.cod)do begin
            mot.stock:=mot.stock-1;
            aux:=aux+1;
            minimo(vD,vR,min);
        end;
        if (aux>maxCant)then begin
          maxCant:= aux;
          maxCod:= mot.cod;
        end;
        seek(m,FilePos(m)-1);
        write(m,mot);
    end;
    WriteLn('La moto mas vendida fue el codigo: ', maxCod ,' con ',maxCant,' ventas');
    close(m);
    for i:=1 to df do close(vD[i]);
end;

procedure asignar(var m: maestro; var vD: vDetalle);
var
    i:integer;
    iString:string;
begin
    assign(m,'maestro.bin');
    for i:=1 to df do begin
        str(i,iString);
        assign(vD[i], 'det'+iString+'.bin');
    end;
end;

Procedure verDet(Var d:detalle);
Var 
  aux: venta;
Begin
  WriteLn('Imprimimos detalle');
  reset(d);
  While Not eof(d) Do
    Begin
      read(d,aux);
      With aux Do
        Begin
          writeln('Codigo: ',cod,' precio: ',precio,' fecha: ',fecha);
        End;
    End;
  close(d);
End;

VAR
    m:maestro;
    vD:vDetalle;
BEGIN
    asignar(m,vD);
    actualizarMaestro(m,vD);
    //verDet(vD[3]);
END.


