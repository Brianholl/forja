# Guia 11: Soporte Operativo, PDF, LaTeX y Extras

> Conoce las herramientas complementarias de FORJA: el modulo de soporte tecnico, generacion de PDFs, exportacion LaTeX y utilidades miscelaneas.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Usar el sistema de tickets de soporte para gestionar incidencias
- Exportar documentos Org-Mode a PDF con formato profesional
- Generar documentos academicos con LaTeX desde Org-Mode
- Recargar y editar la configuracion de FORJA

## Prerequisitos

- Haber completado la [Guia 08: Productividad y Org](08_Productividad_y_Org.md) (entender Org-Mode basico)
- Para LaTeX/PDF: tener `texlive` instalado (solo PC)

---

## 1. Soporte Operativo (Modulo 53)

El modulo de soporte esta diseñado para gestionar problemas tecnicos en un entorno educativo: PCs que fallan, impresoras que no responden, software que se rompe.

### El concepto

En lugar de que los alumnos o profesores te digan verbalmente "no anda tal cosa" (y se te olvide), el sistema de soporte centraliza todo en archivos `.org` con estados rastreables.

### Capturar un ticket de soporte

1. Presiona `C-c c` (Captura rapida)
2. Selecciona `s` (Soporte)
3. Escribe el problema: "PC 5 no enciende el monitor"
4. Agrega datos adicionales si es necesario (quien reporto, prioridad)
5. Presiona `C-c C-c` para guardar

El ticket se almacena en `soporte.org` con formato estructurado:

```org
* INBOX [#B] PC 5 no enciende el monitor
:PROPERTIES:
:CREATED: [2026-04-09 mie 10:30]
:REPORTADO: Prof. Gonzalez
:END:
```

### Estados de un ticket

Los tickets siguen un flujo de estados:

```
INBOX → TODO → EN-PROGRESO → DONE
                    ↓
                 ESPERANDO (falta repuesto, autorizacion, etc.)
```

Para cambiar el estado:
1. Posicionate en la linea del ticket
2. Presiona `C-c C-t`
3. Selecciona el nuevo estado

### Prioridades

Los tickets usan el sistema de prioridades de Org-Mode:

| Prioridad | Marca | Significado |
| :---: | :---: | :--- |
| Alta | `[#A]` | Urgente — afecta a toda la clase |
| Media | `[#B]` | Importante pero no critico |
| Baja | `[#C]` | Puede esperar |

Para cambiar la prioridad: posicionate en el ticket y presiona `S-↑` o `S-↓`.

### Ver tickets pendientes en la agenda

Los tickets de soporte aparecen integrados en la agenda GTD. Presiona `C-c a` → `t` para ver todos los TODOs, incluyendo los de soporte.

### Base de conocimiento (KB)

El modulo de soporte tambien contempla una base de conocimiento: soluciones a problemas recurrentes documentadas en Org-Mode.

Ejemplo de entrada de KB:
```org
* KB: Monitor no enciende en PC del laboratorio
** Sintoma
El monitor queda en modo standby (led naranja) al encender la PC.

** Causa comun
Cable VGA/HDMI desconectado o suelto en la parte trasera.

** Solucion
1. Verificar conexion del cable en ambos extremos
2. Si persiste, probar con otro cable
3. Si persiste, probar con otro monitor para aislar si es la PC o el monitor
```

## 2. Exportar a PDF desde Org-Mode

Org-Mode puede exportar cualquier documento `.org` a PDF con formato profesional.

### Exportacion rapida

1. Abre un archivo `.org`
2. Presiona `C-c C-e` (Export dispatcher)
3. Se abre un menu con opciones de exportacion:
   - `l p` → Exportar a PDF via LaTeX
   - `l o` → Exportar a PDF y abrirlo
   - `h o` → Exportar a HTML y abrirlo
   - `t U` → Exportar a texto plano (UTF-8)
4. Selecciona la opcion deseada

### Configurar el documento para exportacion

Agrega estas lineas al principio de tu `.org` para controlar como se ve el PDF:

```org
#+TITLE: Mi Documento
#+AUTHOR: Juan Perez
#+DATE: 2026-04-09
#+LANGUAGE: es
#+OPTIONS: toc:2 num:t
```

