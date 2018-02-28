/* declaramos un cursor */
BEGIN;
DECLARE order_cur CURSOR
FOR SELECT * FROM orders;

/* Usamos un cursor */
FETCH FROM order_cur;

/* Recuperamos las 4 primeras filas almacenadas en el resultset. 
   La direccion no es necesaria indicarla, FORWARD es por defecto. */
FETCH 4 FROM order_cur;

/* Cerrar Cursor */
CLOSE order_cur;
