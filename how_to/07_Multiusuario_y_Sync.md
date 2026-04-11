# Guia 07: Sistema Multiusuario y Sincronizacion

> Gestiona multiples alumnos en una misma PC, sincroniza proyectos con Google Drive y respalda en USB — ideal para laboratorios escolares.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Cambiar entre usuarios/alumnos en una PC compartida
- Configurar Google Drive para sincronizar proyectos entre dispositivos
- Respaldar tu trabajo en un pendrive con un solo comando
- Exportar e importar tu progreso como archivo comprimido
- Entender el ciclo diario: bajar del Drive, trabajar, subir al Drive

## Prerequisitos

- Haber completado la [Guia 00: Conceptos Basicos](00_Basics.md)
- Para Google Drive: tener una cuenta de Google
- Para USB: tener un pendrive disponible

---

## 1. El Sistema Multiusuario

En entornos educativos (laboratorios, colegios), varias personas usan la misma computadora. FORJA resuelve esto con un sistema de perfiles de alumno que mantiene todo separado.

### Como funciona

Cada alumno tiene su propia carpeta con sus proyectos, configuraciones y datos:

```
~/org-alumnos/
├── garcia-juan/
│   ├── proyectos/     ← Sus repositorios de codigo
│   ├── gtd/           ← Sus tareas y agenda
│   ├── docs/          ← Sus documentos
│   └── .n8n/          ← Sus workflows de n8n (privados)
├── lopez-maria/
│   ├── proyectos/
│   ├── gtd/
│   ├── docs/
│   └── .n8n/
└── ...
```

**Ningun alumno puede ver ni modificar los datos de otro.**

### El Menu Maestro (`C-c U`)

Todas las funciones multiusuario se acceden con `C-c U` (la U es mayuscula):

| Tecla | Accion | Descripcion |
| :---: | :--- | :--- |
| `C-c U c` | **Cambiar alumno** | Seleccionar que alumno esta usando la PC |
| `C-c U t` | **Estado** | Ver quien esta logeado, estado de USB y Drive |
| `C-c U D` | **Configurar Drive** | Setup inicial de Google Drive (una sola vez) |
| `C-c U s` | **Subir a Drive** | Sincronizar datos locales → Google Drive |
| `C-c U S` | **Bajar de Drive** | Sincronizar Google Drive → datos locales |
| `C-c U u` | **Backup a USB** | Respaldar en pendrive |
| `C-c U r` | **Restaurar de USB** | Restaurar desde pendrive |
| `C-c U e` | **Exportar** | Comprimir progreso en `.tar.gz` |
| `C-c U i` | **Importar** | Descomprimir un `.tar.gz` exportado |

## 2. Cambiar de Alumno (`C-c U c`)

Al inicio de cada clase o sesion:

1. Presiona `C-c U c`
2. Aparece una lista de alumnos registrados
3. Selecciona tu nombre con las flechas y `Enter`
4. FORJA cambia el workspace al tuyo — tus proyectos, tu agenda, tu configuracion

### Que pasa al cambiar de alumno

- Treemacs muestra los proyectos del nuevo alumno
- La agenda GTD carga las tareas del nuevo alumno
- Si n8n estaba corriendo, se reinicia con los datos del nuevo alumno
- Los archivos abiertos del alumno anterior se cierran

### Ver el estado actual (`C-c U t`)

Para verificar quien esta logeado y el estado del sistema:

1. Presiona `C-c U t`
2. Se muestra informacion como:
   ```
   Alumno activo: garcia-juan
   Pendrive:      Detectado (UUID: ABC-123)
   Google Drive:  Configurado (ultima sync: hace 2 horas)
   n8n:           Corriendo (puerto 5678)
   ```

## 3. Google Drive: Sincronizacion entre Dispositivos

La sincronizacion con Google Drive te permite trabajar en la PC del colegio y continuar en tu casa (o en el celular con Termux).

### Configuracion inicial (una sola vez)

1. Presiona `C-c U D` (Drive setup)
2. Se abre un asistente de configuracion de `rclone`
3. Sigue las instrucciones:
   - Selecciona "Google Drive" como tipo de remoto
   - Autoriza el acceso con tu cuenta de Google
   - Se crea la conexion automaticamente
4. Listo — no necesitas volver a hacerlo

> **Alternativa manual:** Si prefieres configurar desde terminal:
> ```bash
> rclone config
> # Crear remote llamado "gdrive" de tipo "Google Drive"
> ```

### El ciclo diario

Este es el flujo que usaras cada dia:

```
            COLEGIO                         CASA / CELULAR
            -------                         --------------
1. Llegar → C-c U S (bajar del Drive)
2. Trabajar, programar, estudiar
3. Al irse → C-c U s (subir al Drive)
                                        4. Llegar → C-c U S (bajar)
                                        5. Trabajar
                                        6. Al terminar → C-c U s (subir)
```

### Paso a paso del ciclo

#### Al llegar (bajar del Drive)