| Opcion | Que hace |
| :--- | :--- |
| `#+TITLE:` | Titulo del documento |
| `#+AUTHOR:` | Nombre del autor |
| `#+DATE:` | Fecha (usa `\today` para fecha automatica) |
| `#+LANGUAGE: es` | Idioma español (afecta "Tabla de Contenidos", etc.) |
| `#+OPTIONS: toc:2` | Tabla de contenidos con 2 niveles de profundidad |
| `#+OPTIONS: num:t` | Secciones numeradas (`num:nil` para sin numeros) |

### Ejemplo: Crear un informe en PDF

```org
#+TITLE: Informe de Proyecto: API REST
#+AUTHOR: Garcia Juan
#+DATE: \today
#+LANGUAGE: es
#+OPTIONS: toc:2 num:t

* Introduccion

Este informe documenta el desarrollo de una API REST
para el sistema de gestion de alumnos.

* Arquitectura

** Endpoints

| Metodo | Ruta | Descripcion |
|--------+---------------+----------------------|
| GET    | /api/alumnos  | Listar todos         |
| POST   | /api/alumnos  | Crear nuevo          |
| GET    | /api/alumnos/:id | Obtener por ID    |
| DELETE | /api/alumnos/:id | Eliminar           |

** Diagrama de flujo

#+BEGIN_SRC mermaid :file flujo-api.png
graph LR
    A[Cliente] --> B[API REST]
    B --> C[Base de Datos]
    C --> B
    B --> A
#+END_SRC

* Codigo fuente

#+BEGIN_SRC go
func getAlumnos(c *gin.Context) {
    c.JSON(200, alumnos)
}
#+END_SRC

* Conclusiones

El proyecto cumple con los requisitos establecidos.
Se implementaron los 4 endpoints CRUD.
```

Presiona `C-c C-e l o` y se genera un PDF profesional con:
- Portada con titulo, autor y fecha
- Tabla de contenidos automatica
- Tablas formateadas
- Codigo con resaltado de sintaxis
- Diagrama incluido como imagen

## 3. LaTeX Avanzado (Solo PC)

> Requiere `texlive` instalado. No disponible en Termux.

Para documentos academicos que requieren formulas matematicas, bibliografias o formato especifico:

### Formulas matematicas en Org-Mode

Inline (dentro del texto):
```org
La formula de Einstein es $E = mc^2$ y la de Pitagoras $a^2 + b^2 = c^2$.
```

Bloque de ecuacion:
```org
\begin{equation}
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
\end{equation}
```

### Previsualizacion de formulas

Presiona `C-c C-x C-l` para ver una previsualizacion de las formulas renderizadas directamente en Emacs (sin necesidad de exportar a PDF).

### Plantillas LaTeX personalizadas

Para documentos con formato especifico (tesis, papers), puedes definir la clase LaTeX:

```org
#+LATEX_CLASS: article
#+LATEX_CLASS_OPTIONS: [12pt, a4paper]
#+LATEX_HEADER: \usepackage[margin=2.5cm]{geometry}
#+LATEX_HEADER: \usepackage{graphicx}
```

## 4. Utilidades Miscelaneas (Modulo 99)

### Editar la configuracion de FORJA (`C-c e`)

Para modificar los modulos de FORJA:

1. Presiona `C-c e`
2. Se abre la carpeta de modulos (`~/.emacs.d/modules/`)
3. Edita el archivo `.org` que necesites

> **Importante:** Los archivos `.el` son generados automaticamente. Siempre edita los `.org`. Despues de modificar, borra el `.el` correspondiente para forzar la regeneracion.

### Recargar configuracion (`C-c C-r`)

Si editaste un modulo y quieres aplicar los cambios sin reiniciar Emacs:

1. Presiona `C-c C-r`
2. FORJA recarga la configuracion

### Org extras incluidos

El modulo 99-misc incluye funcionalidades adicionales de Org-Mode:

| Funcionalidad | Descripcion |
| :--- | :--- |
| **Kanban** | Tableros de tareas estilo Trello en texto plano |
| **Org-babel** | Ejecutar bloques de codigo dentro de documentos Org |
| **Tablas calculadas** | Tablas con formulas (como una mini hoja de calculo) |
| **Agenda avanzada** | Vistas personalizadas de la agenda |

### Tablas con formulas

Org-Mode puede calcular formulas en tablas:

```org
| Alumno  | Nota 1 | Nota 2 | Promedio |
|---------+--------+--------+----------|
| Garcia  |    8.5 |    9.0 |     8.75 |
| Lopez   |    7.0 |    8.0 |      7.5 |
| Torres  |    9.5 |    9.0 |     9.25 |
#+TBLFM: $4=vmean($2..$3);%.2f
```

