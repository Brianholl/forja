# Clase 17 — El Taller del Herrero

> Un herrero no solo usa las herramientas — las forja. Esta clase trata FORJA como un proyecto vivo: lo lees, lo entiendes, y lo modificas.

## Objetivos

- Leer un modulo `.org` de FORJA sin asustarse
- Identificar `use-package`, hooks y hydras en codigo real
- Agregar un atajo propio al sistema
- Entender por que el IDE hace lo que hace cuando presionas una tecla

## Modulos FORJA

`00-core` — infraestructura  
`20-web` / `31-rust` / `30-cpp` — modulos de lenguaje (elegir uno segun el alumno)

## Duracion estimada

90 minutos

---

## Parte 1 — Leer el IDE (30 min)

### 1.1 Abrir un modulo

```
C-x C-f ~/.emacs.d/modules/30-cpp.org
```

Colapsar todo para ver solo la estructura:
```
C-u TAB
```

Expandir la seccion que interese:
```
TAB   (sobre el titulo)
```

**Ejercicio:** Encontrar la funcion que se ejecuta cuando presionas F5 en un archivo `.c`.

> Pista: busca `f5` con `C-s f5` dentro del modulo.

### 1.2 Seguir el hilo

Cuando encuentres `(add-hook 'c-mode-hook #'my/find-and-compile)`, busca la definicion de `my/find-and-compile`:

```
M-. nombre-de-funcion   (ir a la definicion)
M-,                     (volver)
```

**Ejercicio:** Trazar el camino completo: F5 → hook → funcion → `compile` → comando shell.

### 1.3 Leer use-package

Busca un `use-package` en cualquier modulo. Identifica:
- Que paquete instala
- Cuando se activa (`:mode` o `:hook`)
- Que atajos define (`:bind`)
- Que configura (`:config`)

---

## Parte 2 — Entender la construccion (20 min)

### 2.1 El tangle

Abre los dos archivos lado a lado:

```
C-x 3                        (dividir ventana verticalmente)
C-x C-f 30-cpp.org           (en una ventana)
C-x C-f 30-cpp.el            (en la otra)
```

Compara: el `.el` es exactamente el contenido de los bloques `#+begin_src emacs-lisp` del `.org`, concatenados.

**Pregunta:** si cambias `30-cpp.org` y reinicias Emacs, ¿que archivo se carga? ¿por que?

### 2.2 La numeracion de modulos

Abre `~/.emacs.d/init.el` y observa el orden de carga. Responde:
- ¿Por que `00-core` se carga antes que `31-rust`?
- ¿Que pasaria si `31-rust` se cargara antes que `00-core`?

---

## Parte 3 — Modificar FORJA (30 min)

### 3.1 Agregar un atajo propio

Abrir `local.el`:
```
C-x C-f ~/.emacs.d/local.el
```

Agregar un atajo que abre el FORJA.md del proyecto actual:

```elisp
(defun mi/abrir-forja-md ()
  "Abre el FORJA.md del proyecto actual."
  (interactive)
  (let ((forja-md (expand-file-name "FORJA.md"
                   (or (and (fboundp 'projectile-project-root)
                            (projectile-project-root))
                       default-directory))))
    (if (file-exists-p forja-md)
        (find-file forja-md)
      (message "No hay FORJA.md en este proyecto."))))

(global-set-key (kbd "C-c F ?") #'mi/abrir-forja-md)
```

Evaluar el bloque con `C-x C-e` al final de la ultima parentesis. Probar con `C-c F ?`.

### 3.2 Cambiar un comportamiento existente

Elige uno:

**Opcion A — Cambiar el modelo de IA:**
```elisp
(setq my/ollama-default-model "llama3.2:3b")
```

**Opcion B — Desactivar el formato automatico en Python:**
```elisp
(add-hook 'python-mode-hook
  (lambda () (setq-local lsp-enable-on-type-formatting nil)))
```

**Opcion C — Agregar un mensaje de bienvenida al dashboard:**
```elisp
(add-hook 'emacs-startup-hook
  (lambda () (message "Bienvenido, herrero.")))
```

Evaluar con `C-x C-e` y verificar que funciona.

### 3.3 Desafio: agregar un snippet propio

Abrir el directorio de snippets:
```
C-x C-f ~/.emacs.d/snippets/
```

Elegir un modo (por ejemplo `python-mode`). Crear un archivo nuevo con el nombre del atajo de expansion:

```
# name: mi_funcion
# key: mifn
# --
def ${1:nombre}(${2:args}):
    """${3:docstring}"""
    ${0:pass}
```

Recargar snippets:
```
M-x yas-reload-all
```

Probar en un archivo Python escribiendo `mifn` y presionando `TAB`.

---

## Parte 4 — Reflexion (10 min)

Preguntas para discutir:

1. ¿Que diferencia hay entre un IDE que no puedes leer y uno que puedes modificar?
2. Nombraste una funcion con prefijo `mi/`. ¿Por que es importante diferenciarla de `my/`?
3. Si FORJA se actualiza y agrega una nueva funcion, ¿tu `local.el` se rompe? ¿Por que?
4. ¿Que pasaria si modificas directamente `30-cpp.el` en vez de `30-cpp.org`?

---

## Recursos

- [Guia 15: Como esta hecho FORJA](../../how_to/15_Como_Esta_Hecho_FORJA.md)
- [Guia 16: Tu propia configuracion](../../how_to/16_Tu_Propia_Configuracion.md)
- `C-h f nombre-de-funcion` — documentacion de cualquier funcion
- `C-h v nombre-de-variable` — documentacion de cualquier variable
- `M-.` — ir a la definicion de un simbolo
