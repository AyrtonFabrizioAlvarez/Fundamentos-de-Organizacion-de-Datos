program generadorMaestro;

type
  datoMaestro = record
    cod: integer;
    nombre: string; 
    descripcion:string;
    modelo: string;
    marca: string;
    stock: integer;
  end;

var
  archivoTexto: text;
  archivoBinario: file of datoMaestro;
  registro: datoMaestro;

begin
  // Abrir archivo de texto en modo lectura
  assign(archivoTexto, 'maestro.txt');
  reset(archivoTexto);
  
  // Crear archivo binario en modo escritura
  assign(archivoBinario, 'maestro.bin');
  rewrite(archivoBinario);
  
  // Leer datos del archivo de texto y escribirlos en el archivo binario
  while not eof(archivoTexto) do
  begin
    // Leer datos del archivo de texto
    readln(archivoTexto, registro.cod,registro.nombre);
    readln(archivoTexto, registro.descripcion);
    readln(archivoTexto, registro.modelo);
    readln(archivoTexto, registro.marca);
    readln(archivoTexto, registro.stock);
    
    // Escribir datos en el archivo binario
    write(archivoBinario, registro);
  end;
  
  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);
  
  writeln('Datos convertidos a binario exitosamente.');
end.
