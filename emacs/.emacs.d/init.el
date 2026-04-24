;;; init.el --- Director de Orquesta Modular

(setq package-enable-at-startup nil)
(require 'org)

;; === 0. Detección de plataforma ===

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

;; === 0b. Leer profile.conf ===

(defun my/forja--read-conf ()
  "Lee ~/.forja/profile.conf y retorna un alist de (KEY . VALUE)."
  (let ((conf (expand-file-name "~/.forja/profile.conf"))
        result)
    (when (file-exists-p conf)
      (with-temp-buffer
        (insert-file-contents conf)
        (goto-char (point-min))
        (while (re-search-forward
                "^\\([A-Z_]+\\)=\"?\\([^\"\\n]*\\)\"?" nil t)
          (push (cons (match-string 1) (match-string 2)) result))))
    result))

(defvar my/forja-conf (my/forja--read-conf)
  "Alist con los valores de ~/.forja/profile.conf.")

(defun my/forja-feature-p (feature)
  "Retorna t si FEATURE está habilitado en FORJA_FEATURES del profile.conf."
  (let ((features (cdr (assoc "FORJA_FEATURES" my/forja-conf))))
    (when features
      (member feature (split-string features ",")))))

;; === 1. Directorios y listas de módulos ===

(defconst my-modules-dir (expand-file-name "modules/" user-emacs-directory))

(defvar my-base-modules '())
(defvar my-extra-modules '())
(defvar my-lazy-modules '())

;; === 2. Selección de módulos por plataforma ===

(cond

 ;; ── TERMUX (Android) ──────────────────────────────────────────────────────
 (my/is-termux
  (message "Detectado entorno TERMUX")
  (setq my-base-modules
        '("02-termux.org"
          "00-core.org"
          "01-dashboard.org"
          "10-git.org"
          "30-cpp.org"
          "31-rust.org"
          "32-go.org"
          "34-python.org"
          "35-php.org"
          "20-web.org"
          "42-lua.org"
          "43-zig.org"
          "44-java.org"))
  (setq my-extra-modules
        '("99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org")))

 ;; ── WSL2 (Windows) ────────────────────────────────────────────────────────
 (my/is-wsl
  (message "Detectado entorno WSL2")
  (setq my-base-modules
        (append
         '("00-core.org"
           "01-dashboard.org"
           "10-git.org"
           "30-cpp.org"
           "31-rust.org"
           "32-go.org"
           "34-python.org"
           "35-php.org"
           "20-web.org"
           "36-modelos.org"
           "42-lua.org"
           "43-zig.org"
           "44-java.org")
         (when (my/forja-feature-p "aider")  '("33-aider.org"))
         (when (my/forja-feature-p "godot")  '("41-godot.org"))))
  (setq my-extra-modules
        '("99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org")))

 ;; ── LINUX NATIVO (Arch, Ubuntu, cualquier distro) ─────────────────────────
 ;; No se requiere hostname específico — funciona en cualquier máquina
 ;; con Linux nativo donde FORJA haya sido instalado.
 (t
  (message "Detectado entorno LINUX NATIVO (usuario: %s, host: %s)"
           user-login-name (system-name))

  ;; Módulos base: siempre presentes en Linux nativo
  (setq my-base-modules
        (append
         '("00-core.org"
           "01-dashboard.org"
           "10-git.org"
           "30-cpp.org"
           "31-rust.org"
           "32-go.org"
           "34-python.org"
           "35-php.org"
           "36-modelos.org"
           "42-lua.org"
           "43-zig.org"
           "44-java.org")
         ;; Opcionales según FORJA_FEATURES en profile.conf
         (when (my/forja-feature-p "aider")  '("33-aider.org"))
         (when (my/forja-feature-p "godot")  '("41-godot.org"))))

  (setq my-extra-modules
        '("20-web.org"
          "99-misc.org"
          "49-multiusuario.org"
          "50-gtd.org"
          "51-estandarizacion.org"
          "52-vision-sistemica.org"
          "53-soporte.org"))

  ;; Módulos pesados — cargados lazy si están en features
  (setq my-lazy-modules
        (append
         (when (my/forja-feature-p "unreal")   '("40-unreal.org"))
         (when (my/forja-feature-p "picoclaw")  '("55-picoclaw.org"))
         (when (my/forja-feature-p "openclaw")  '("56-openclaw.org"))))))

;; === 3. Bucle de carga ===

(dolist (module (append my-base-modules my-extra-modules))
  (let ((file (expand-file-name module my-modules-dir)))
    (if (file-exists-p file)
        (org-babel-load-file file)
      (message "ALERTA: No encuentro el modulo %s" module))))

;; === 4. Carga lazy de módulos pesados (3s post-startup) ===

(when my-lazy-modules
  (run-with-idle-timer
   3 nil
   (lambda ()
     (dolist (module my-lazy-modules)
       (let ((file (expand-file-name module my-modules-dir)))
         (if (file-exists-p file)
             (progn
               (message "Cargando lazy: %s" module)
               (org-babel-load-file file))
           (message "Modulo lazy no encontrado: %s" module))))
     (message "Modulos lazy listos"))))

;; === 5. Customizaciones automáticas ===

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
