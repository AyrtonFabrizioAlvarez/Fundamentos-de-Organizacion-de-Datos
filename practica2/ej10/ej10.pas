program ej10;

const
    valorAlto = 999;

type
    empleado = record
        departamento:integer;
        division:integer;
        numero:integer;
        categoria:integer;
        cantHoras:integer;
    end;

    archMaestro = file of empleado;

    valorHora = record
        indice:integer;
        monto:integer;
    end;

    vectorHoras = array [1..15] of integer;

procedure generarVectorHoras(var V:vectorHoras);
var
    txt:text;
    H:valorHora;
begin
    assign(txt, 'valorHoras.txt');
    reset(txt);
    while(not eof(txt)) do
    begin
        read(txt, H.indice, H.monto);
        V[H.indice]:= H.monto;
    end;
end;

procedure generarMaestro(var maestro:archMaestro);
var
    E:empleado;
    txt:text;
begin
    assign(maestro, 'maestro.bin');
    assign(txt, 'maestro.txt');
    reset(txt);
    rewrite(maestro);
    while(not eof(txt)) do
    begin
        read(txt, E.departamento, E.division, E.numero, E.categoria, E.cantHoras);
        write(maestro, E);
    end;
    close(txt);
    close(maestro);
end;

procedure leer(var arch:archMaestro ; var E:empleado);
begin
    if (not eof(arch)) then
        read(arch, E)
    else
        E.departamento:= valorAlto;
end;

procedure obtenerDetalle(var maestro:archMaestro ; V:vectorHoras);
var
    E, actual:empleado;
    totalHorasDiv, montoDiv, totalHorasDep, montoDep:integer;
begin
    reset(maestro);
    leer(maestro, E);
    while(E.departamento <> valorAlto) do
    begin
        actual.departamento:= E.departamento;
        totalHorasDep:= 0;
        montoDep:= 0;
        writeln('Departamento: ', actual.departamento);
        writeln('');
        while(actual.departamento = E.departamento) do
        begin
            actual.division:= E.division;
            totalHorasDiv:= 0;
            montoDiv:= 0;
            writeln('Division: ', actual.division);
            while(actual.division = E.division) and (actual.departamento = E.departamento) do
            begin
                writeln('Numero: ', E.numero, ' Horas: ', E.cantHoras, ' Monto: ', (E.cantHoras*V[E.categoria]));
                totalHorasDiv:= totalHorasDiv + E.cantHoras;
                montoDiv:= montoDiv + (E.cantHoras*V[E.categoria]);
                leer(maestro, E);
            end;
            totalHorasDep:= totalHorasDep + totalHorasDiv;
            montoDep:= montoDep + montoDiv;
            writeln('');
            writeln('Total Horas Division: ', totalHorasDiv);
            writeln('Monto Total Division: ', montoDiv);
            writeln('');
        end;
        writeln('Total Horas Departamento: ', totalHorasDep);
        writeln('Monto Total Departamento: ', montoDep);
        writeln('');
    end;
end;

VAR
    valorHoras:vectorHoras;
    maestro:archMaestro;
BEGIN
    generarVectorHoras(valorHoras);
    generarMaestro(maestro);
    obtenerDetalle(maestro, valorHoras);
END.
{10. Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras
realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
departamento, luego por división, y por último, por número de empleados. Presentar en
pantalla un listado con el siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.}