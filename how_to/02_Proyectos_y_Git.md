# Guía 02: Gestión de Proyectos y Git

Atrás quedaron los días de perder la pista a tus proyectos interconectados. FORJA utiliza el módulo **10-git** para dotarte de herramientas profesionales de gestión de *workspaces* y versionado con *Magit*.

## Treemacs - Tu Explorador de Proyecto
Un explorador en formato de árbol, indispensable para interactuar visualmente con las carpetas.
- **Mostrar/Ocultar:** Presiona `F7` para abrir el explorador lateral a la izquierda. Presionalo nuevamente para contraerlo.
- **Navegación:** Una vez dentro de la ventanita izquierda, usa las flechas arriba/abajo.
  - `Enter` sobre una carpeta para expandirla o contraerla.
  - `Enter` sobre un archivo para abrir el archivo en tu pantalla central.
- **Alternar Proyectos:** Usa `C-c p p`. Podrás buscar entre una lista de cualquier repositorio local existente que hayas usado en FORJA previamente, y se abrirá al instante, en lugar de navegar manualmente entre subcarpetas.

## Projectile (Búsqueda Avanzada Ciega)
Cuando el proyecto pesa cientos de MBs o tiene cientos de archivos, navegar "click a click" es ineficiente.
- **Buscador Ciego (`C-c p f`):** Busca Archivo en Proyecto (Project File). Escribe una porción del nombre del archivo en el menú que aparecerá abajo y te filtrará toda coincidencia en toda la profundidad de rutas de la carpeta.
- **Grep: Busca texto en archivos (`C-c p s g`):** (Project Search Grep). ¿Alguien escribió "TODO: Arreglar el query 5"? ¿No sabés en qué documento?. Pulsa estas teclas, escribe "TODO: " e instantáneamente se desplegará una pantalla mostrando todo sitio del código donde esta línea resida para saltar ahí con un clic.

## Git Visual (Magit)
Considerado el "caballo de Troya" y motivo principal para amar el ecosistema de Emacs. Te permite usar GIT sin abrir una terminal oscura y sin miedo a romper cosas.

1. **Abrir Interfaz de Mando:** `C-x g` abre el "Git Status" completo en vivo.
2. **Unos cambios rápidos y el "Stage":**
   Dentro del panel, verás *Unstaged changes* (cambios no añadidos).
   - Toca `Tab` en un archivo para visualizar qué ocurrió (`Diff`).
   - Toca `s` (Stage) parado sobre un documento para pasarlo al área de indexado (`git add`).
   - Toca `u` (Unstage) para retirar tu documento si te equivocaste (`git restore --staged`).
3. **Commit Inteligente:**
   Presiona `c c`. Aparecerá un block de notas partido a la mitad. Escribes lo que alteraste, como "feat: Se arregló tal botón", y presionas `C-c C-c` para que se "firme" y se commitee el cambio en base a lo anterior (`git commit`).
4. **Subir remotamente (Push):**
   Ya todo guardado, presiona `P p` dentro del estatus de git, y la magia se encarga de mandarlo al Hub remoto de GitHub/GitLab.

---
[⬅️ Volver al README](../README.md)
