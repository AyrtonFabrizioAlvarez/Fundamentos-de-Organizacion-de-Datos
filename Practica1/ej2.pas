program ej2;

type
	archivo = file of integer;

function menor1500(x:integer):boolean;
begin
	if (x > 1500) then
		menor1500:= true
	else
		menor1500:= false;
end;

function promedio(sumaTotal, cantTotal:integer):double;
begin
	promedio:= sumaTotal / cantTotal;
end;

VAR
	archLogico: archivo;
	archFisico:String;
	x, cant, total, cantNumeros:integer;
BEGIN
	cant:= 0;
	total:= 0;
	cantNumeros:= 0;
	writeln('Ingrese el nombre del archivo a buscar');
	readln(archFisico);
	assign(archLogico, archFisico);
	reset(archLogico);
	while (not eof(archLogico)) do
	begin
		read(archLogico, x);
		total:= total + x;
		if (menor1500(x)) then
			cant:= cant + 1;
		cantNumeros:= cantNumeros + 1;
		writeln(x);
	end;
	writeln('El promedio es: ', promedio(total, cantNumeros):2:2);
	writeln('La cantidad de numeros mayores a 1500 son: ', cant);
	close(archLogico)
END.
