# Guía 05: Game Desarrollo y Sistemas Físicos

Esta guía trata todo lo cercano a la memoria nativa, interactividad 2D o 3D y componentes de bajo nivel cubiertos por los módulos: **30-cpp**, **40-unreal**, **41-godot**.

## C / C++ y Makefiles
Un estudiante rara vez querría luchar contra Makefiles al empezar a estudiar estructuras en C. El IDE FORJA provee simplificación pura:
1. **Andamio Mágico:** Crea un template nuevo (`C-c n C` para C++). Ya traerá un utilitario base `CMakeLists.txt` o `Makefile` configurado asépticamente.
2. **Click & Play (`F5`):** Cuando quieres saber qué hizo tu memoria iterando un Loop *For*, pulsar Correr `C-c x r` no ejecuta un simple `clang++ archivo.c`. FORJA examina qué gestor estás usando por sobreti y realiza una concatenación de Build -> Run con la salida nativa.
3. Lo último pero vital, la indentación en C/C++ se repara con `C-c x f` que llamará al estricto `clang-format` interno.

## Sistemas Físicos / Embebidos: ESP32 (Micro-chips)
Si utilizas un microcontrolador vía USB y su ecosistema estándar oficial de `Espressif` (ESP-IDF):
1. Todo tu proyecto del procesador tiene de frente el autocompletado global sin esfuerzo.
2. **Atajo Dorado: `F6`:** Esta tecla fue asignada a la cadena fundamental Flash + Serial.  
   - Emacs asume su rol, conecta al ttyACM0 o puerto expuesto, ejecuta de fondo `idf.py build`, en segundos `idf.py flash` al hardware, y por último abre automágicamente una terminal que se pone en estado escucha de `idf.py monitor` a esa misma placa para observar en serie a la consola sin presionar ningún comando manual durante la depuración continua con tu hardware en tu mano.

## Godot y su Lenguaje Dinámico: GDScript
(Solo disponible cuando se instala FORJA en PC Local / Arch Linux):
1. FORJA sabe que GDScript precisa estar atado permanentemente al "Motor Externo". Ocurre internamente instalando hooks al LSP para portos TCP del ecosistema abierto Godot que corre minimizado u oculto en tu monitor.
2. Abre cualquier recurso `.gd` y gozarás de autocompleado como nativo gracias a las clases.
3. El formato del texto usa `gdformat` directo usando la tecla de Format del Hydra.

## Unreal Engine 4/5 (C++ Extremo)
El desarrollo con UE es brutal con los recursos. FORJA detectará un perfil que sea exclusivo llamado "CASA" y adaptará su consumo para esto.
- Suprime auto-analizadores pesados globales o `Treemacs` intentando mirar un millón de cabeceras visuales, y deja actuar exclusivamente el binario de LSP sin Indexador en subcarpetas para fluir dentro del Unreal en un editor veloz que interactúa sin trancarse con grandes proyectos monolíticos de código abierto donde cada letra digitada requeriría una lectura de 5 GBs de RAM por parte de los pre-formateadores.
- Usa los mismos flujos de CMake que C++.

---
[⬅️ Volver al README](../README.md)
