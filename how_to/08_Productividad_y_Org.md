# Guia 08: Productividad, GTD, SOPs y Diagramas

> Organiza tu trabajo con el sistema GTD (Get Things Done), documenta procedimientos con checklists y crea diagramas sin salir del editor.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Capturar tareas rapidamente con el sistema GTD (inbox)
- Revisar tu agenda y tareas pendientes de un vistazo
- Crear notas estructuradas y jerarquicas con Org-Mode
- Documentar procedimientos (SOPs) con checklists verificables
- Generar diagramas Mermaid directamente en el editor

## Prerequisitos

- Haber completado la [Guia 00: Conceptos Basicos](00_Basics.md)
- No se necesita experiencia previa con Org-Mode — esta guia parte desde cero

---

## 1. GTD: Get Things Done (Modulo 50)

GTD es un sistema de productividad que se basa en una idea simple: **saca las tareas de tu cabeza y ponlas en un sistema confiable**. En FORJA, ese sistema es Org-Mode.

### El concepto basico

En lugar de intentar recordar todo lo que tienes que hacer, sigues este flujo:

```
Idea/tarea aparece → Capturas rapidamente → Procesas luego → Ejecutas cuando corresponde
```

FORJA implementa esto con tres acciones principales:
- **Capturar:** Anotar una tarea al vuelo sin interrumpir tu trabajo (`C-c c`)
- **Revisar:** Ver toda tu agenda y tareas pendientes (`C-c a`)
- **Procesar:** Priorizar y organizar las tareas capturadas

### Captura rapida (`C-c c`)

Estas programando y de repente recuerdas que tienes que "estudiar para el examen de redes". En lugar de abrir una app de notas o escribirlo en un papel:

1. Presiona `C-c c` (Capture) — sin importar que archivo tengas abierto
2. Selecciona el tipo de captura:
   - `t` para una **tarea** (TODO)
   - `s` para un **ticket de soporte**
   - Otras opciones segun la configuracion
3. Escribe la tarea: "Estudiar para el examen de redes"
4. Opcionalmente agrega una fecha: `C-c C-d` para deadline, `C-c C-s` para fecha programada
5. Presiona `C-c C-c` para guardar

**La tarea se guarda automaticamente en tu archivo de inbox.** Puedes seguir programando sin interrupciones.

### La Agenda (`C-c a`)

La agenda es tu "centro de control" — muestra todo lo que tienes pendiente:

1. Presiona `C-c a`
2. Aparece un menu:
   - `a` → Agenda semanal (muestra tareas con fecha de esta semana)
   - `t` → Lista de todos los TODOs
3. Selecciona una opcion

La vista de agenda muestra algo como:
```
Week-agenda (W15):
  Lunes     7 abril
    inbox:      TODO Estudiar para el examen de redes
  Martes    8 abril
    inbox:      TODO Entregar trabajo de base de datos   :DEADLINE:
  Miercoles 9 abril
  Jueves   10 abril
    calendario: TODO Reunion de equipo 14:00-15:00
```

### Navegar la agenda

| Tecla | Accion |
| :---: | :--- |
| `Enter` | Abrir la tarea/archivo donde esta definida |
| `t` | Cambiar el estado de una tarea (TODO → DONE) |
| `f` / `b` | Avanzar / retroceder una semana |
| `q` | Cerrar la agenda |

### Estados de las tareas

Las tareas en Org-Mode tienen estados que puedes cambiar:

```
TODO → DONE
```

Para cambiar el estado:
1. Posicionate en la linea de la tarea (en el archivo `.org` o en la agenda)
2. Presiona `C-c C-t` o simplemente `t` si estas en la agenda
3. Selecciona el nuevo estado

### Ejemplo de archivo GTD

Asi se ve un archivo `inbox.org` tipico:
```org
* TODO Estudiar para el examen de redes
  DEADLINE: <2026-04-15 mie>

* TODO Entregar trabajo de base de datos
  SCHEDULED: <2026-04-08 mar>

* DONE Instalar FORJA en la PC de casa
  CLOSED: [2026-04-05 sab 18:30]

* TODO Revisar los tests de la API de Go
  :PROPERTIES:
  :CREATED: [2026-04-07 lun 10:15]
  :END:
```

## 2. Tomar Notas Estructuradas con Org-Mode

Org-Mode es mucho mas que un sistema de tareas. Es un formato de texto plano para crear documentos con jerarquia, como un Obsidian/Notion pero sin base de datos — todo es texto `.org`.

### Estructura basica de un documento Org

