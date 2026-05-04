# Guia 16: Tu propia configuracion

> FORJA tiene un mecanismo oficial para personalizarlo: `local.el`. Este archivo nunca se toca en actualizaciones y es el lugar correcto para todos tus cambios personales.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Agregar atajos de teclado propios sin romper FORJA
- Cambiar comportamiento por defecto de cualquier modulo
- Configurar parametros opcionales (caldav, paths, modelos IA)
- Actualizar FORJA sin perder tu configuracion

## Prerequisitos

- Haber completado la [Guia 15: Como esta hecho FORJA](15_Como_Esta_Hecho_FORJA.md)
- FORJA instalado (cualquier perfil)

---

## 1. El archivo local.el

`~/.emacs.d/local.el` es el punto de extension oficial de FORJA. Se carga al final del proceso de inicializacion, despues de todos los modulos, y **nunca se sobreescribe** en actualizaciones.

Abrir o crear el archivo:
```
C-x C-f ~/.emacs.d/local.el
```

Si no existe, Emacs lo crea vacio. FORJA lo carga automaticamente si existe.

---

## 2. Agregar atajos de teclado

### Atajo global

```elisp
;; Abrir mi archivo de notas rapidas con F12
(global-set-key (kbd "<f12>") (lambda ()
  (interactive)
  (find-file "~/notas.org")))
```

### Atajo en un modo especifico

```elisp
;; En Python: Ctrl+Shift+R ejecuta el linter
(add-hook 'python-mode-hook
  (lambda ()
    (local-set-key (kbd "C-S-r")
      (lambda ()
        (interactive)
        (compile "ruff check .")))))
```

### Sobreescribir un atajo de FORJA

```elisp
;; Cambiar F5 en Rust para usar --release en vez de debug
(add-hook 'rust-mode-hook
  (lambda ()
    (local-set-key (kbd "<f5>")
      (lambda ()
        (interactive)
        (compile "cargo run --release")))))
```

---

## 3. Cambiar variables de configuracion

Muchas opciones de FORJA y sus paquetes se controlan con variables. Puedes sobreescribirlas en `local.el`:

```elisp
;; Cambiar el modelo de IA por defecto para Aider
(setq my/aider-model "deepseek/deepseek-coder")

;; Desactivar formato automatico al guardar en Rust
(setq rust-format-on-save nil)

;; Cambiar el numero de lineas del historial de minibuffer
(setq history-length 500)

;; Cambiar el tema de color
(load-theme 'modus-operandi t)
```

Para saber el nombre de una variable, usa `C-h v` (describe-variable) y escribe parte del nombre.

---

## 4. Variables reservadas de FORJA

FORJA define variables con prefijo `my/` que son puntos de configuracion documentados:

| Variable | Tipo | Descripcion |
|:---|:---:|:---|
| `my/caldav-calendar-id` | string | ID del calendario de Google para org-caldav |
| `my/aider-model` | string | Modelo por defecto de Aider |
| `my/ollama-default-model` | string | Modelo local de Ollama |
| `my/mu-projects-base` | string | Directorio raiz de proyectos (si difiere del default) |

Ejemplo completo de `local.el` con variables FORJA:

```elisp
;; Configuracion personal — local.el
;; Este archivo no se toca en las actualizaciones de FORJA

;; Google Calendar (para org-caldav)
(setq my/caldav-calendar-id "tu-email@gmail.com")

;; Modelo de IA local preferido
(setq my/ollama-default-model "qwen2.5-coder:7b")

;; Directorio de proyectos personalizado
(setq my/projects-root "~/code/")
```

---

## 5. Agregar nuevas funciones

Puedes definir tus propias funciones en `local.el`. Siguen disponibles en toda la sesion:

```elisp
;; Abrir el proyecto actual en el explorador de archivos
(defun mi/abrir-en-dolphin ()
  (interactive)
  (start-process "dolphin" nil "dolphin"
                 (or (projectile-project-root) default-directory)))

(global-set-key (kbd "C-c o") #'mi/abrir-en-dolphin)
```

Convencion: usa el prefijo `mi/` (no `my/`) para distinguir tus funciones de las de FORJA.

---

## 6. Activar paquetes opcionales

Algunos paquetes estan disponibles pero desactivados por defecto. Puedes activarlos en `local.el`:

```elisp
;; Activar ligaduras de fuente (requiere fuente compatible)
(use-package ligature
  :config
  (ligature-set-ligatures 't '("==" "!=" "->" "=>")))

;; Activar git-gutter (indicador visual de cambios en el margen)
(use-package git-gutter
  :config (global-git-gutter-mode t))
```

---

## 7. Que NO hacer en local.el

- **No redefinir funciones de FORJA con el mismo nombre** — usa `advice-add` si necesitas envolver una funcion existente
- **No cargar modulos enteros** — si necesitas cambiar un modulo, habla con el docente para evaluarlo en el repo
- **No poner credenciales en texto plano** — usa variables de entorno o un archivo separado con permisos restrictivos

---

## 8. Depurar local.el

Si Emacs no arranca despues de editar `local.el`:

```bash
# Arrancar Emacs ignorando local.el
emacs --eval "(setq my/skip-local t)"

# O directamente sin cargar ningun init
emacs -Q
```

Para ver errores de carga:
```
M-x view-echo-area-messages
```

---

## Ver tambien

- [Guia 15: Como esta hecho FORJA](15_Como_Esta_Hecho_FORJA.md) — entender la arquitectura antes de modificarla
- [Clase 17: El Taller del Herrero](../escuela/clase-17-el-taller-del-herrero/README.md) — clase practica
