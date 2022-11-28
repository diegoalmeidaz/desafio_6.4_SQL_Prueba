-- Author: Diego Almeida
-- Desafio 6.4: Prueba Modulo SQL


-- Begin sesion with the following command on the terminal (en mac: psql -U postgres -W)


-- Pregunta 1: 
-- Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las claves primarias, foráneas y tipos de datos. (1 punto)

CREATE DATABASE prueba_sql_diego_almeida_988;

--selection of the database

\c prueba_sql_diego_almeida_988;


-- Creacion Tabla Peliculas: 

CREATE TABLE peliculas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255),
  anno INTEGER
);

-- Creacion Tabla Tags

CREATE TABLE tags (id SERIAL PRIMARY KEY, tag VARCHAR(32));


-- Dado que la relacion expuesta en el modelo de datos de la prueba, corresponde a una relacion N a N, debemos crear una tabla intermedia, de manera de conectar las llaves primarias como foraneas en dicha tabla

-- Creacion Tabla Intermedia: 

CREATE TABLE pelicula_tags (
  pelicula_id BIGINT,
  tag_id BIGINT,
  FOREIGN KEY (pelicula_id) REFERENCES peliculas(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id)
);


-- Pregunta 2:
-- Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados. (1 punto)

--2.1: Peliculas

INSERT INTO peliculas (nombre, anno) VALUES
('Star Wars Episode IV - A new Hope', 1977),
('The Shindler List', 1993),
('IT', 2017),
('The Darkest Hour', 2017),
('Wedding Crashers', 2005);


-- Respaldo Carga peliculas:
 id |              nombre               | anno 
----+-----------------------------------+------
  1 | Star Wars Episode IV - A new Hope | 1977
  2 | The Shindler List                 | 1993
  3 | IT                                | 2017
  4 | The Darkest Hour                  | 2017
  5 | Wedding Crashers                  | 2005
(5 rows)






--2.2: tags

INSERT INTO tags (tag) VALUES 
('Science Fiction'),
('Drama'),
('Terror'),
('Historical'),
('Comedy');

-- Resplado Carga Tags:
 id |       tag       
----+-----------------
  1 | Science Fiction
  2 | Drama
  3 | Terror
  4 | Historical
  5 | Comedy
(5 rows)



--2.3 Tabla intermedia

INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES 
(1,1),
(1,2),
(1,3),
(2,1),
(2,4);


-- Respaldo carga pelicula_tags:

 pelicula_id | tag_id 
-------------+--------
           1 |      1
           1 |      2
           1 |      3
           2 |      1
           2 |      4
(5 rows)




-- Pregunta 3: 
-- Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0. (1 punto)

SELECT peliculas.nombre, COUNT(pelicula_tags.tag_id) FROM peliculas LEFT JOIN pelicula_tags ON peliculas.id = pelicula_tags.pelicula_id GROUP BY peliculas.nombre ORDER BY COUNT DESC;

-- Respaldo pregunta 3: 
              nombre               | count 
-----------------------------------+-------
 Star Wars Episode IV - A new Hope |     3
 The Shindler List                 |     2
 Wedding Crashers                  |     0
 The Darkest Hour                  |     0
 IT                                |     0
(5 rows)


-- Realizaremos la consulta en base a la variable peliculas.nombre, y en donde el resultado de la consulta sera un conteo de cuantos tags tiene cada pelicula. De manera de mostrar los elementos que no tienen un tag asignado, utilizaremos un Left join de manera que muestre la informacion de la tabla que no tiene datos, finalmente los agruparemos por cada pelicula y la ordenaremos de manera descendente para que las muestre en orden, de manera que el resultado visual de la respuesta sea mas facil de procesar.



-- Pregunta 4: 
-- Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de datos. (1 punto)

-- Seccion tabla preguntas

CREATE TABLE preguntas (
  id SERIAL PRIMARY KEY,
  pregunta VARCHAR(255),
  respuesta_correcta VARCHAR
);

-- Seccion tabla usuarios

CREATE TABLE usuarios(
  id SERIAL PRIMARY key,
  nombre VARCHAR(255),
  edad INTEGER
);

-- Seccion tabla respuestas

CREATE TABLE respuestas (
  id SERIAL PRIMARY KEY,
  respuesta VARCHAR(255),
  usuario_id BIGINT,
  pregunta_id BIGINT,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
  FOREIGN KEY (pregunta_id) REFERENCES preguntas (id)
);



-- Pregunta 5: 
-- Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas. (1 punto)
    -- Contestada correctamente significa que la respuesta indicada en la tabla respuestas es exactamente igual al texto indicado en la tabla de preguntas.

-- Seccion 5.1: introduccion de datos a tabla usuarios: 

INSERT INTO usuarios (nombre, edad) VALUES 
('Diego',36),
('Andres',35),
('Josefina',32),
('Javiera',30),
('Sofia',25);


-- Respaldo Carga tabla usuarios: 

 id |  nombre  | edad 
----+----------+------
  1 | Diego    |   36
  2 | Andres   |   35
  3 | Josefina |   32
  4 | Javiera  |   30
  5 | Sofia    |   25
(5 rows)


-- Seccion 5.2: introduccion de datos a tabla preguntas: 

INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('Cual fue el primer planeta destruido en su totalidad por la Estrella de la muerte', 'Alderan' ),
('Cual fue el primer producto que empezo a producir Shindler en su fabrica', 'Municiones' ),
('De que color es el globo del payaso de IT', 'Rojo' ),
('Que fumaba Winston Churchill', 'Habanos' ),
('En que tipo de eventos empezo a colarse Chazz', 'Funerales' );

-- Respaldo carga tabla preguntas: 
 id |                                     pregunta                                      | respuesta_correcta 
