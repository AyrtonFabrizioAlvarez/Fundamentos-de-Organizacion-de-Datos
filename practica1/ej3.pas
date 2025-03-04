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
			begin
				listarEmpleado(E);
				ok:= true;
			end;
		end;
		if (not ok) then
			writeln('No se encontro el empleado ', nombre, ' ', apellido);
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
	writeln('Ingrese la opcion que desea ejecutar: 1: Crear archivo  -  2: Abrir archivo existente  -  Pulse cualquier otra tecla para salir');
	readln(opcion);
end;

procedure menuBusqueda(var opcion:integer);
begin
	writeln('Ingrese la opcion que desea ejecutar: 1: Buscar empleado  -  2: Listar empleados  -  3: Empleados proximos a jubilar');
	readln(opcion);
end;

VAR
	archLogico: archivo;
	archFisico:string;
	opcion1, opcion2:integer;
BEGIN
	Randomize;
	
	menuBienvenida(opcion1);
	
	while (opcion1 = 1) or (opcion1 = 2) do
	begin
		
		if (opcion1 = 1) then //CREAR ARCHIVO
		begin
			writeln('Ingrerse el nombre del archivo fisico');
			readln(archFisico);
			assign(archLogico, archFisico);
			rewrite(archLogico);
			cargarEmpleado(archLogico);
			close(archLogico);
		end
		else if (opcion1 = 2) then //ABRIR ARCHIVO EXISTENTE
		begin
			writeln('Ingrerse el nombre del archivo fisico');
			readln(archFisico);
			assign(archLogico, archFisico);
			reset(archLogico);
			menuBusqueda(opcion2); 
			if (opcion2 = 1) then //BUSCAR EMPELADO POR NOMBRE Y APELLIDO
				procesar1(archLogico)
			else if (opcion2 = 2) then //LISTAR TODOS LOS EMPLEADOS
				procesar2(archLogico)
			else 						//EMPLEADOS PROXIMOS A JUBILARSE
				procesar3(archLogico); 
				
			close(archLogico)
		end;

		menuBienvenida(opcion1);
	end;
	
END.