```org
* Titulo Principal (Nivel 1)
** Subtitulo (Nivel 2)
*** Sub-subtitulo (Nivel 3)

Texto normal del parrafo.

- Lista con viñetas
- Otro item
  - Sub-item indentado

1. Lista numerada
2. Segundo punto

*negrita*  /italica/  =codigo=  ~comando~

#+BEGIN_SRC python
print("Bloques de codigo con resaltado de sintaxis")
#+END_SRC
```

### Navegar documentos Org

| Tecla | Accion |
| :---: | :--- |
| `Tab` | Expandir/contraer la seccion bajo el cursor |
| `S-Tab` | Expandir/contraer **todo** el documento |
| `M-↑` / `M-↓` | Mover una seccion completa arriba/abajo |
| `M-←` / `M-→` | Cambiar nivel de jerarquia (promover/degradar) |
| `C-c C-l` | Insertar un enlace (a archivo, URL, etc.) |

### Ejemplo: Apuntes de clase

```org
* Programacion II - Apuntes
** Clase 1: Estructuras de datos
*** Listas enlazadas
- Cada nodo tiene un valor y un puntero al siguiente
- Insercion en O(1) al principio
- Busqueda en O(n)

*** Ejemplo en C
#+BEGIN_SRC c
typedef struct Nodo {
    int valor;
    struct Nodo *siguiente;
} Nodo;
#+END_SRC

** Clase 2: Arboles binarios
*** Propiedades
- Cada nodo tiene maximo 2 hijos
- Recorrido: inorder, preorder, postorder

*** TODO Hacer el ejercicio del arbol AVL
   DEADLINE: <2026-04-12 dom>
```

Observa como se mezclan apuntes, codigo y tareas en un solo documento. Eso es la potencia de Org-Mode.

## 3. SOPs y Checklists (Modulo 51)

Un SOP (Standard Operating Procedure) es una lista de pasos para realizar una tarea recurrente. FORJA te permite crear SOPs como checklists interactivas.

### Crear un checklist

En un archivo `.org`:
```org
* SOP: Desplegar API a Produccion
** Pasos
- [ ] Ejecutar todos los tests localmente (C-c x t)
- [ ] Verificar que no hay TODO pendientes (C-c p s g → "TODO")
- [ ] Hacer commit de todos los cambios (C-x g → s → c c)
- [ ] Push a la rama main (P p en Magit)
- [ ] Verificar que el CI/CD paso correctamente
- [ ] Probar el endpoint /health en produccion
- [ ] Notificar al equipo que el deploy esta listo
```

### Usar el checklist

1. Posicionate en una linea con `[ ]`
2. Presiona `C-c C-c`
3. El checkbox cambia a `[X]`:
   ```org
   - [X] Ejecutar todos los tests localmente (C-c x t)
   - [X] Verificar que no hay TODO pendientes
   - [ ] Hacer commit de todos los cambios
   ```

### Progreso automatico

Si agregas `[/]` o `[%]` en el titulo del checklist, Org-Mode muestra el progreso:

```org
* SOP: Desplegar API a Produccion [3/7]
```
o
```org
* SOP: Desplegar API a Produccion [42%]
```

El contador se actualiza automaticamente cada vez que marcas un item.

### Ejemplos de SOPs utiles

| SOP | Para que sirve |
| :--- | :--- |
| Desplegar a produccion | Pasos para subir codigo al servidor |
| Configurar nueva PC | Lista de todo lo que hay que instalar |
| Iniciar proyecto nuevo | Verificar que todo esta listo antes de codear |
| Backup semanal | Recordatorio de que respaldar |
| Revision de codigo | Que verificar en un code review |

## 4. Diagramas con Mermaid (Modulo 52)

FORJA puede renderizar diagramas **dentro del editor** usando Mermaid — sin abrir el navegador ni instalar herramientas externas.

### Como crear un diagrama

En un archivo `.org`, inserta un bloque de codigo Mermaid:

```org
#+BEGIN_SRC mermaid :file diagrama.png
graph TD
    A[Usuario] --> B{Login}
    B -->|Exito| C[Dashboard]
    B -->|Fallo| D[Mostrar error]
    C --> E[Ver proyectos]
    C --> F[Ver agenda]
#+END_SRC
```

Para renderizar:
1. Posiciona el cursor dentro del bloque
2. Presiona `C-c C-c`
3. Se genera el archivo `diagrama.png` y se muestra en el editor

### Tipos de diagramas soportados

#### Diagrama de flujo
```
graph TD
    A[Inicio] --> B{Condicion}
    B -->|Si| C[Accion 1]
    B -->|No| D[Accion 2]
    C --> E[Fin]
    D --> E
```