----+-----------------------------------------------------------------------------------+--------------------
  1 | Cual fue el primer planeta destruido en su totalidad por la Estrella de la muerte | Alderan
  2 | Cual fue el primer producto que empezo a producir Shindler en su fabrica          | Municiones
  3 | De que color es el globo del payaso de IT                                         | Rojo
  4 | Que fumaba Winston Churchill                                                      | Habanos
  5 | En que tipo de eventos empezo a colarse Chazz                                     | Funerales
(5 rows)



-- Seccion 5.3: introduccion de datos a tabla respuestas:

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES
('Alderan',1,1),
('Alderan',2,1),
('Municiones',3,2),
('Chalas',4,2),
('Guayaberas',5,2);


-- Respaldo carga tabla respuestas: 

 id | respuesta  | usuario_id | pregunta_id 
----+------------+------------+-------------
  1 | Alderan    |          1 |           1
  2 | Alderan    |          2 |           1
  3 | Municiones |          3 |           2
  4 | Chalas     |          4 |           2
  5 | Guayaberas |          5 |           2
(5 rows)





-- Pregunta 6: 
-- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta). (1 punto)


SELECT usuarios.nombre, COUNT(preguntas.respuesta_correcta) AS Respuestas_Correctas FROM preguntas RIGHT JOIN respuestas ON respuestas.respuesta = preguntas.respuesta_correcta JOIN usuarios ON usuarios.id = respuestas.usuario_id GROUP BY usuario_id, usuarios.nombre ORDER BY Respuestas_Correctas DESC;

-- respaldo respuesta 6:
  nombre  | respuestas_correctas 
----------+----------------------
 Diego    |                    1
 Andres   |                    1
 Josefina |                    1
 Sofia    |                    0
 Javiera  |                    0
(5 rows)


-- De la tabla usuarios obtendremos el orden de nuestra consulta inicial en terminos del mapeo de los nombres, sin embargo, debemos mapear desde preguntas, cual sera la respuesta corrrecta y haciendo un right join, podremos cruzar los datos de la asignacion de cada uno de los usuarios con la cantidad de respuestas correctas que obtuvieron cada uno de ellos. Terminamos por agrupar los datos por cada uno de los usuarios mapeados. 

-- Pregunta 7: 
-- Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta. (1 punto)


SELECT preguntas.pregunta, COUNT(respuestas.respuesta) as Respuestas_correctas FROM respuestas right JOIN preguntas on preguntas.respuesta_correcta = respuestas.respuesta GROUP by preguntas.pregunta ORDER BY preguntas.pregunta ASC;
  




-- Respaldo respuesta 7:

                                     pregunta                                      | respuestas_correctas 
-----------------------------------------------------------------------------------+----------------------
 Cual fue el primer planeta destruido en su totalidad por la Estrella de la muerte |                    2
 Cual fue el primer producto que empezo a producir Shindler en su fabrica          |                    1
 De que color es el globo del payaso de IT                                         |                    0
 En que tipo de eventos empezo a colarse Chazz                                     |                    0
 Que fumaba Winston Churchill                                                      |                    0
(5 rows)





-- La logica de la consulta es igual a la de arriba, sin embargo reorganizando los elementos a mostrar, de manera que ahora sean las preguntas; para ello trabajaremos con las tablas de preguntas y respuestas, en donde a traves del right join, podremos contar los elementos vacios que no cuentas con "respuestas correctas"



-- Pregunta 8: 
-- Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación. (1 punto)


ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_foreignkey, ADD FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;


DELETE FROM usuarios WHERE id = 1;

-- Respaldo respuesta 8: 
 id |  nombre  | edad 
----+----------+------
  2 | Andres   |   35
  3 | Josefina |   32
  4 | Javiera  |   30
  5 | Sofia    |   25
(4 rows)



-- Pregunta 9: 
-- Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos. (1 punto)

ALTER TABLE usuarios ADD CHECK (edad > 18); 

-- *: tratar de insertar un dato para probar que efectivamente esta corriendo la restriccion:

INSERT INTO usuarios (nombre, edad) VALUES ('Diego',17);
-- Checkeo que esta funcionando el restraint: 
ERROR:  new row for relation "usuarios" violates check constraint "usuarios_edad_check"
DETAIL:  Failing row contains (6, Diego, 17).
prueba_sql_diego_almeida_008=# 

-- Insertaremos nuevamente a Diego dentro de la Base para poder cargar su email: 

INSERT INTO usuarios (nombre, edad) VALUES('Diego', 36);                                     

 id |  nombre  | edad 
----+----------+------
  2 | Andres   |   35
  3 | Josefina |   32
  4 | Javiera  |   30
  5 | Sofia    |   25
  7 | Diego    |   36
(5 rows)


-- Pregunta 10: 
-- Altera la tabla existente de usuarios agregando el campo email con la restricción de único. (1 punto)

ALTER TABLE usuarios ADD email VARCHAR(50) UNIQUE;

-- Chequeo que condicion nueva esta funcionando: 
 id |  nombre  | edad | email 
----+----------+------+-------
  2 | Andres   |   35 | 
  3 | Josefina |   32 | 
  4 | Javiera  |   30 | 
  5 | Sofia    |   25 | 
  7 | Diego    |   36 | 


UPDATE usuarios SET email = 'diegoalmeidaz@gmail.com' WHERE id=7;

-- Chequeo que dato dummy esta tomando la nueva varibale: 
 id |  nombre  | edad |          email          
----+----------+------+-------------------------
  2 | Andres   |   35 | 
  3 | Josefina |   32 | 
  4 | Javiera  |   30 | 
  5 | Sofia    |   25 | 
  7 | Diego    |   36 | diegoalmeidaz@gmail.com
