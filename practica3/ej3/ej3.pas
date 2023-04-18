program ej3;

const
    valorAlto = 999;

Type
    novela = record
        codigo:integer;
        genero:integer;
        nombre:String;
        duracion:integer;
        director:String;
        precio:integer;
    end;

    archivo = file of novela;

procedure leerNovela(var N:novela);
begin
    writeln('Ingrese el codigo de novela');
    readln(N.codigo);
    if (N.codigo <> 0) then
    begin
        writeln('Ingrese el genero de la novela');
        readln(N.genero);
        writeln('Ingrese el nombre de la novela');
        readln(N.nombre);
        N.duracion:= random(101);
        writeln('Ingresee el nombre del director');
        readln(N.director);
        N.precio:= random(1001);
    end;
end;

procedure cargarArchivo(var arch:archivo);

var
    N:novela;
    nombreFisico:String;
begin
    writeln('Ingrese el nombre fisico que desea ponerle al archivo');
    readln(nombreFisico);
    assign(arch, nombreFisico+'.bin');
    rewrite(arch);
    N.codigo:= 0;
    N.genero:= 0;
    N.nombre:= 'cabecera';
    N.director:= 'cabecera';
    write(arch, N);
    leerNovela(N);
    while (N.codigo <> 0) do
    begin
        write(arch, N);
        leerNovela(N);
    end;
    close(arch);
end;

procedure menuBienvenida(var opcion:String);
begin
    writeln('--------------------');
    writeln('Ingrese la opcion deseada');
    writeln('a: Generar archivo de novelas');
    writeln('b: Abrir archivo existente');
    writeln('c: exportar a .txt todas las novelas');
    writeln('Ingrese cualquier otra tecla para salir');
    writeln('--------------------');
    readln(opcion);
end;

procedure menuApertura(var opcion:String);
begin
    writeln('--------------------');
    writeln('Ingrese la opcion deseada');
    writeln('1: Dar de alta una novela');
    writeln('2: Modificar datos de una novela');
    writeln('3: Dar de baja una novela');
    writeln('--------------------');
    readln(opcion);
end;

procedure hacerAlta(var arch:archivo);
var
    nuevo, aux:novela;
    pos:integer;
begin
    read(arch, aux);                //CABECERA
    leerNovela(nuevo);              //NOVELA A DAR DE ALTA
    if (aux.codigo = 0) then   //SI LA CABECERA ES 0 AGREGO AL FINAL
    begin
        seek(arch, fileSize(arch));
        write(arch, nuevo);
    end
    else
    begin
        pos:= aux.codigo * -1;     //MULTIPLICO LA CABECERA * -1
        seek(arch, pos);                //VOY A LA POSICION DONDE HABIA UN ELIMINADO
        read(arch, aux);           //LEO EL REGISTRO QEU ESTABA EN ESA POSICION SI HABIA OTRA POSICION
        seek(arch, pos);                //VUELVO A LA POSICION A DAR DE ALTA
        write(arch, nuevo);             //ESCRIBO EL NUEVO DATO EN LA POSICION DONDE ESTABA EL DATO ELIMINADO
        seek(arch, 0);                  //VUELVO A LA POSION INICIAL PARA MODIFICAR LA CABECERA
        write(arch, aux);
    end;
end;

procedure modificarNovela(var arch:archivo);
var
    N:novela;
    buscado:integer;
    modifique:boolean;
begin
    modifique:= false;
    writeln('Ingrese el codigo de novela que desea modificar');
    readln(buscado);
    while (not eof(arch)) and (not modifique) do
    begin
        read(arch, N);
        if (N.codigo = buscado) then
        begin
            writeln('Ingrese el genero de la novela');
            readln(N.genero);
            writeln('Ingrese el nombre de la novela');
            readln(N.nombre);
            N.duracion:= random(101);
            writeln('Ingresee el nombre del director');
            readln(N.director);
            N.precio:= random(1001);
            seek(arch, filePos(arch)-1);
            write(arch, N);
            modifique:= true;
        end;
    end;
end;

procedure hacerBaja(var arch:archivo);
var
    buscado, posEliminado:integer;
    elimine:boolean;
    cabecera, N:novela;
begin
    elimine:= false;
    writeln('Ingrese el codigo de novela que desea eliminar');
    readln(buscado);
    while (not eof(arch)) and (not elimine) do
    begin
        read(arch, N);
        if (N.codigo = buscado) then
        begin
            posEliminado:= filePos(arch)-1;     //POS TIENE EL INDICE DEL ELEMENTO A ELIMINAR
        seek(arch, 0);                          //EL PUNTERO ESTA AL PRINCIPIO DLE ARCHIVO
            read(arch, cabecera);               //OBTENGO LA CABECERA
            seek(arch, posEliminado);           //PUNTERO ESTA NUEVAMENTE EN LA POSICION A ELIMINAR
            write(arch, cabecera);              //ESCRIBO LO QUE TENIA EN LA CABECERA EN LA POSICION ELIMINADA
            seek(arch, 0);
            cabecera.codigo:= posEliminado*-1;
            write(arch, cabecera);
            elimine:= true;
        end;
    end;
end;

procedure exportarTxt(var arch:archivo);
var
    txt:text;
    N:novela;
    nombreFisico:String;
begin
    writeln('Ingrese el nombre fisico del archivo que exportar a .txt');
    readln(nombreFisico);
    assign(arch, nombreFisico+'.bin');
    assign(txt, 'reporte.txt');
    reset(arch);
    rewrite(txt);
    while (not eof(arch)) do
    begin
        read(arch, N);
        writeln(N.codigo, ' ', N.genero, ' ', N.nombre, ' ', N.director); //PARA LISTAR LO QUE TENGO EN EL .BIN
        writeln(txt, N.codigo, ' ', N.genero, ' ', N.nombre, ' ', N.duracion, ' ', N.director, ' ', N.precio);
    end;
    close(arch);
    close(txt);
end;

VAR
    arch:Archivo;
    opc1, opc2, nombreFisico:String;
    ejecutar:boolean;
BEGIN
    ejecutar:= true;
    while (ejecutar) do
    begin
        menuBienvenida(opc1);
        case (opc1) of
            'a':cargarArchivo(arch);
            'b':begin
                    writeln('Ingrese el nombre fisico del archivo que desea abrir');
                    readln(nombreFisico);
                    assign(arch, nombreFisico+'.bin');
                    reset(arch);
                    menuApertura(opc2);
                    case (opc2) of
                        '1':hacerAlta(arch);
                        '2':modificarNovela(arch);
                        '3':hacerBaja(arch);
                        else
                            writeln('La opcion ingresada no es una opcion posible')
                    end;
                    writeln('prueba');
                    close(arch);
                end;
            'c':exportarTxt(arch);
            else
                ejecutar:= false;
        end;
    end;

    
END.

{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:

i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indicac
que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.

iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}