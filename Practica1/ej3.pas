program ej3;

type
	empleado = record
		numero:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		dni:integer;
	end;
	
	archivo = file of empleado;

procedure cargarEmpleado(var archLogico:archivo);
var
	E:empleado;
begin
	writeln('Ingrese el apellido del empleado');
	readln(E.apellido);
	while (E.apellido <> 'fin') do
	begin
		E.numero:= random(101);
		E.edad:= random(81);
		E.dni:= random(1001);
		writeln('Ingrese el nombre del empleado');
		readln(E.nombre);
		write(archLogico, E);
		
		writeln('Ingrese el apellido del empleado');
		readln(E.apellido);
	end;
end;

procedure listarEmpleado(E:empleado);
begin
	writeln('Nombre: ', E.nombre, ' Apellido: ', E.apellido, ' Edad: ', E.edad, ' Dni: ', E.dni, ' Numero: ', E.numero);
end;

procedure procesar1(var archLogico:archivo);

	procedure buscar(var archLogico:archivo ; nombre, apellido:string);
	var
		E:empleado;
		ok:boolean;
	begin
		ok:= false;
		while (not eof(archLogico)) and (not ok) do
		begin
			read(archLogico, E);
			if (E.nombre = nombre) and (E.apellido = apellido) then
				listarEmpleado(E);
		end;
	end;

var
	nomBuscado, apeBuscado:string;
begin
	writeln('Ingrese el nombre a buscar');
	readln(nomBuscado);
	writeln('Ingrese el apellido a buscar');
	readln(apeBuscado);
	buscar(archLogico, nomBuscado, apeBuscado);
end;

procedure procesar2(var archLogico:archivo);
var
	E:empleado;
begin
	while (not eof(archLogico)) do
	begin
		read(archLogico, E);
		listarEmpleado(E);
	end;
end;

procedure procesar3(var archLogico:archivo);
var
	E:empleado;
begin
	while (not eof(archLogico)) do
	begin
		read(archLogico, E);
		if (E.edad > 70) then
			listarEmpleado(E)
	end;
end;

procedure menuBienvenida(var opcion:integer);
begin
	writeln('Ingrese la opcion que desea ejecutar: 1: Buscar empleado  -  2: Listar empleados  -  3: Empleados por jubilar');
	readln(opcion);
end;

VAR
	archLogico: archivo;
	archFisico:string;
	opcion:integer;
BEGIN
	Randomize;
	writeln('Ingrerse el nombre del archivo fisico');
	readln(archFisico);
	assign(archLogico, archFisico);
	rewrite(archLogico);
	cargarEmpleado(archLogico);
	close(archLogico);
	
	writeln('Ingrerse el nombre del archivo fisico');
	readln(archFisico);
	assign(archLogico, archFisico);
	reset(archLogico);
	menuBienvenida(opcion); 
	
	
	if (opcion = 1) then
		procesar1(archLogico)
	else if (opcion = 2) then
		procesar2(archLogico)
	else
		procesar3(archLogico);
		
	close(archLogico)
	
END.
