# Guía 04: Lenguajes de Backend y API

FORJA agrupa diversos módulos (`31-rust`, `32-go`, `34-python`, `35-php`) de alto impacto académico y profesional como pilar conceptual de servidores, sin mezclar sus entornos entre sí.

## Python (Módulo 34)
- **Modo Scripting Interactivo:** Tienes un archivo rápido `calculo.py`, presiona `F5` o (`C-c x r` en Hydra) y lo ejecutas viendo el resultado en el margen con intérprete interactivo.
- **FastAPI / Django (Detección Auto-Framework):** Supón que generaste un proyecto de tipo API con la opción Template en Python de FORJA. Al tener de cara cualquier archivo de este proyecto, si oprimes `F5`, no estás corriendo un "subscript", sino que `uvicorn server:app --reload` va a revivir el hilo recargado para ver tu API en Swagger local instantáneo.
- **Estándar con `black`:** Presionar `f` desde Hydra auto-organiza las líneas y longitudes como demanda la PEP-8 estricta.

## Go (Módulo 32)
- **Go Run Directo:** De nueva forma, presionar `F5` compila y corre el binario temporal simulando modo script (`go run .`).
- **El `gopls` es el estándar oro:** Frecuentemente verás interfaces vacías. Teclas sugeridas para fluir con Go: `F12` te lleva a qué es la definición real de ese paquete nativo o `Puntero`.  
- **Test In-Screen:** Usa el archivo gemelo `auth_test.go`, y presiona `C-c x t` en menú Hydra para colorear tests positivos o negativos en sus líneas de respuesta específicas del bloque de la función, súper visual.

## Rust (Módulo 31)
Un lenguaje implacable, domesticado en tu IDE bajo `Cargo` y su motor local Tree-sitter:
- **Build / Run / Test:** Tienen acciones puras mapeadas al Hydra: `b` para Compilar (Cargo Build), `r` para Correr (Cargo Run), y `t` ejecuta el módulo local de `#[cfg(test)]`.
- **Flycheck y Referencias de Tipos Incrustadas:** El "Linter", mientras tecles en Rust, te dibuja tipos que han inferido su resultado o vida útil, y cuando no compila, incrusta mensajes multilinea gigantes directos para el entendimiento como si fuera `cargo fix`.

## PHP Frameworks (Módulo 35)
Un lenguaje fundamental para transiciones Web:
- **Intelephense en PHP Puros:** Archivos desconectados son nutridos por el LSP y corren su cli (`php archivo.php`) simplemente con `F5`.
- **Framework LARAVEL:** Si FORJA detecta la firma estructural del framework de Symfony (ej: documento bin `artisan` alojado en base), la meta principal del IDE cambiará sutilmente. Y cuando decidas darle Play (Ejecutar en Hydra o `F5`), el entorno reacciona iniciando el server de Laravel `php artisan serve`, para comenzar las pruebas Web de inmediato.

---
[⬅️ Volver al README](../README.md)
