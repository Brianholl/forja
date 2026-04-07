# Guía 06: Inteligencia Artificial Autónoma (Aider)

FORJA no concibe enseñar un IDE de clase mundial sin empoderar las bases con IA sin dependencias de internet cerradas. El módulo **33-aider** está integrado 100% mediante componentes Open Source corriendo sobre las librerías base para actuar directo sobre tu proyecto.

## Requisitos Base
- Una computadora PC (Generalmente no provisto en perfiles Androide-Termux)
- Ollama instalado a nivel de SO y un modelo cuantizado compatible activado (Ej: **qwen2.5-coder** predeterminado).
- **NO necesitas API KEYS**, OpenAI, o acceso a la nube. TODO ocurre en estricta privacidad local.

## Empezando con Aider
Aider no es un chat bot que copie y pegue código; Aider tiene permisos para abrir tus documentos, leerlos como terminal y re-escribir funciones in-sitio mediante Git.

- **Menu Principal IA (`C-c i`)**: (Inteligencia-Artificial). Esto abrirá tus utilidades de IA y lanzará un menú específico.

A partir de este menú flotante, las acciones primordiales:

### 1. Iniciar IA y Conversar en tu Proyecto
`C-c i o` -> (Open). El chat general intermedio dividirá tu ventana habilitando una interfaz amena en donde la inteligencia y tú conversan de igual a igual. Lo que pidas será planificado y aplicado instantáneamente al código colindante usando un "Commit Diferencial". Escribe en lenguaje natural abajo: *"Por favor implementa un control de movimiento en este script player.go"*.

### 2. Dar Contexto (Añadir al Buffer)
Tu IA no puede adivinar qué archivos tiene tu proyecto masivo a menos que se lo digites.
`C-c i a` -> (Add). Seleccionando un par de archivos y apretando esto, metes estos módulos al flujo de corto plazo de la memoria de la IA. Por lo que luego podrás pedir "Haz que los colores de `main.css` combinen con los títulos definidos de `layout.html`".

### 3. Tareas Directas Dirigidas desde tu Cursor
No siempre requiereres abrir el "chat", y quieres órdenes puntuales:
- **Refactor Focalizado (`C-c i c`):** Sombrea o párate sobre un bloque de código y actívalo. Aparecerá una mini ventana donde tiras la orden rápida como "Cambiar todas estas variables a camelCase".
- **Generar Tests Automatizados (`C-c i t`):** Mágico. Abre la función de lógica del negocio que desees (ej: un validador de Email) y presionalo. Aider fabricará para ti un archivo `_test` al lado invocando casos límite útiles.
- **Auto-Corrector (`C-c i f`):** Linter (FlyCheck) indica en rojo "Esto falla por una importación no declarada". Teclea la letra f. Se capturará toda la salida del compilador que falla más el código e intentará reparar el problema por sí mismo devolviéndotelo listo y funcionando.

---
[⬅️ Volver al README](../README.md)
