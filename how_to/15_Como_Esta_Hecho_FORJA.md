# Guia 15: Como esta hecho FORJA

> FORJA no es una caja negra. Esta guia abre la tapa y muestra exactamente como funciona por dentro: como el codigo Lisp se convierte en comportamiento, como estan organizados los modulos y como leer cualquier parte del sistema.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Entender por que FORJA usa Org-mode como contenedor de codigo
- Leer cualquier modulo `.org` y entender su estructura
- Identificar los patrones recurrentes: `use-package`, hooks, hydras
- Saber donde vive cada pieza del sistema

## Prerequisitos

- Tener FORJA instalado (cualquier perfil)
- Haber usado FORJA al menos una sesion

---

## 1. La base: Org-mode como literate config

FORJA esta escrito en **Org-mode** — el mismo formato que usas para tomar notas. Cada modulo es un archivo `.org` con secciones de texto y bloques de codigo Emacs Lisp:

```org
* 20. TypeScript Standalone (CLI y Libreria)

Proyectos TypeScript puros sin stack web. Usa tsx para ejecutar sin compilar.

#+begin_src emacs-lisp
(defun my/new-ts-project (name)
  ...)
#+end_src
```

El texto explica el contexto. El codigo entre `#+begin_src` y `#+end_src` es Emacs Lisp real.

### El tangle: de .org a .el

Cuando Emacs carga FORJA, **tanglea** los archivos `.org`: extrae todos los bloques `#+begin_src emacs-lisp` y los concatena en un archivo `.el`. Ese `.el` es el que Emacs ejecuta.

```
20-web.org  →  (tangle)  →  20-web.el  →  Emacs lo carga
```

Por eso:
- **Editar `.org`** — correcto: es la fuente de verdad
- **Editar `.el`** — incorrecto: se sobreescribe en el proximo tangle
- **Ver `.el`** — util para debuggear sin abrir el org

---

## 2. Estructura de modulos

Los modulos estan en `~/.emacs.d/modules/` y siguen una numeracion deliberada:

| Rango | Proposito |
|:---:|:---|
| `00-09` | Infraestructura: paquetes, UI, LSP, hydras maestros |
| `10-19` | Herramientas transversales: git, formateo |
| `20-29` | Web y frontend |
| `30-39` | Sistemas: C/C++, Rust, Go |
| `40-49` | Juegos y plataformas especificas |
| `49` | Multiusuario |
| `50-59` | GTD, estandarizacion, vision sistemica |
| `55-56` | Agentes IA (PicoClaw, OpenClaw) |
| `99` | Utilidades miscelaneas |

El orden importa: `00-core.el` se carga primero porque define la infraestructura que todos los demas necesitan.

---

## 3. El patron use-package

Casi todo paquete en FORJA se declara con `use-package`:

```elisp
(use-package rust-mode
  :ensure t                          ;; instalar si no esta
  :mode "\\.rs\\'"                   ;; activar para archivos .rs
  :hook (rust-mode . lsp-deferred)   ;; activar LSP al abrir
  :bind (:map rust-mode-map          ;; atajo especifico del modo
              ("C-c C-b" . my/rust-build))
  :config
  (setq rust-format-on-save t))      ;; configurar despues de cargar
```

Cada clausula tiene un rol:
- `:ensure t` — descarga el paquete de MELPA si falta
- `:mode` — asocia el paquete a extensiones de archivo
- `:hook` — corre una funcion cuando se activa un modo
- `:bind` — define atajos de teclado
- `:config` — codigo que corre despues de cargar el paquete

---

## 4. Hooks: reaccionar a eventos

Un hook es una lista de funciones que Emacs llama cuando algo pasa. FORJA los usa para activar comportamiento por modo:

```elisp
(defun my/rust-keybindings ()
  (local-set-key (kbd "<f5>") #'my/rust-run)
  (local-set-key (kbd "C-c C-b") #'my/rust-build))

(add-hook 'rust-mode-hook #'my/rust-keybindings)
```

`rust-mode-hook` se dispara cada vez que Emacs abre un archivo `.rs`. FORJA agrega `my/rust-keybindings` a esa lista, entonces F5 funciona automaticamente en archivos Rust.

Hooks importantes en FORJA:
| Hook | Cuando se dispara |
|:---|:---|
| `rust-mode-hook` | Al abrir `.rs` |
| `compilation-filter-hook` | Al recibir salida de compilacion |
| `emacs-startup-hook` | Una vez que Emacs termina de inicializar |
| `after-save-hook` | Despues de guardar cualquier archivo |

---

## 5. Hydras: menus de atajos

Una hydra es un menu temporal de atajos que aparece en el minibuffer. FORJA las usa para agrupar comandos relacionados:

```elisp
(defhydra my/hydra-build (:hint nil)
  "
  Build [_b_uild] [_r_un] [_t_est] [_q_uit]
  "
  ("b" my/rust-build "build")
  ("r" my/rust-run   "run")
  ("t" my/rust-test  "test")
  ("q" nil           "salir" :exit t))

(global-set-key (kbd "C-c x") #'my/hydra-build/body)
```

`C-c x` abre la hydra. Cada letra ejecuta su comando. `q` cierra sin ejecutar nada.

Todas las hydras de FORJA siguen la convencion `my/hydra-*`.

---

## 6. Como leer un modulo

Para leer `30-cpp.org` (C/C++), el camino es:

1. **Abrir el `.org`** — `C-x C-f ~/.emacs.d/modules/30-cpp.org`
2. **Colapsar todo** — `C-u TAB` (muestra solo los titulos)
3. **Expandir una seccion** — `TAB` sobre el titulo
4. **Ir al codigo** — los bloques `#+begin_src emacs-lisp` son el codigo real
5. **Evaluar un bloque** — `C-c C-c` dentro del bloque (carga en la sesion actual)

El patron que veras en cada modulo:
```
* N. Nombre de la seccion
  Explicacion en texto plano

  #+begin_src emacs-lisp
  ;; Configuracion / funciones / hooks
  #+end_src

* N+10. Generadores de Proyecto
  #+begin_src emacs-lisp
  (defun my/new-X-project (name) ...)
  #+end_src

* Dependencias y registro
  #+begin_src emacs-lisp
  (my/forja-dep ...)
  (my/forja-register-lang ...)
  #+end_src
```

---

## 7. El flujo completo al iniciar Emacs

```
early-init.el     → optimizaciones antes de cargar la UI
init.el           → carga los modulos en orden (00 → 99)
  ↓
00-core.el        → infraestructura: paquetes, LSP, hydras globales
20-web.el         → paquetes y funciones web/TS
31-rust.el        → paquetes y funciones Rust
...
99-misc.el        → utilidades finales
  ↓
dashboard         → pantalla de inicio con estado del sistema
```

Cada `.el` se carga con `(load-file ...)` en `init.el`. Si un modulo falla, Emacs muestra el error y continua con el siguiente (guards de error en el cargador).

---

## Ver tambien

- [Guia 16: Tu propia configuracion](16_Tu_Propia_Configuracion.md) — como personalizar FORJA sin tocar el repo
- [Clase 17: El Taller del Herrero](../escuela/clase-17-el-taller-del-herrero/README.md) — clase practica de lectura y modificacion del IDE