1. Abre FORJA
2. Identifica tu usuario: `C-c U c` → selecciona tu nombre
3. Presiona `C-c U S` (S **mayuscula** = Sync FROM Drive)
4. Espera a que termine la descarga
5. Tus proyectos estan actualizados — empieza a trabajar

#### Al irte (subir al Drive)

1. Guarda todo tu trabajo (`C-x C-s` en cada archivo abierto)
2. Haz commit de tus cambios si usas Git (`C-x g` → `s` → `c c`)
3. Presiona `C-c U s` (s **minuscula** = Sync TO Drive)
4. Espera a que termine la subida
5. Ya podes irte — tu trabajo esta en la nube

### Truco para recordar: s y S

- **`s` minuscula = subir** (tu mandas datos al Drive)
- **`S` mayuscula = bajar** (el Drive te manda datos a vos)

> **Seguridad:** Solo se sincronizan archivos mas nuevos (`--update`). No se borran archivos remotos. Si algo sale mal, tus datos siguen en el Drive.

## 4. Backup en Pendrive (USB)

Para cuando no hay internet o prefieres un respaldo fisico.

### Respaldar (`C-c U u`)

1. Conecta tu pendrive al puerto USB
2. Presiona `C-c U u`
3. FORJA detecta automaticamente el pendrive por su UUID
4. Se copia tu carpeta de alumno al pendrive
5. Ves un mensaje de confirmacion cuando termina

### Restaurar (`C-c U r`)

Si necesitas recuperar datos desde el pendrive:

1. Conecta el pendrive
2. Presiona `C-c U r`
3. Se restauran los datos del pendrive a tu carpeta de alumno

> **Tip:** El backup a USB es rapido porque solo copia archivos que cambiaron desde la ultima vez.

## 5. Exportar e Importar (`.tar.gz`)

Para llevar tu trabajo a otro lugar sin pendrive ni internet.

### Exportar (`C-c U e`)

1. Presiona `C-c U e`
2. Se genera un archivo comprimido en tu escritorio:
   ```
   ~/Escritorio/garcia-juan-backup-2026-04-09.tar.gz
   ```
3. Este archivo contiene todo tu progreso: proyectos, configuracion, datos de n8n

### Importar (`C-c U i`)

1. Copia el `.tar.gz` a la maquina destino
2. Abre FORJA
3. Presiona `C-c U i`
4. Selecciona el archivo `.tar.gz`
5. Se descomprime y restaura tu workspace completo

---

## Ejercicio Practico: Simular un Dia de Clase

Simula el flujo completo que usarias en un dia de clase:

1. **Identifica tu usuario:** `C-c U c` → selecciona o crea tu perfil
2. **Verifica el estado:** `C-c U t` → confirma quien esta logeado
3. **Crea un proyecto:** `C-c n` → `w` (Web) → nombre: `tarea-web`
4. **Escribe algo:** Agrega un titulo a `index.html`
5. **Guarda:** `C-x C-s`
6. **Haz commit:** `C-x g` → `s` → `c c` → "feat: agregar titulo" → `C-c C-c`
7. **Respalda en USB** (si tienes pendrive): `C-c U u`
8. **O exporta:** `C-c U e` → verifica que el `.tar.gz` aparecio en el escritorio

Este es exactamente el flujo que seguirias al final de una clase real.

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| `C-c U c` no muestra alumnos | No se crearon perfiles todavia | El docente debe crear los perfiles iniciales |
| "rclone not found" | rclone no esta instalado | Ejecuta `sudo pacman -S rclone` (Arch) o `pkg install rclone` (Termux) |
| La sync al Drive es muy lenta | Muchos archivos grandes (node_modules, binarios) | Es normal la primera vez. Las siguientes seran incrementales |
| "USB not detected" | El pendrive no se monto | Verifica con `lsblk` en terminal. Puede necesitar montaje manual |
| El `.tar.gz` es muy grande | Incluye node_modules u otros archivos pesados | Agrega carpetas pesadas al `.gitignore` |
| Al bajar del Drive, falta mi proyecto | No hiciste sync antes de irte | Recuerda siempre hacer `C-c U s` antes de cerrar |

## Resumen de Atajos de esta Guia

```
C-c U        → Menu maestro multiusuario
C-c U c      → Cambiar alumno activo
C-c U t      → Ver estado (alumno, USB, Drive, n8n)
C-c U D      → Configurar Google Drive (una vez)
C-c U s      → Subir datos al Drive (minuscula = subir)
C-c U S      → Bajar datos del Drive (mayuscula = bajar)
C-c U u      → Backup a USB
C-c U r      → Restaurar desde USB
C-c U e      → Exportar .tar.gz
C-c U i      → Importar .tar.gz
```

---

**Anterior:** [Guia 06: Inteligencia Artificial](06_Inteligencia_Artificial.md) | **Siguiente:** [Guia 08: Productividad y Org](08_Productividad_y_Org.md) | [Volver al README](../README.md)
