{13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
del mismo (información guardada acerca de los movimientos que ocurren en el server) que
se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.

a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema.}

program tp2ej13;
const
  valor_alto= 9999;
type
    registro= record    
        nro_usuario:integeR;
        nombreUsuario:String;
        nombre:String;
        apellido:String;
        cantidadMailEnviados:integer;
    end;
    dRegistro= record
        nro_usuario: integer;
        cuentaDestino: String;
        cuerpoMensaje:String;
    end;

    maestro=file of registro;
    detalle=file of dRegistro;

procedure leerDetalle(var arch: detalle ; var dato:dregistro);
begin
    if (not eof(arch)) then
        read(arch, dato)
    else
        dato.nro_usuario:= valor_alto
end;

procedure leerMaestro(var arch: maestro ; var dato:registro);
begin
    if (not eof(arch)) then
        read(arch, dato)
    else
        dato.nro_usuario:= valor_alto
end;

Procedure crearBin(Var a:maestro ; Var d: detalle);
Var 
  txt: Text;
  aux: registro;
  auxd:dRegistro;
Begin
  assign(a,'var/log/logmail.dat');
  Rewrite(a);
  assign(txt,'maestro.txt');
  reset(txt);
  While Not eof (txt) Do
    Begin
      With aux Do
        Begin
          readln(txt,nro_usuario,nombreUsuario);
          readln(txt,nombre);
          readln(txt,apellido);
          readln(txt,cantidadMailEnviados);
        End;
      Write(a,aux);
    End;
  close(a);
  close(txt);
    assign(d,'detalle.dat');
    Rewrite(d);
    assign(txt,'detalle.txt');
    reset(txt);
    While Not eof (txt) Do
    Begin
        With auxd Do
        Begin
            readln(txt,nro_usuario,cuentaDestino);
            readln(txt,cuerpoMensaje);
        End;
        Write(d,auxd);
    End;
    close(d);
    close(txt);
End;

procedure actualizarMaestro(var mae:maestro ; var det:detalle);
var
    regMae:registro;
    regDet:dRegistro;
    txt:text;
    cantDia:integer;
begin
    assign(txt, 'reporte.txt');
    rewrite(txt);
    reset(mae);
    reset(det);
    leerMaestro(mae, regMae);
    leerDetalle(det, regDet);
    while(regMae.nro_usuario <> valor_alto) do
    begin
        while(regMae.nro_usuario <> valor_alto)and(regDet.nro_usuario <> regMae.nro_usuario)do begin
            writeln(txt,regMae.nro_usuario,' ',0);
            leerMaestro(mae, regMae);
        end;
        if(regMae.nro_usuario<>valor_alto)then begin
            cantDia:=0;    
            while(regDet.nro_usuario = regMae.nro_usuario)do
            begin
                cantDia:= cantDia+1;
                regMae.cantidadMailEnviados:= regMae.cantidadMailEnviados + 1;
                leerDetalle(det, regDet);
            end;
            seek(mae, filePos(mae)-1);
            write(mae, regMae);
            writeln(txt, regMae.nro_usuario, ' ', cantDia);
            leerMaestro(mae,regMae);
        end;
    end;
    close(det);
    close(mae);
    close(txt);
end;

VAR
    a: maestro;
    d: detalle;
BEGIN
    crearBin(a,d);
    actualizarMaestro(a,d);
END.