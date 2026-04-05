;;; init.el --- Director de Orquesta Modular

(setq package-enable-at-startup nil)
(require 'org)

;; 0. Detección de plataforma
(defvar my/is-termux
  (or (getenv "TERMUX_VERSION")
      (and (getenv "HOME")
           (string-prefix-p "/data/data/com.termux" (getenv "HOME"))))
  "Non-nil si estamos corriendo en Termux (Android).")

(defvar my/is-gui (display-graphic-p)
  "Non-nil si Emacs corre en modo gráfico (X11/Wayland/pgtk).")

(defvar my/is-wsl
  (and (not my/is-termux)
       (file-readable-p "/proc/version")
       (with-temp-buffer
         (insert-file-contents "/proc/version")
         (string-match-p "microsoft\\|WSL" (buffer-string))))
  "Non-nil si estamos corriendo en WSL2 (Windows Subsystem for Linux).")

;; 1. Definir dónde viven los módulos
(defconst my-modules-dir (expand-file-name "modules/" user-emacs-directory))

;; 2. Definir Módulos BASE (Se cargan SIEMPRE en cualquier máquina)
(defvar my-base-modules '())

;; 3. Definir Perfiles por Máquina
(defvar my-extra-modules '())

(cond
 ;; CASO TERMUX: Android (se evalúa primero)
 (my/is-termux
  (message "📱 Detectado entorno TERMUX (Android)")
  (setq my-base-modules
        '("00-core.org"
          "01-dashboard.org"
          "10-git.org"
          "30-cpp.org"      ; C/C++ (sin GDB, sin FASM, sin ESP32)
          "31-rust.org"
          "32-go.org"
          "34-python.org"
          "35-php.org"
          "20-web.org"))
  (setq my-extra-modules
        '("99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org")))

 ;; CASO WSL: Windows Subsystem for Linux (PCs del hogar con Windows)
 (my/is-wsl
  (message "🪟 Detectado entorno WSL2 (Windows)")
  (setq my-base-modules
        '("00-core.org"
          "01-dashboard.org"
          "10-git.org"
          "30-cpp.org"
          "31-rust.org"
          "32-go.org"
          "34-python.org"
          "35-php.org"
          "20-web.org"))
  (setq my-extra-modules
        '("99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org")))

 ;; CASO 1: ESCUELA (Usuario "estudiante" en hostname "archlinux")
 ((and (string-equal (system-name) "archlinux")
       (string-equal user-login-name "estudiante"))
  (message "🏫 Detectado entorno ESCUELA (Usuario: estudiante)")
  (setq my-base-modules
        '("00-core.org"
          "01-dashboard.org"
          "10-git.org"
          "30-cpp.org"    ; Solo C/C++, ASM y ESP32
          "31-rust.org"
          "32-go.org"
          "34-python.org"
          "35-php.org"
          "33-aider.org"
          "41-godot.org"))
  (setq my-extra-modules
        '("20-web.org"
          "99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org")))

 ;; CASO 2: CASA (Usuario "casa" en hostname "archlinux")
 ((and (string-equal (system-name) "archlinux")
       (string-equal user-login-name "casa"))
  (message "🏠 Detectado entorno CASA (Usuario: casa)")
  (setq my-base-modules
        '("00-core.org"
          "01-dashboard.org"
          "10-git.org"
          "30-cpp.org"
          "31-rust.org"
          "32-go.org"
          "34-python.org"
          "35-php.org"
          "33-aider.org"
          "41-godot.org"))
  (setq my-extra-modules
        '("20-web.org"
          "40-unreal.org"
          "99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org")))

 ;; CASO 3: Fallback (Cualquier otra máquina desconocida)
 (t
  (message "⚠️ Máquina desconocida: Cargando configuración segura por defecto")
  (setq my-base-modules
        '("00-core.org"
          "01-dashboard.org"
          "10-git.org"
          "30-cpp.org"
          "31-rust.org"
          "32-go.org"
          "34-python.org"
          "35-php.org"
          "33-aider.org"
          "41-godot.org"))
  (setq my-extra-modules
        '("20-web.org"
          "99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org"))))

;; 4. Bucle de Carga (The Loader)
(dolist (module (append my-base-modules my-extra-modules))
  (let ((file (expand-file-name module my-modules-dir)))
    (if (file-exists-p file)
        (org-babel-load-file file)
      (message "⚠️ ALERTA: No encuentro el módulo %s" module))))

;; 5. Cargar customizaciones automáticas (si existen)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
