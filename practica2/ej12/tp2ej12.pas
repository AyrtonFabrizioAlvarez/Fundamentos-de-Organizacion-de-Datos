{12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
siguientes criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idusuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idusuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1
------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idusuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idusuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
- El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
- El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
- Debe definir las estructuras de datos necesarias.
- El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.    
}

Program tp2ej12;
const
    valor_alto = 9999;
Type 
  anios = Record
    anio : integer;
    mes: Integer;
    dia: Integer;
  End;
  regServidor = Record
    fecha : anios;
    idUsuario: integer;
    tiempo: integer;
  End;
  archivo = file of regServidor;

   procedure leer (var a:archivo; var aux : regServidor);
   begin
     if (not eof(a))then
        read(a,aux)      
    else
        aux.fecha.anio:= valor_alto;
   end; 
   procedure crearBin(var a:archivo);
   var
    txt: Text;
    aux: regServidor;
   begin
     assign(a,'maestro.bin');
     Rewrite(a);
     assign(txt,'maestro.txt');
     reset(txt);
     while not eof (txt) do begin
        with aux do begin
          read(txt,fecha.anio, fecha.mes, fecha.dia, idUsuario, tiempo);        
        end;
        Write(a,aux);
     end;
     close(a); 
     close(txt);
   end;

   procedure procesarArhivo(var a: archivo);
   var
    aux: regServidor;
    fechaActual: anios;
    buscado, totalMes, totalAnio, totalDia, totalUsuario, usuarioActual:integer;
   begin
    writeln('Ingrese el año que desea filtrar');
    readln(buscado);
    assign(a, 'maestro.bin');
    reset(a);
    leer(a, aux);
    writeln('Anio: ', buscado);
    while(aux.fecha.anio <> valor_alto) and (aux.fecha.anio<>buscado) do
      leer(a, aux);
    if(aux.fecha.anio=valor_alto)then
      writeln('Anio no encontrado')
    else
    begin
      totalAnio:=0;
      while(aux.fecha.anio=buscado)do begin
        fechaActual.mes:= aux.fecha.mes;
        totalMes:= 0;
        writeln('Mes: ', fechaActual.mes);
        while(aux.fecha.anio=buscado) and (fechaActual.mes = aux.fecha.mes) do
        begin
          fechaActual.dia:= aux.fecha.dia;
          totalDia:= 0;
          writeln('Dia: ', fechaActual.dia);
          while(aux.fecha.anio=buscado) and(fechaActual.mes = aux.fecha.mes) and (fechaActual.dia = aux.fecha.dia)do
          begin
            usuarioActual:=aux.idUsuario;
            totalUsuario:=0;
            while(aux.fecha.anio=buscado) and (fechaActual.mes = aux.fecha.mes) and (fechaActual.dia = aux.fecha.dia) and (usuarioActual=aux.idUsuario)do begin
              totalUsuario:=totalUsuario+aux.tiempo;
              leer(a,aux);
            end;
            writeln('idUsiario ',usuarioActual,'; tiempo total de acceso en el dia ',fechaActual.dia,', mes ',fechaActual.mes,': ',totalUsuario);
            totalDia:=totalDia+totalUsuario;
          end;
          writeln('Tiempo total de acceso dia ',fechaActual.dia,', mes ',fechaActual.mes,': ',totalDia);
          totalMes:=totalMes+totalDia;
        end;
        writeln('Tota tiempo de acceso mes ',fechaActual.mes,': ',totalMes);
        totalAnio:=totalAnio+totalMes;
      end;
      writeln('Total tiempo de acceso anio: ', totalAnio);
    end;
   close(a);
   end;
   

Var 
    a :archivo;
Begin
    crearBin(a);
    procesarArhivo(a);
End.
