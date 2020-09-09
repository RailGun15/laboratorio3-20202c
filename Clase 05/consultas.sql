USE MonkeyUniv
-- (1) Listado con nombre de usuario de todos los usuarios y sus respectivos nombres y apellidos.
	SELECT A.NombreUsuario,B.Nombres,B.Apellidos,B.Email
	FROM Usuarios A
		JOIN Datos_Personales B ON A.ID = B.ID
-- 2 Listado con apellidos, nombres, fecha de nacimiento y nombre del país de nacimiento. 
	SELECT A.Apellidos,A.Nombres,A.Nacimiento,B.Nombre
	FROM Datos_Personales A
		JOIN Paises B ON A.IDPais = B.ID;
-- (3) Listado con nombre de usuario, apellidos, nombres, email o celular de todos los usuarios que vivan en una domicilio cuyo nombre contenga el término 'Presidente' o 'General'. NOTA: Si no tiene email, obtener el celular.
	SELECT B.NombreUsuario,A.Apellidos,A.Nombres,ISNULL(Email,Celular)
	FROM Datos_Personales A
		JOIN Usuarios B ON A.ID = B.ID
	WHERE A.Domicilio LIKE '%Presidente%' OR Domicilio LIKE '%General%'
-- 4 Listado con nombre de usuario, apellidos, nombres, email o celular o domicilio como 'Información de contacto'.  NOTA: Si no tiene email, obtener el celular y si no posee celular obtener el domicilio.
	
	SELECT B.NombreUsuario,A.Apellidos,A.Nombres,
		CASE WHEN Email IS NULL THEN Celular
		WHEN Celular IS NULL THEN Domicilio
		ELSE Email
		END AS 'Informacion de contacto'
	FROM Datos_Personales A
		JOIN Usuarios B ON A.ID = B.ID
-- (5) Listado con apellido y nombres, nombre del curso y costo de la inscripción de todos los usuarios inscriptos a cursos.  NOTA: No deben figurar los usuarios que no se inscribieron a ningún curso.
	SELECT C.Apellidos,C.Nombres,D.Nombre,A.Costo
	FROM Inscripciones A
		JOIN Usuarios B ON A.IDUsuario = B.ID
		JOIN Datos_Personales C ON A.IDUsuario = B.ID
		JOIN Cursos D ON A.IDCurso = D.ID
-- 6 Listado con nombre de curso, nombre de usuario y mail de todos los inscriptos a cursos que se hayan estrenado en el año 2020.
	SELECT D.Nombre,B.NombreUsuario,C.Email
	FROM Inscripciones A
		JOIN Usuarios B ON A.IDUsuario = B.ID
		JOIN Datos_Personales C ON B.ID = C.ID
		JOIN Cursos D ON A.IDCurso = D.ID
	WHERE YEAR(A.Fecha) = 2020
-- 7 Listado con nombre de curso, nombre de usuario, apellidos y nombres, fecha de inscripción, costo de inscripción, fecha de pago e importe de pago. Sólo listar información de aquellos que hayan pagado.
	SELECT C.Nombre,U.NombreUsuario,D.Apellidos,D.Nombres,I.Fecha,I.Costo,P.Fecha,P.Importe
	FROM Inscripciones I
		JOIN Usuarios U ON I.IDUsuario = U.ID
		JOIN Datos_Personales D ON U.ID = D.ID
		JOIN Cursos C ON I.IDCurso = C.ID
		JOIN Pagos P ON I.ID = P.IDInscripcion

-- 8 Listado con nombre y apellidos, genero, fecha de nacimiento, mail, nombre del curso y fecha de certificación de todos aquellos usuarios que se hayan certificado.
	SELECT D.Nombres,D.Apellidos,D.Genero,D.Nacimiento,D.Email,C.Nombre,CERTI.Fecha
		FROM Datos_Personales D
			JOIN Inscripciones I ON D.ID = I.IDUsuario
			JOIN Cursos C ON I.IDCurso = C.ID
			JOIN Certificaciones CERTI ON I.ID = CERTI.IDInscripcion
-- 9 Listado de cursos con nombre, costo de cursado y certificación, costo total (cursado + certificación) con 10% de todos los cursos de nivel Principiante.
SELECT C.Nombre,C.CostoCurso,C.CostoCertificacion,N.Nombre,
		CASE WHEN N.Nombre = 'Principiante' THEN (C.CostoCurso + C.CostoCertificacion) * 0.90
		ELSE C.CostoCurso + C.CostoCertificacion
		END AS CostoTotal
FROM Cursos C
	JOIN Niveles N ON C.ID = N.ID

-- 10 Listado con nombre y apellido y mail de todos los instructores. Sin repetir.
SELECT DISTINCT D.Nombres,D.Apellidos,D.Email
FROM Datos_Personales D
	JOIN Usuarios U ON U.ID = D.ID
	JOIN Instructores_x_Curso IxC ON IxC.IDUsuario = U.ID

-- 11 Listado con nombre y apellido de todos los usuarios que hayan cursado algún curso cuya categoría sea 'Historia'.
SELECT DISTINCT D.Apellidos,D.Nombres,C.Nombre
FROM Datos_Personales D
	JOIN Usuarios U ON U.ID = D.ID
	JOIN Inscripciones I ON I.IDUsuario = U.ID
	JOIN Categorias_x_Curso CxC ON I.IDCurso = CxC.IDCurso
	JOIN Categorias C ON C.ID = CxC.IDCategoria
