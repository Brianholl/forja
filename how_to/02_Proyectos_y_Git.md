# Guia 02: Gestion de Proyectos y Git

> Aprende a navegar proyectos grandes, buscar archivos y texto al instante, y dominar Git de forma visual con Magit.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Navegar por la estructura de un proyecto usando Treemacs (explorador visual)
- Buscar archivos y texto dentro de proyectos grandes con Projectile
- Hacer commits, ver diffs y subir cambios a GitHub/GitLab usando Magit
- Trabajar con branches (ramas) de forma visual

## Prerequisitos

- Haber completado la [Guia 01: Core y Entorno](01_Core_y_Entorno.md)
- Tener Git instalado (`git --version` en terminal)
- Opcional: tener una cuenta de GitHub o GitLab para practicar push

---

## 1. Treemacs: El Explorador Visual de Archivos

Treemacs es el panel lateral izquierdo que muestra la estructura de carpetas de tu proyecto, similar al explorador de archivos de VS Code.

### Abrir y cerrar Treemacs

Presiona `F7` para alternar (abrir/cerrar) el explorador.

### Navegacion dentro de Treemacs

Una vez que el panel esta abierto y tu cursor esta dentro de el:

| Tecla | Accion |
| :---: | :--- |
| `↑` / `↓` | Moverse entre archivos y carpetas |
| `Enter` | Sobre una carpeta: expandir/contraer. Sobre un archivo: abrirlo |
| `Tab` | Expandir/contraer carpeta (sin abrirla) |
| `q` | Cerrar Treemacs |
| `g` | Refrescar el arbol (si agregaste archivos desde terminal) |

### Cambiar entre el explorador y el editor

- Para ir del editor al explorador: `F7` o haz clic en el panel izquierdo
- Para volver al editor: haz clic en el area del codigo, o usa `C-x o` (Other window) para saltar entre paneles

> **Tip:** Treemacs solo muestra las carpetas del proyecto actual. Si necesitas cambiar de proyecto, usa `C-c p p` (ver seccion siguiente).

## 2. Projectile: Busqueda Avanzada en Proyectos

Cuando un proyecto tiene decenas o cientos de archivos, navegar carpeta por carpeta es ineficiente. Projectile te permite buscar de forma instantanea.

### Buscar archivo por nombre (`C-c p f`)

"Project File" — busca archivos por nombre en todo el proyecto:

1. Presiona `C-c p f`
2. Escribe parte del nombre del archivo (por ejemplo, `auth`)
3. Se muestran todas las coincidencias en tiempo real:
   ```
   src/auth/login.go
   src/auth/middleware.go
   tests/auth_test.go
   ```
4. Selecciona con las flechas y `Enter`

No necesitas escribir la ruta completa. Con escribir `mid` ya te filtra `middleware.go`.

### Buscar texto en archivos (`C-c p s g`)

"Project Search Grep" — busca una cadena de texto en **todos** los archivos del proyecto:

1. Presiona `C-c p s g`
2. Escribe el texto a buscar (por ejemplo, `TODO: `)
3. Aparece una lista con cada archivo y linea donde aparece ese texto:
   ```
   src/handlers.go:45:  // TODO: Validar input
   src/database.go:120: // TODO: Agregar indice
   tests/api_test.go:8: // TODO: Agregar test de error
   ```
4. Presiona `Enter` en cualquier resultado para saltar directamente a esa linea

### Cambiar de proyecto (`C-c p p`)

Si trabajas en multiples proyectos:

1. Presiona `C-c p p`
2. Se muestra una lista de todos los proyectos que hayas abierto antes
3. Selecciona uno y presiona `Enter`
4. Treemacs y todos los buffers se actualizan al nuevo proyecto

> **Que es un "proyecto" para Projectile?** Cualquier carpeta que tenga un `.git/`, `.projectile`, `package.json`, `go.mod`, `Cargo.toml` o similar. Los generadores de FORJA (`C-c n`) crean todo esto automaticamente.

## 3. Magit: Git Visual

Magit es probablemente la herramienta mas poderosa de todo el ecosistema Emacs. Te permite hacer **todo** lo que harias con Git en la terminal, pero de forma visual e interactiva.

### Abrir el panel de Git Status

Presiona `C-x g`. Se abre una ventana mostrando el estado completo del repositorio:

```
Head:     main  feat: agregar endpoint de login
Merge:    origin/main

Unstaged changes (2)
modified   src/handlers.go
modified   src/database.go

Untracked files (1)
src/auth/middleware.go
```

### El flujo basico: Stage -> Commit -> Push

#### Paso 1: Ver que cambio (Diff)

Dentro del panel de Magit (`C-x g`):
1. Posiciona el cursor sobre un archivo en "Unstaged changes"
2. Presiona `Tab` para ver el diff (que lineas cambiaron)
3. Las lineas verdes son agregados, las rojas son eliminados
4. Presiona `Tab` de nuevo para contraer el diff

#### Paso 2: Agregar cambios al Stage (git add)

| Tecla | Accion |
| :---: | :--- |
| `s` | **Stage** el archivo bajo el cursor (equivale a `git add archivo`) |
| `u` | **Unstage** el archivo (equivale a `git restore --staged archivo`) |
| `S` | Stage **todos** los archivos (equivale a `git add -A`) |

Despues de presionar `s`, el archivo se mueve de "Unstaged" a "Staged".

#### Paso 3: Hacer el commit (git commit)

