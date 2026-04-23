;;; early-init.el --- Pre-init: máximo rendimiento antes de cargar paquetes

;; GC alto durante startup para evitar pausas mientras cargan los módulos
(setq gc-cons-threshold (* 128 1024 1024))

;; Suprimir UI antes de que el frame se cree → evita resize/flicker
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; El package system lo maneja init.el
(setq package-enable-at-startup nil)
