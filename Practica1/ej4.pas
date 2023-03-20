program ej4;

type
	empleado = record
		numero:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		dni:integer;
	end;
	
	archivo = file of empleado;


procedure menuBienvenida(var opcion:char);
begin
	writeln('-------------------------------------');
	writeln('Ingrese la opcion que desea ejecutar');
	writeln('1: Crear archivo');
	writeln('2: Abrir archivo existente');
	writeln('3: Agregar empleado/s a un archivo existente');
	writeln('4: Modificar edad a N empleados');
	writeln('5: Exportar a un .txt un archivo binario completo');
	writeln('6: Exportar a un .txt los empleados de un archivo binario que no tengan dni');
	writeln('Pulse cualquier otra tecla para salir');
	writeln('-------------------------------------');
	readln(opcion);
end;

procedure menuBusqueda(var opcion:char);
begin
	writeln('-------------------------------------');
	writeln('Ingrese la opcion que desea ejecutar');
	writeln('1: Buscar empleado');
	writeln('2: Listar empleados');
	writeln('3: Empleados proximos a jubilar');
	writeln('-------------------------------------');
	readln(opcion);
end;

procedure cargarEmpleados(var archLogico:archivo);
var
	E:empleado;
begin
	writeln('Ingrese el apellido del empleado');
	readln(E.apellido);
	while (E.apellido <> 'fin') do
	begin
		writeln('Ingrese el nombre del empleado');
		readln(E.nombre);
		writeln('Ingrese el numero de empleado');
		readln(E.numero);
		writeln('Ingrese el dni del empleado');
		readln(E.dni);
		E.edad:= random(81);
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

procedure existeNumEmpleado(var archLogico:archivo ; var existe:boolean ; buscado:integer);
var
	E:empleado;
begin
	while (not eof(archLogico)) do
	begin
		read(archLogico, E);
		if (E.numero = buscado) then
			existe:= true
	end;
end;

procedure cargarUnEmpleadoNuevo(var archLogico:archivo);
var
	E:empleado;
	existe:boolean;
begin
	reset(archLogico);
	existe:= false;
	writeln('Ingrese el apellido del empleado');
	readln(E.apellido);
	writeln('Ingrese el nombre del empleado');
	readln(E.nombre);
	writeln('Ingrese el numero de empleado');
	readln(E.numero);
	writeln('Ingrese el dni del empleado');
	readln(E.dni);
	existeNumEmpleado(archLogico, existe, E.numero);
	E.edad:= random(81);
	if (not existe) then
		write(archLogico, E);
end;

procedure cargarNEmpleados(var archLogico:Archivo ; x:integer);
var
	i:integer;
begin
	for i:=1 to x do
		cargarUnEmpleadoNuevo(archLogico);
end;

procedure modificarEdad(var archLogico:archivo ; numBuscado, edad:integer);
var
	E:empleado;
begin
	while (not eof(archLogico)) do
	begin
		read(archLogico, E);
		if (E.numero = numBuscado) then
			E.edad:= edad;
		seek(archLogico, filePos(archLogico)-1);
		write(archLogico, E);
	end;
end;

procedure modificarEdadNEmpleados(var archLogico:archivo ; x:integer);
var
	i, numero, edad:integer;
begin
	for i:=1 to x do
	begin
		writeln('Ingrese el numero de empleado al que desea modificarle su edad');
		readln(numero);
		writeln('Ingrese la edad que tiene el empleado actualmente');
		readln(edad);
		reset(archLogico);
		modificarEdad(archLogico, numero, edad);
	end;
end;

procedure exportarTxt1(var archLogico:archivo ; var txt:Text);
var
	E:empleado;
begin
	while (not eof(archLogico)) do
	begin
		read(archLogico, E);
		with E do
			writeln(numero:5, apellido:5, nombre:5, edad:5, dni:5);
		with E do
			writeln(txt, ' ', numero, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni );
	end;
end;

procedure exportarTxt2(var archLogico:archivo ; var txt:Text);
var
	E:empleado;
begin
	while (not eof(archLogico)) do
	begin
		read(archLogico, E);
		if (E.dni = 0) then
		begin
			with E do
				writeln(numero:5, apellido:5, nombre:5, edad:5, dni:5);
			with E do
				writeln(txt, ' ', numero, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni );
		end;
	end;
end;

VAR
	archLogico: archivo;
	archFisico:string;
	opcion1, opcion2:char;
	ejecutar:boolean;
	x, y:integer;
	txt:Text;
BEGIN
	Randomize;
	ejecutar:= true;
	
	while (ejecutar) do
	begin
		menuBienvenida(opcion1);
		
		case opcion1 of
			'1':begin	//CREAR ARCHIVO DE EMPLEADOS
					writeln('Ingrerse el nombre del archivo fisico');
					readln(archFisico);
					assign(archLogico, archFisico);
					rewrite(archLogico);
					cargarEmpleados(archLogico);
					close(archLogico);
				end;
				
			'2':begin	//ABRIR ARCHIVO EXISTENTE
					writeln('Ingrerse el nombre del archivo fisico');
					readln(archFisico);
					assign(archLogico, archFisico);
					reset(archLogico);
					menuBusqueda(opcion2);
					case opcion2 of 
						'1':	procesar1(archLogico);	//BUSCAR EMPELADO POR NOMBRE Y APELLIDO	
						'2':	procesar2(archLogico);	//LISTAR TODOS LOS EMPLEADOS	
						'3':	procesar3(archLogico);	//EMPLEADOS PROXIMOS A JUBILARSE
					end;
					close(archLogico);
				end;
			'3':begin	//AGREGAR N EMPLEADOS
					writeln('Ingrese el nombre del archivo fisico');
					readln(archFisico);
					assign(archLogico, archFisico);
					reset(archLogico);
					writeln('Indique cuantos empleados desea Ingresar');
					readln(x);
					cargarNEmpleados(archLogico, x);
					close(archLogico);			
				end;
			'4':begin	//MODIFICAR EDAD DE N EMPLEADOS
					writeln('Ingrese el nombre del archivo fisico');
					readln(archFisico);
					assign(archLogico, archFisico);
					reset(archLogico);
					writeln('Indique cuantos empleados desea modificar su edad');
					readln(y);
					modificarEdadNEmpleados(archLogico, y);
					close(archLogico);
				end;
			'5':begin	//EXPORTAR A .TXT
					writeln('Ingrese el nombre del archivo que desea exportar a .txt');
					readln(archFisico);
					assign(archLogico, archFisico);
					assign(txt, 'todos_empleados.txt');
					reset(archLogico);
					rewrite(txt);
					exportarTxt1(archLogico, txt);
					close(archLogico);
					close(txt);
				end;
			'6':begin	//EXPORTAR A UN .TXT EMPLEADOS CON DNI EN 00
					writeln('Ingrese el nombre del archivo que desea exportar sus empelados sin dni a un .txt');
					readln(archFisico);
					assign(archLogico, archFisico);
					assign(txt, 'faltaDniEmpleado.txt');
					reset(archLogico);
					rewrite(txt);
					exportarTxt2(archLogico, txt);
					close(archLogico);
					close(txt);
				end;
			else
				ejecutar:= false;
		end;
	end;
END.
