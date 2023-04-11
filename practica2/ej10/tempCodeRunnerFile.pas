 writeln('Numero: ', E.numero, ' Horas: ', E.cantHoras, ' Monto: ', (E.cantHoras*V[E.categoria]));
                totalHorasDiv:= totalHorasDiv + E.cantHoras;
                montoDiv:= montoDiv + (E.cantHoras*V[E.categoria]);
                leer(maestro, E);