WHERE C.Nombre LIKE 'Historia'
-- (12) Listado con nombre de idioma, código de curso y código de tipo de idioma. Listar todos los idiomas indistintamente si no tiene cursos relacionados.
SELECT DISTINCT I.Nombre,IxC.IDCurso,IxC.IDTipo
FROM Idiomas I
LEFT JOIN Idiomas_x_Curso IxC ON I.ID = IxC.IDIdioma
LEFT JOIN Cursos C ON IxC.IDCurso = C.ID
LEFT JOIN TiposIdioma TI ON IxC.IDTipo = TI.ID

-- 13 Listado con nombre de idioma de todos los idiomas que no tienen cursos relacionados.
SELECT DISTINCT I.Nombre
FROM Idiomas I
LEFT JOIN Idiomas_x_Curso IxC ON I.ID = IxC.IDIdioma
LEFT JOIN Cursos C ON IxC.IDCurso = C.ID
WHERE C.ID IS NULL
-- 14 Listado con nombres de idioma que figuren como audio de algún curso. Sin repeticiones.
SELECT DISTINCT I.Nombre,TI.Nombre
FROM Idiomas I
JOIN Idiomas_x_Curso IxC ON I.ID = IxC.IDIdioma
JOIN Cursos C ON IxC.IDCurso = C.ID
JOIN TiposIdioma TI ON IxC.IDTipo = TI.ID
WHERE TI.Nombre LIKE 'Audio'

-- (15) Listado con nombres y apellidos de todos los usuarios y el nombre del país en el que nacieron. Listar todos los países indistintamente si no tiene usuarios relacionados.
SELECT DISTINCT D.Nombres,D.Apellidos,P.Nombre
FROM Paises P
LEFT JOIN Datos_Personales D ON P.ID = D.IDPais
-- 16 Listado con nombre de curso, fecha de estreno y nombres de usuario de todos los inscriptos. Listar todos los nombres de usuario indistintamente si no se inscribieron a ningún curso.
SELECT DISTINCT C.Nombre,C.Estreno,U.NombreUsuario
FROM Usuarios U
LEFT JOIN Inscripciones I ON I.IDUsuario = U.ID
LEFT JOIN Cursos C ON I.IDCurso = C.ID
-- 17 Listado con nombre de usuario, apellido, nombres, género, fecha de nacimiento y mail de todos los usuarios que no cursaron ningún curso.
SELECT U.NombreUsuario,D.Nombres,D.Apellidos,D.Genero,D.Nacimiento,D.Email,I.IDCurso
FROM Usuarios U
JOIN Datos_Personales D ON D.ID = U.ID
LEFT JOIN Inscripciones I ON I.IDUsuario = U.ID
WHERE I.IDCurso IS NULL
-- 18 Listado con nombre y apellido, nombre del curso, puntaje otorgado y texto de la reseña. Sólo de aquellos usuarios que hayan realizado una reseña inapropiada.
SELECT D.Nombres,D.Apellidos,C.Nombre,R.Puntaje,R.Observaciones,R.Inapropiada
FROM Inscripciones I
JOIN Usuarios U ON I.IDUsuario = U.ID
JOIN Datos_Personales D ON U.ID = D.ID
JOIN Cursos C ON I.IDCurso = C.ID
JOIN Reseñas R ON I.ID = R.IDInscripcion
WHERE R.Inapropiada = 1
-- 19 Listado con nombre del curso, costo de cursado, costo de certificación, nombre del idioma y nombre del tipo de idioma de todos los cursos cuya fecha de estreno haya sido antes del año actual. Ordenado por nombre del curso y luego por nombre de tipo de idioma. Ambos ascendentemente.
SELECT C.Nombre,C.CostoCurso,C.CostoCertificacion,I.Nombre,TI.Nombre
FROM Cursos C
JOIN Idiomas_x_Curso IxC ON IxC.IDCurso = C.ID
JOIN Idiomas I ON I.ID = IxC.IDIdioma
JOIN TiposIdioma TI ON IxC.IDTipo = TI.ID
WHERE YEAR(C.Estreno) < 2020
ORDER BY C.Nombre ASC, TI.Nombre ASC
-- 20 Listado con nombre del curso y todos los importes de los pagos relacionados.
SELECT C.Nombre,P.Importe
FROM Inscripciones I
JOIN Cursos C ON C.ID = I.IDCurso
JOIN Pagos P ON P.IDInscripcion = I.ID
ORDER BY C.Nombre
-- 21 Listado con nombre de curso, costo de cursado y una leyenda que indique "Costoso" si el costo de cursado es mayor a $ 15000, "Accesible" si el costo de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y $2499 y "Gratis" si el costo es $0.
SELECT C.Nombre,C.CostoCurso,
	CASE WHEN C.CostoCurso > 15000 THEN 'Costoso' 
	WHEN C.CostoCurso BETWEEN 2500 AND 15000 THEN 'Accesible'
	WHEN C.CostoCurso BETWEEN 1 AND 2499 THEN 'Barato'
	WHEN C.CostoCurso = 0 THEN 'Gratis'
	END AS 'Leyenda'
FROM Cursos C