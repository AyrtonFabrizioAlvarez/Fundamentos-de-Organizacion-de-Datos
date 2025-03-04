program ej5;

type
	celular = record
		codigo:integer;
		precio:integer;
		marca:String;
		stockDisp:integer;
		stockMin:integer;
		descripcion:String;
		nombre:String;
	end;
	
	archivo = file of celular;


procedure menuBienvenida(var opcion:char);
begin
	writeln('--------------------');
	writeln('1: Crear un .dat a partir de un .txt');
	writeln('2: Listar celulares que tienen stock debajo del minimo');
	writeln('3: Listar un celular segun una descripcion ingresada por teclado');
	writeln('4: Exportar un .dat de celulares a uno .txt');
	writeln('5: Agregar celular a un archivo .dat');
	writeln('6: Modificar el stock de un celular especifico');
	writeln('7: Crear un .txt con los celulares sin stock');
	writeln('--------------------');
	readln(opcion);
end;

procedure listarCelular(C:celular);
begin
	writeln('-');
	writeln('Codigo: ', C.codigo, '   Precio: ', C.precio, '   Marca: ', C.marca);
	writeln('Disponibles: ', C.stockDisp, '   StockMinimo: ', C.stockMin, '   Descripcion: ', C.descripcion);
	writeln('Nombre: ', C.nombre);
	writeln('-');
end;

procedure generarBinario(var arch:archivo ; var txt:Text);
var
	C:celular;
begin
	while (not eof(txt)) do
	begin
		with C do
		begin
			readln(txt, codigo, precio, marca);
			readln(txt, stockDisp, stockMin, descripcion);
			readln(txt, nombre);
		end;
		write(arch, C);
	end;
end;

procedure obtenerListaCompras(var arch:archivo);
var
	C:celular;
begin
	while(not eof(arch)) do
	begin
		read(arch, C);
		if (C.stockDisp < C.stockMin) then
			listarCelular(C);
	end;
end;

procedure buscarDescripcion(var arch:archivo ; buscado:String);
var
	C:celular;
begin
	while (not eof(arch)) do
	begin
		read(arch, C);
		if (' ' + buscado = C.descripcion) then
			listarCelular(C);
	end;
end;

procedure generarTxt(var arch:archivo ; var txt:text);
var
	C:celular;
begin
	while (not eof(arch)) do
	begin
		read(arch, C);
		writeln(txt, C.codigo, ' ', C.precio, ' ', C.marca);
		writeln(txt, C.stockDisp, ' ', C.stockMin, ' ', C.descripcion);
		writeln(txt, C.nombre);
	end;
end;

procedure buscarSiExiste(var arch:archivo ; buscado:string ; var existe:boolean);
var
	C:celular;
begin
	while (not eof(arch) and not existe) do
	begin
		read(arch, C);
		if (C.nombre = buscado) then
			existe:= true
	end;
end;

procedure agregarUnCelular(var arch:archivo);
var
	C:celular;
	existe:boolean;
begin
	reset(arch);
	existe:= false;
	writeln('Ingrese el nombre del celular');
	readln(C.nombre);
	buscarSiExiste(arch, C.nombre, existe);
	if (not existe) then
	begin
		writeln('Ingrese la marca');
		readln(C.marca);
		writeln('Ingrese la descripcion');
		readln(C.descripcion);
		writeln('Ingrese el stock disponible');
		readln(C.stockDisp);
		C.stockMin:= random(11);
		C.precio:= random(40000);
		C.codigo:= random(101);
		write(arch, C);
	end;
end;

procedure agregarCelulares(var arch:archivo ; x:integer);
var
	i:integer;
begin
	for i:=1 to x do
		agregarUnCelular(arch);
end;

procedure modificarStock(var arch:archivo ; buscado:string ; x:integer);
var
	C:celular;
	encontre:boolean;
begin
	encontre:= false;
	while (not eof(arch) and not encontre) do
	begin
		read(arch, C);
		if (C.nombre = buscado) then
		begin
			encontre:= true;
			C.stockDisp:= x;
			seek(arch, filepos(arch)-1);
			write(arch, C);
		end;
	end;
end;

procedure generarTxt2(var arch:archivo ; var txt:text);
var
	C:celular;
begin
	while(not eof(arch)) do
	begin
		read(arch, C);
		if (C.stockDisp = 0) then
		begin
			with C do
			begin
				writeln(txt, codigo, ' ', precio, ' ', marca);
				writeln(txt, stockDisp, ' ', stockMin, ' ', descripcion);
				writeln(txt, nombre);
			end;
		end;
	end;
end;

VAR
	arch:archivo;
	archFisico:String;
	txt:text;
	txtFisico:String;
	ejecutar:boolean;
	buscado:String;
	opcion:char;
	x:integer;
BEGIN
	ejecutar:= true;
	while (ejecutar) do
	begin
		menuBienvenida(opcion);
		case opcion of
			'1':begin
					writeln('Ingrese el nombre del archivo binario que desea generar ');
					readln(archFisico);
					Assign(arch, archFisico);
					writeln('Ingrese el nombre del txt del que desea obtener la informacion');
					readln(txtFisico);
					txtFisico:= txtFisico + '.txt';
					assign(txt, txtFisico);
					reset(txt);
					rewrite(arch);
					generarBinario(arch, txt);
					close(arch);
					close(txt);
				end;
			'2':begin
					writeln('Ingrese el nombre del archivo del que desea obtener la lista de compras');
					readln(archFisico);
					assign(arch, archFisico);
					reset(arch);
					obtenerListaCompras(arch);
					close(arch);
				end;
			'3':begin
					writeln('Ingrese la descripcion del celular que esta buscando');
					readln(buscado);
					writeln('Ingrese el nombre del archivo en que lo desea buscar');
					readln(archFisico);
					assign(arch, archFisico);
					reset(arch);
					buscarDescripcion(arch, buscado);
					close(arch);
				end;
			'4':begin
					writeln('Ingrese el nombre del archivo qeu desea pasar a .txt');
					readln(archFisico);
					assign(arch, archFisico);
					writeln('Ingrese el nombre que desea ponerle al archivo .txt');
					readln(txtFisico);
					txtFisico:= txtFisico + '.txt';
					assign(txt, txtFisico);
					reset(arch);
					rewrite(txt);
					generarTxt(arch, txt);
					close(arch);
					close(txt);
				end;
			'5':begin
					writeln('Ingrese el nombre del .dat donde desea agregar celulares');
					readln(archFisico);
					writeln('Ingrese la cantidad de celulares que desea agregar');
					readln(x);
					assign(arch, archFisico);
					reset(arch);
					agregarCelulares(arch, x);
					close(arch);
				end;
			'6':begin
					writeln('Ingrese el nombre del .dat para buscar un celular y mofidicar su stock');
					readln(archFisico);
					assign(arch, archFisico);
					writeln('Ingrese el nombre del celular que desea buscar');
					readln(buscado);
					writeln('Cual es el stock real actual');
					readln(x);
					reset(arch);
					modificarStock(arch, buscado, x);
					close(arch);
				end;
			'7':begin
					writeln('Ingrese el nombre del .dat dal que desea obtener un .txt con todos los celulares con stock en 0');
					readln(archFisico);
					assign(arch, archFisico);
					writeln('Ingrese el nombre que desea ponerle al archivo .txt');
					readln(txtFisico);
					txtFisico:= txtFisico + '.txt';
					assign(txt, txtFisico);
					reset(arch);
					rewrite(txt);
					generarTxt2(arch, txt);
					close(arch);
					close(txt);
				end;
			else
				ejecutar:= false;
		end;
	end;
END.
