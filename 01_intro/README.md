# FinGestor

## Sistema Integral de Gestión Académica para Pagos, Calificaciones y Alumnos.

## Problemas a resolver

|Problema|Consecuencia|Solucion|
|---|---|---|
|Riesgo de Pérdida Total|Un fallo de disco duro, un archivo corrupto o un virus puede significar la pérdida irreversible de todo el historial académico y financiero.|Rutinas de Backup|
|Ineficiencia Operacional|El personal administrativo pierde horas filtrando, cruzando y actualizando datos entre múltiples hojas de cálculo.|Automatizacion de procesos|
|Falta de Seguridad y Acceso|Cualquier persona con el archivo puede ver/modificar datos sensibles (notas, información financiera) sin control ni registro.|Sistema de Roles y Permisos |
|Integridad y Errores de Datos|Cálculos de promedios o saldos financieros erróneos; inconsistencia en la información reportada a padres y administradores.|Base de Datos en postgresql, única fuente de verdad con validaciones automáticas para pagos, notas y datos de estudiantes.|

## Usuarios

- Administradores
- Docentes
- Consultores
- Contabilidad

## Objetivos Generales

1. Reduccion de errores administrativos
1. Transparencia Academica
1. Reduccion de tiempo
1. Evitar la redundancia

## Alcances

- Gestion de datos
- Modulo de calificaciones
- Modulo de pagos
- Autenticacion

## Funcionalidades Esperadas (Historias de usuario)

|Funcioalidad|Descripcion|
|---|---|
|Gestion de cursos|CRUD (Crear, Leer, Actualizar, Eliminar) de cursos y asignaturas, y asignación de profesores.|
|Gestión de Roles y Permisos|El Administrador puede asignar y revocar roles a todos los usuarios.|
|Registro y Edición de Pagos|Registrar montos, fechas y conceptos de pago para cada estudiante.|
|Ingreso y Edición de Calificaciones|El docente ingresa notas por actividad o examen para los estudiantes de sus cursos asignados.|
|Visualización del Listado de Alumnos|El docente puede ver una lista de todos los estudiantes|
|Consulta de Calificaciones|Calificaciones	Ver las notas finales y el promedio, sin capacidad de edición.|
|Consulta de Estado de solvencia|Ver el historial de pagos realizados y los montos pendientes.|