La linea `#+TBLFM:` calcula el promedio automaticamente. Presiona `C-c C-c` en la tabla para recalcular.

### Ejecutar codigo dentro de documentos (Org-babel)

Puedes tener bloques de codigo ejecutables dentro de tus documentos:

```org
#+BEGIN_SRC python :results output
for i in range(5):
    print(f"Linea {i}")
#+END_SRC
```

Presiona `C-c C-c` dentro del bloque y el resultado aparece debajo:

```org
#+RESULTS:
: Linea 0
: Linea 1
: Linea 2
: Linea 3
: Linea 4
```

Esto es ideal para:
- **Documentacion ejecutable:** Ejemplos de codigo que siempre estan actualizados
- **Cuadernos de laboratorio:** Como un Jupyter Notebook pero en texto plano
- **Informes con datos reales:** El informe incluye el codigo que genera los datos

---

## Ejercicio Practico: Crear un Informe Exportable

1. **Crea un archivo:** `C-x C-f` → `~/mi-informe.org`
2. **Agrega el encabezado:**
   ```org
   #+TITLE: Mi Primer Informe en FORJA
   #+AUTHOR: Tu Nombre
   #+DATE: \today
   #+LANGUAGE: es
   #+OPTIONS: toc:t num:t
   ```
3. **Agrega contenido:**
   ```org
   * Introduccion

   Este es mi primer documento exportable desde FORJA.

   * Datos

   | Item     | Cantidad | Precio |  Total |
   |----------+----------+--------+--------|
   | Tornillo |       10 |   0.50 |   5.00 |
   | Tuerca   |       10 |   0.30 |   3.00 |
   | Arandela |       20 |   0.10 |   2.00 |
   |----------+----------+--------+--------|
   | TOTAL    |          |        |  10.00 |
   #+TBLFM: $4=$2*$3;%.2f::@5$4=vsum(@2$4..@4$4);%.2f

   * Codigo de ejemplo

   #+BEGIN_SRC python :results output
   print("Hola desde el informe!")
   #+END_SRC

   * Conclusion

   FORJA permite generar documentos profesionales sin salir del editor.
   ```
4. **Recalcula la tabla:** Posicionate en la tabla y presiona `C-c C-c`
5. **Ejecuta el codigo:** Posicionate en el bloque Python y presiona `C-c C-c`
6. **Exporta a PDF:** `C-c C-e l o`
7. **Verifica** que el PDF tiene portada, tabla de contenidos, tabla con numeros y codigo

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| "LaTeX not found" al exportar PDF | texlive no esta instalado | En Arch: `sudo pacman -S texlive`. En Termux: no disponible |
| El PDF sale sin acentos | Falta paquete de idioma | Agrega `#+LATEX_HEADER: \usepackage[utf8]{inputenc}` |
| La tabla no calcula | La formula TBLFM tiene error | Verifica la sintaxis. Presiona `C-c C-c` en la linea `#+TBLFM:` |
| El bloque de codigo no se ejecuta | Org-babel no tiene el lenguaje habilitado | Es normal con algunos lenguajes. Python, C, Go deberian funcionar |
| `C-c e` no abre los modulos | Ruta de modulos incorrecta | Verifica que `~/.emacs.d/modules/` existe |
| El Kanban no aparece | Falta el paquete `org-kanban` | Ejecuta `M-x package-install RET org-kanban RET` |

## Resumen de Atajos de esta Guia

```
C-c c s      → Capturar ticket de soporte
C-c C-t      → Cambiar estado de ticket (INBOX/TODO/DONE)
S-↑ / S-↓   → Cambiar prioridad ([#A], [#B], [#C])

C-c C-e      → Menu de exportacion (PDF, HTML, texto)
C-c C-e l p  → Exportar a PDF (via LaTeX)
C-c C-e l o  → Exportar a PDF y abrir
C-c C-e h o  → Exportar a HTML y abrir
C-c C-x C-l  → Previsualizar formulas LaTeX

C-c C-c      → Ejecutar bloque de codigo / Recalcular tabla
C-c e        → Editar modulos de configuracion
C-c C-r      → Recargar configuracion de FORJA
```

---

**Anterior:** [Guia 10: Depuracion y Diagnostico](10_Depuracion_y_Diagnostico.md) | **Siguiente:** [Guia 12: Agentes IA Autonomos](12_Agente_Autonomo.md) | [Volver al README](../README.md)
