program ej7;


type
	novela = record
		codigo:integer;
		precio:integer;
		genero:String;
		nombre:String;
	end;
	
	archivo = file of novela;
	
procedure menuBienvenida(var opcion:char);
begin
	writeln('--------------------');
	writeln('1: Crear un .dat a partir de un .txt');
	writeln('2: Agregar novelas a un .dat');
	writeln('3: Modificar una novela en un .dat');
	writeln('4: Pasar de .dat a .txt');	//LO AGREGO PARA PODER VER LOS RESULTADOS FINALES DEL PROGRAMA
	writeln('--------------------');
	readln(opcion);
end;

procedure generarBinario(var arch:archivo ; var txt:text);
var
	N:novela;
begin
	while(not eof(txt)) do
	begin
		with N do
		begin
			readln(txt, codigo, precio, genero);
			readln(txt, nombre);
		end;
		write(arch, N);
	end;
end;

procedure existeNovela(var arch:archivo ; var existe:boolean ; buscado:integer);
var
	N:novela;
begin
	while (not eof(arch) and not existe ) do
	begin
		read(arch, N);
		if (N.codigo = buscado) then
			existe:= true;
	end;
end;

procedure agregarUnaNovela(var arch:archivo);
var
	N:novela;
	existe:boolean;
begin
	reset(arch);
	existe:= false;
	writeln('Ingrese el codigo de la novela');
	readln(N.codigo);
	writeln('antes de ver si existe');
	existeNovela(arch, existe, N.codigo);
	writeln('despues de ver si existe');
	if (not existe)then
	begin
		N.precio:= random(2001);
		writeln('Ingrese el genero de la novela');
		readln(N.genero);
		writeln('Ingrese el nombre de la novela');
		readln(N.nombre);
		write(arch, N);
	end;
end;

procedure agregarNovelas(var arch:archivo ; x:integer);
var
	i:integer;
begin
	for i:=1 to x do
		agregarUnaNovela(arch);
end;

procedure modificarNovela(var arch:archivo ; buscado, precioActualizado:integer);
var
	N:novela;
begin
	while (not eof(arch)) do
	begin
		read(arch, N);
		if (N.codigo = buscado) then
		begin
			N.precio:= precioActualizado;
			seek(arch, filepos(arch)-1);
			write(arch, N);
		end;
	end;
end;

procedure generarTxt(var arch:archivo ; var txt:text);
var
	N:novela;
begin
	while (not eof(arch)) do
	begin
		read(arch, N);
		with N do
		begin
			writeln(txt, codigo, ' ', precio, ' ', genero);
			writeln(txt, nombre)
		end;
	end;
end;

VAR
	arch:archivo;
	archFisico:String;
	txt:text;
	txtFisico:String;
	x, buscado, precioActualizado:integer;
	ejecutar:boolean;
	opcion:char;
BEGIN
	ejecutar:= true;
	while (ejecutar) do
	begin
		menuBienvenida(opcion);
		case opcion of
			'1':begin
					writeln('Ingrese el nombre del .dat a crear');
					readln(archFisico);
					writeln('Ingrese el nombre del .txt que desea pasar a .dat');
					readln(txtFisico);
					assign(arch, archFisico);
					assign(txt, txtFisico);
					reset(txt);
					rewrite(arch);
					generarBinario(arch, txt);
					close(arch);
					close(txt);
				end;
			'2':begin
					writeln('Ingrese el nombre del .dat donde desea agregar la/s novela/s');
					readln(archFisico);
					writeln('Ingrese la cantidad de novelas que desea agregar');
					readln(x);
					assign(arch, archFisico);
					agregarNovelas(arch, x);
					close(arch);
				end;
			'3':begin
					writeln('Ingrese el nombre del .dat donde quiere modificar una novela');
					readln(archFisico);
					writeln('Ingrese el codigo de novela que desea modificar');
					readln(buscado);
					writeln('Ingrese el precio actualizado de la obra');
					readln(precioActualizado);
					assign(arch, archFisico);
					reset(arch);
					modificarNovela(arch, buscado, precioActualizado);
					close(arch);
				end;
			'4':begin
					writeln('Ingrese el nombre del .dat que desea pasar a .txt');
					readln(archFisico);
					writeln('Ingrese el nombre que desea ponerle al .txt que se generara');
					readln(txtFisico);
					assign(arch, archFisico);
					assign(txt, txtFisico);
					reset(arch);
					rewrite(txt);
					generarTxt(arch, txt);
					close(arch);
					close(txt);
				end;
			else
				ejecutar:= false;
		end;
	end;
END.