1. Presiona `c c` (la letra "c" dos veces)
2. Se abre un area de texto partida: arriba el diff de lo que vas a commitear, abajo el espacio para escribir tu mensaje
3. Escribe un mensaje descriptivo siguiendo el formato del proyecto:
   ```
   feat: agregar validacion de email en registro
   ```
4. Presiona `C-c C-c` para confirmar el commit

> **Formato de commits en FORJA:** Usamos conventional commits en español:
> - `feat:` para funcionalidades nuevas
> - `fix:` para correcciones de bugs
> - `refactor:` para reestructuracion sin cambios funcionales
> - `docs:` para documentacion
> - `chore:` para tareas de mantenimiento

#### Paso 4: Subir al remoto (git push)

1. Dentro de Magit (`C-x g`), presiona `P` (Push, mayuscula)
2. Aparece un submenu de opciones de push
3. Presiona `p` (push to remote)
4. Git sube tus cambios a GitHub/GitLab

**Resumen del flujo completo:**
```
C-x g        → Abrir Magit (ver estado)
Tab          → Ver diff de un archivo
s            → Stage (agregar al commit)
c c          → Iniciar commit + escribir mensaje
C-c C-c      → Confirmar commit
P p          → Push al remoto
```

### Trabajar con Branches (Ramas)

Magit facilita el trabajo con ramas:

| Tecla (dentro de Magit) | Accion |
| :---: | :--- |
| `b b` | **Checkout** — cambiar a otra rama existente |
| `b c` | **Create** — crear una rama nueva y cambiar a ella |
| `b d` | **Delete** — eliminar una rama |

#### Ejemplo: Crear una rama para una nueva funcionalidad

1. `C-x g` para abrir Magit
2. `b c` para crear rama nueva
3. Selecciona la rama base (generalmente `main`)
4. Escribe el nombre: `feat/login`
5. Trabaja normalmente (edita, `s`, `c c`, etc.)
6. Cuando termines, `P p` para subir la rama

### Resolver Conflictos

Si al hacer pull o merge hay conflictos:

1. Magit marca los archivos con conflicto
2. Abre el archivo conflictivo — veras marcadores como:
   ```
   <<<<<<< HEAD
   Tu version del codigo
   =======
   La version remota del codigo
   >>>>>>> origin/main
   ```
3. Edita el archivo manualmente: borra los marcadores y deja el codigo correcto
4. Guarda con `C-x C-s`
5. En Magit, presiona `s` sobre el archivo resuelto
6. Haz un commit normal (`c c`)

### Ver historial de commits

Dentro de Magit (`C-x g`):
- Presiona `l l` (log log) para ver el historial de commits
- Navega con las flechas
- Presiona `Enter` en un commit para ver su contenido completo
- Presiona `q` para cerrar el log

---

## Ejercicio Practico: Tu Primer Flujo Git Completo

1. **Genera un proyecto:** `C-c n` → `G` (Go generico) → nombre: `practica-git`
2. **Abre el proyecto:** El generador lo abre automaticamente
3. **Abre Magit:** `C-x g` — deberas ver el commit inicial creado por el generador
4. **Modifica un archivo:** Abre `main.go`, agrega una linea como:
   ```go
   fmt.Println("Este es mi cambio para practicar Git")
   ```
5. **Guarda:** `C-x C-s`
6. **Revisa el estado:** `C-x g` — veras `main.go` en "Unstaged changes"
7. **Ve el diff:** `Tab` sobre `main.go` — veras tu linea nueva en verde
8. **Stage:** `s` sobre `main.go`
9. **Commit:** `c c`, escribe `feat: agregar mensaje de prueba`, luego `C-c C-c`
10. **Verifica:** En Magit veras tu nuevo commit en el historial

Si llegaste hasta aqui sin errores, ya sabes manejar Git de forma visual.

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| `C-x g` muestra "Not a git repository" | La carpeta no tiene `.git/` | Usa un proyecto generado por FORJA (`C-c n`) o inicializa con `git init` en terminal |
| El push falla con "Authentication failed" | No tienes configuradas las credenciales de GitHub | Configura SSH key o token: `git config --global credential.helper store` |
| `C-c p f` no encuentra archivos | Projectile no reconoce el proyecto | Asegurate de que la carpeta tenga `.git/` o `.projectile` |
| El diff no muestra cambios | El archivo no esta guardado | Guarda con `C-x C-s` antes de revisar en Magit |
| Treemacs muestra carpeta equivocada | El proyecto activo es otro | Usa `C-c p p` para cambiar al proyecto correcto |

## Resumen de Atajos de esta Guia

```
F7           → Abrir/cerrar Treemacs (explorador)
C-c p f      → Buscar archivo por nombre en el proyecto
C-c p s g    → Buscar texto en todos los archivos del proyecto
C-c p p      → Cambiar de proyecto
C-x g        → Abrir Magit (Git Status)
s            → Stage (en Magit)
u            → Unstage (en Magit)
c c          → Iniciar commit (en Magit)
C-c C-c      → Confirmar commit
P p          → Push al remoto (en Magit)
b c          → Crear rama nueva (en Magit)
b b          → Cambiar de rama (en Magit)
l l          → Ver historial de commits (en Magit)
Tab          → Ver/ocultar diff (en Magit)
q            → Cerrar panel de Magit
```

---

**Anterior:** [Guia 01: Core y Entorno](01_Core_y_Entorno.md) | **Siguiente:** [Guia 03: Desarrollo Web](03_Desarrollo_Web.md) | [Volver al README](../README.md)
