program ej3;

const
    valorAlto = 999;
    dimF = 30;
Type
    producto = record
        codigo:integer;
        nombre:String;
        descripcion:String;
        stockDisp:integer;
        stockMin:integer;
        precio:integer;
    end;

    productoDet = record
        codigo:integer;
        vendidas:integer;
    end;

    archMaestro = file of producto;
    archDetalle = file of productoDet;

    vectorArchDet = array [1..dimF] of archDetalle;
    vectorRegDet = array [1..dimF] of productoDet;

procedure leer(var arch:archDetalle ; var P:productoDet);
begin
    if (not eof(arch)) then
        read(arch, P)
    else
        P.codigo:= valorAlto;
end;

procedure generarMaestroDesdeTxt(var maestro:archMaestro);
var
    P:producto;
    txt:text;
begin
    assign(txt, 'maestro.txt');
    assign(maestro, 'maestro.dat');
    reset(txt);
    rewrite(maestro);
    while (not eof(txt)) do
    begin
        readln(txt, P.codigo, P.nombre);
        readln(txt, P.descripcion);
        readln(txt, P.stockDisp, P.stockMin, P.precio);
        write(maestro, P);
    end;
    close(maestro);
    close(txt);
end;

procedure generarDetallesDesdeTxt(var vArch:vectorArchDet);
var
    P:productoDet;
    txt:text;
    i:integer;
    num:String;
begin
    assign(txt, 'detalle.txt');
    for i:=1 to dimF do
    begin
        Str(i, num);
        assign(vArch[i], 'detalle'+num+'.dat');
        reset(txt);
        rewrite(vArch[i]);
        while (not eof(txt)) do
        begin
            readln(txt, P.codigo, P.vendidas);
            write(vArch[i], P); 
        end;
        close(vArch[i]);
    end;
    close(txt);
end;

procedure asignarYLeerVectores(var vArch:vectorArchDet ; var vReg:vectorRegDet);
var
    i:integer;
    num:String;
begin
    for i:=1 to dimF do
    begin
        Str(i, num);
        assign(vArch[i], 'detalle'+num+'.dat');
        reset(vArch[i]);
        leer(vArch[i], vReg[i]);
    end;
end;

procedure minimo(var vArch:vectorArchDet ; var vReg:vectorRegDet ; var min:productoDet);
var
    i, pos:integer;
begin
    min.codigo:= valorAlto;
    pos:= -1;
    for i:=1 to dimF do
    begin
        if (vReg[i].codigo < min.codigo) then
        begin
            min:= vReg[i];
            pos:= i;
        end;
    end;
    if (min.codigo <> valorAlto) then
        leer(vArch[pos], vReg[pos]);
end;

procedure actualizarMaestro(var maestro:archMaestro ; var vArch:vectorArchDet ; var vReg:vectorRegDet);
var
    pMaestro:producto;
    min:productoDet;
    i:integer;
begin
    asignarYLeerVectores(vArch, vReg);
    reset(maestro);
    minimo(vArch, vReg, min);
    while(min.codigo <> valorAlto) do
    begin
        read(maestro, pMaestro);
        while(pMaestro.codigo <> min.codigo) do
            read(maestro, pMaestro);
        while(pMaestro.codigo = min.codigo) do
        begin
            pMaestro.stockDisp:= pMaestro.stockDisp - min.vendidas;
            minimo(vArch, vReg, min)
        end;
        seek(maestro, filePos(maestro)-1);
        write(maestro, pMaestro);
    end;
    close(maestro);
    for i:=1 to dimF do
        close(vArch[i]);
end;

procedure mostrarMaestro(var maestro:archMaestro);
var
    P:producto;
begin
    while(not eof(maestro)) do
    begin
        read(maestro, P);
        writeln('codigo: ', P.codigo, ' nombre: ', P.nombre);
        writeln('descripcion: ', P.descripcion);
        writeln('stockDisponible: ', P.stockDisp, ' stockMinimo: ', P.stockMin, ' precio: ', P.precio);
        writeln('');
    end;
    close(maestro);
end;

procedure mostrarDetalle(var detalle:archDetalle);
var
    P:productoDet;
begin
    assign(detalle, 'detalle1.dat');
    reset(detalle);
    while(not eof(detalle)) do
    begin
        read(detalle, P);
        writeln('codigo: ', P.codigo, ' vendidas: ', P.vendidas);
    end;
    close(detalle);
end;

procedure generarTxt(var maestro:archMaestro);
var
    P:producto;
    txt:Text;
begin
    reset(maestro);
    assign(txt, 'paraComprar.txt');
    rewrite(txt);
    while (not eof(maestro)) do
    begin
        read(maestro, P);
        if (P.stockDisp < P.stockMin) then
        begin
            writeln(txt, P.nombre);
            writeln(txt, P.descripcion);
            writeln(txt, P.stockDisp, ' ', P.precio);
        end;
    end;
    close(maestro);
    close(txt);
end;

VAR
    vArch:vectorArchDet;
    vReg:vectorRegDet;
    maestro:archMaestro;
BEGIN
    generarMaestroDesdeTxt(maestro);
    generarDetallesDesdeTxt(vArch);
    reset(maestro);
    mostrarMaestro(maestro);
    actualizarMaestro(maestro, vArch, vReg);
    reset(maestro);
    mostrarMaestro(maestro);
    generarTxt(maestro);
END.