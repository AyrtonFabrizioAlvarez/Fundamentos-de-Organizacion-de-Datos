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