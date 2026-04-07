# Guía 07: Multiusuario y Sincronización en la Nube

En sistemas escolares o máquinas compartidas, que alguien toque tu proyecto y te rompa todo es letal para el tiempo educativo en el laboratorio. FORJA tiene el módulo **49-multiusuario** para segmentar estudiantes y dotar de persistencia universal usando Rclone para Drive, Pendrives o de red.

## El Menú Maestro ("U")
Todas las herramientas multiusuario se acceden con la tecla unificada `C-c U`. Esto despliega opciones en base al estado del alumno o usuario.

**Cambiar usuario actual (`C-c U c`):** 
Usa esta opción si la PC es compartida para identificarte. Lo que trabajes pertenecerá a este workspace de forma virtualizada antes que el próximo alumno se siente frente al mismo teclado.

## Estatus General (`C-c U t`)
Muestra en línea directa quién está "logeado", si detecta un Pendrive oficial conectado al puerto, y si la configuración con Google Drive se efectuó correctamente mediante comandos RClone de fondo.

## Google Drive (Sincronización Bidireccional Rápida)
No necesitas ir arrastrando archivos del explorador de Windows al Drive web.  
`C-c U D` -> Dispara la configuración inicial (se hace 1 vez). Se solicitará crear el servicio.

- **El ciclo día a día es sumamente veloz:**
  1. Inicias tu clase -> **Descargar (`C-c U S`)** mayúscula: Sincroniza desde el Google Drive y empuja los proyectos a la PC frente tuyo. Bajas tu "mochila" del Drive al dispositivo secundario.
  2. Modificas, Trabajas, Estudias, Compilas. (Termina la hora).
  3. Vas a Cerrar Sesión -> **Subir (`C-c U s`)** minúscula: En un minuto comprime los diferenciados, los cifra al Drive y quedás totalmente respaldado. Ya podés irte y en la PC de tu casa volver al paso 1. (Funciona desde Android también).

## Pendrives y Respaldo Local Exportado (`.tar.gz`)
Internet no siempre es estable. Los flujos manuales de Back Up nunca pasarán de moda si no tenes Drive corriendo o un alumno se niega a abrir cloud.

- **Respaldar en Pendrive (`C-c U u`):** (USB Backup). Con la menor latencia, detecta el UUID de tu lápiz de montaje del laboratorio USB y avienta directamente una estela sincronizada del Home estudiantil tuyo allí de una vez. Y para restaurarlo en caso de daño se hace con `r`.
- **Exportar Respaldo al Escritorio (`C-c U e`):** (Export Compression). Comprime en un solo `.tar.gz` todo tu progreso local limpio. Ideal para llevar a la casa e Importarlo (`C-c U i`) al entorno virgen en un parpadeo.

---
[⬅️ Volver al README](../README.md)