#### Diagrama de secuencia
```
sequenceDiagram
    Cliente->>API: POST /login
    API->>DB: SELECT usuario
    DB-->>API: Datos usuario
    API-->>Cliente: Token JWT
```

#### Diagrama de clases
```
classDiagram
    class Animal {
        +String nombre
        +int edad
        +hacerSonido()
    }
    class Perro {
        +ladrar()
    }
    class Gato {
        +maullar()
    }
    Animal <|-- Perro
    Animal <|-- Gato
```

#### Diagrama de Gantt (cronograma)
```
gantt
    title Proyecto Final
    dateFormat YYYY-MM-DD
    section Backend
    Diseñar API     :a1, 2026-04-01, 7d
    Implementar     :a2, after a1, 14d
    section Frontend
    Diseñar UI      :b1, 2026-04-01, 5d
    Implementar     :b2, after b1, 14d
    section Testing
    Tests           :c1, after a2, 7d
```

### Graphviz (alternativa offline)

Para diagramas mas complejos o cuando necesitas control total del layout, FORJA tambien soporta Graphviz:

```org
#+BEGIN_SRC dot :file grafo.png
digraph {
    rankdir=LR;
    A -> B -> C;
    A -> D -> C;
}
#+END_SRC
```

---

## Ejercicio Practico: Tu Sistema GTD Personal

1. **Captura tu primera tarea:** Presiona `C-c c`, selecciona `t` (tarea), escribe "Completar esta guia de FORJA", presiona `C-c C-c`

2. **Captura otra tarea con fecha:** `C-c c` → `t` → "Entregar proyecto final" → `C-c C-d` → selecciona una fecha de la proxima semana → `C-c C-c`

3. **Revisa tu agenda:** `C-c a` → `a` → deberas ver ambas tareas

4. **Crea un SOP:** Abre un archivo nuevo (`C-x C-f` → `~/mis-sops.org`) y escribe:
   ```org
   * SOP: Mi rutina de desarrollo [/]
   - [ ] Abrir FORJA
   - [ ] Bajar del Drive (C-c U S)
   - [ ] Revisar agenda (C-c a)
   - [ ] Trabajar en la tarea mas prioritaria
   - [ ] Hacer commits frecuentes
   - [ ] Subir al Drive (C-c U s)
   ```

5. **Marca items completados:** Posicionate en "Abrir FORJA" y presiona `C-c C-c` — el contador se actualiza a `[1/6]`

6. **Crea un diagrama:** En el mismo archivo agrega:
   ```org
   * Mi flujo de trabajo
   #+BEGIN_SRC mermaid :file mi-flujo.png
   graph LR
       A[Llegar] --> B[Bajar Drive]
       B --> C[Revisar Agenda]
       C --> D[Programar]
       D --> E[Commit]
       E --> F[Subir Drive]
   #+END_SRC
   ```
   Presiona `C-c C-c` dentro del bloque para renderizarlo.

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| `C-c c` no hace nada | La captura GTD no esta configurada | Verifica que el modulo 50-gtd esta cargado. Reinicia Emacs |
| La agenda esta vacia | No hay tareas con fecha | Agrega `DEADLINE:` o `SCHEDULED:` a tus tareas |
| El diagrama no se renderiza | Mermaid CLI no esta instalado | Instala con `npm install -g @mermaid-js/mermaid-cli` |
| Los checkboxes no cambian | El cursor no esta exactamente sobre el `[ ]` | Posicionate en la linea del checkbox y presiona `C-c C-c` |
| El contador `[/]` no se actualiza | Falta el `[/]` en el titulo padre | Agrega `[/]` o `[%]` al final del titulo de la seccion |

## Resumen de Atajos de esta Guia

```
C-c c        → Captura rapida GTD (nueva tarea)
C-c a        → Abrir la agenda
C-c C-t      → Cambiar estado de tarea (TODO/DONE)
C-c C-d      → Agregar deadline a una tarea
C-c C-s      → Agregar fecha programada (schedule)
C-c C-c      → Marcar checkbox / Renderizar bloque de codigo
Tab          → Expandir/contraer seccion en Org
S-Tab        → Expandir/contraer todo el documento
M-↑ / M-↓   → Mover seccion arriba/abajo
M-← / M-→   → Promover/degradar nivel de seccion
C-c C-l      → Insertar enlace
```

---

**Anterior:** [Guia 07: Multiusuario y Sync](07_Multiusuario_y_Sync.md) | **Siguiente:** [Guia 09: Automatizacion n8n](09_Automatizacion_n8n.md) | [Volver al README](../README.md)
