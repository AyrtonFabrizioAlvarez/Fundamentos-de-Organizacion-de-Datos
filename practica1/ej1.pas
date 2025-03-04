program ej1;

type
	archivo = file of integer;
	
procedure cargarNumeros(var archLogico:archivo);
var
	x:integer;
begin
	writeln('Ingrese un numero');
	readln(x);
	while (x <> 30000) do
	begin
		Write(archLogico, x);
		writeln('Ingrese un numero');
		readln(x);
	end;
end;

VAR
	archLogico: archivo;
	nombreFisico:String;
BEGIN
	writeln('Ingrese el nombre del archivo fisico');
	readln(nombreFisico);
	assign(archLogico, nombreFisico);
	rewrite(archLogico);
	cargarNumeros(archLogico);
	close(archLogico);
END.
