# FORJA — Filosofía

> "El que forja sus propias herramientas no depende de nadie para usarlas."

---

## El problema que resuelve FORJA

La educación en programación tiene un problema estructural: enseña a usar
herramientas sin enseñar a entenderlas. El alumno aprende a presionar F5,
no a saber qué hace F5. Aprende a instalar extensiones, no a configurar
su entorno. Aprende en una caja negra que otro construyó.

Cuando la caja falla —y siempre falla— el alumno no tiene herramientas
para diagnosticar. Depende del que construyó la caja.

FORJA existe para romper ese ciclo.

---

## Soberanía personal

El alumno que termina el curso no solo sabe programar — sabe construir
y mantener su propio entorno de desarrollo.

Eso es soberanía personal sobre las herramientas: no depender de que
alguien más actualice la extensión, configure el linter, o entienda
por qué el debugger no conecta. Saber leerlo, modificarlo, repararlo.

Un desarrollador que no entiende su entorno es tan dependiente como
un carpintero que no sabe afilar sus herramientas.

---

## Autogestión

FORJA no es un IDE que se instala y se usa. Es un entorno que se habita
y se hace propio.

La autogestión empieza desde el día uno: el alumno instala FORJA desde
el terminal, entiende qué instala y por qué, configura su perfil,
y aprende que cada decisión del entorno tiene una razón.

La autogestión madura cuando el alumno modifica `local.el` para cambiar
un atajo, lee un módulo `.org` para entender cómo funciona el LSP,
o agrega su propia configuración al proyecto.

No hay autogestión sin transparencia. Por eso FORJA no esconde nada:
cada atajo tiene un comando real detrás, cada módulo es código legible,
cada decisión de diseño tiene un comentario que explica el porqué.

---

## La filosofía Tsoding

Tsoding (Alexey Kutepov) trabaja con una premisa simple:
**si no lo construiste, no lo entendés del todo**.

No como dogma — usar librerías y herramientas está bien.
Sino como postura: siempre saber qué hay una capa abajo.
Saber que `npm run dev` ejecuta `tsx watch src/index.ts`.
Saber que `tsx` es un runtime que transpila TypeScript en memoria.
Saber que sin `node_modules/` no hay `tsx`, aunque el script exista.

Esa postura frente al código es lo que separa a un programador
que resuelve problemas de uno que busca soluciones en Stack Overflow.

FORJA enseña a programar de esa manera: entendiendo las capas,
no ignorándolas.

---

## El Emacs Way

FORJA está construido sobre Emacs. Eso no es una decisión técnica —
es una decisión filosófica.

Emacs es el único editor donde cada tecla es una función con nombre,
cada función tiene documentación y código fuente accesible,
y la configuración completa es código que el usuario puede leer,
modificar y publicar.

`C-h k F5` muestra qué hace F5.
`C-h f my/hydra-build` muestra el código fuente de la hydra.
`M-x describe-mode` explica el modo activo.

Nunca abandonamos el Emacs Way porque es exactamente eso lo que
queremos que los alumnos aprendan: que las herramientas son código,
que el código es legible, y que leerlo es siempre una opción.

Un IDE que no podés leer es una caja negra.
Un IDE hecho en Lisp que configurás vos mismo es un proyecto propio.

---

## La progresión pedagógica

FORJA no espera que el alumno entienda todo desde el día uno.
La complejidad se revela en capas, a medida que el alumno la busca:

**Nivel 1 — Usuario:** usa los atajos, compila, ejecuta, depura.
El entorno funciona sin que el alumno sepa por qué.

**Nivel 2 — Curioso:** pregunta qué hace F5. Lee el `FORJA.md`
del proyecto. Entiende que hay un comando real detrás del atajo.

**Nivel 3 — Configurador:** modifica `local.el`. Agrega un atajo.
Cambia el comportamiento de algo que no le gusta.

**Nivel 4 — Hacedor:** lee un módulo `.org`. Entiende la estructura
de FORJA. Contribuye una configuración, un snippet, una mejora.

La Clase 17 — El Taller del Herrero — es el momento bisagra:
cuando el IDE deja de ser una herramienta opaca y se convierte
en un proyecto que el alumno puede llamar suyo.

---

## Lo que FORJA no es

FORJA no es VSCode con tema oscuro.
No es una capa de abstracción sobre herramientas que el alumno
nunca va a entender.
No es un entorno que "simplemente funciona" a costa de esconder cómo.

La comodidad que esconde complejidad crea dependencia.
La transparencia que expone complejidad crea competencia.

FORJA elige la segunda.

---

## En síntesis

FORJA es un entorno de desarrollo educativo construido sobre la convicción
de que la mejor manera de aprender a programar es teniendo propiedad real
sobre las herramientas que usás: entenderlas, modificarlas, romperlas
y repararlas.

Eso requiere transparencia, autogestión, soberanía personal,
y un IDE que nunca esconda lo que está haciendo.

El Emacs Way no es un obstáculo pedagógico — es el punto.
