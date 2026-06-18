;;; GNU Guix package definition for GAI – General Applet Interface Library
;;;
;;; To build/install standalone:
;;;   guix package -f gai.scm -e '(@ (gai) gai)'
;;;   guix build  -f gai.scm -e '(@ (gai) gai)'

(define-module (gai)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xorg))

(define-public gai
  (package
    (name "gai")
    (version "0.5.99.9")           
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/norayr/gai")
             (commit "cc8f2f08e5fde01743cc2548fec850daae3da329")))       
       (file-name (git-file-name name version))
       (sha256
        (base32 "186crbgh6rw8ygjrw0j8qh7plv5q2r6lxp5rxlx8cflj2fgzmird"))))

    (build-system gnu-build-system)

    ;; The repo ships a pre-generated `configure` script, so autoconf/automake
    ;; are not needed at build time.
    (native-inputs
     (list pkg-config))

    (inputs
     (list
      gtk+-2    ; satisfies gtk+-2.0 and gthread-2.0 from gai.pc.in
      glib      ; gthread-2.0
      pango     ; pangoft2
      libx11))  ; X11 dockapp / window-manager support

    (arguments
     (list
      #:configure-flags
      '(list "--disable-gl"     ; skip OpenGL applet support (optional)
             "--disable-rox"    ; skip ROX panel support     (optional)
             "--with-dockapp")  ; build the Window Maker dockapp backend

      #:phases
      #~(modify-phases %standard-phases
          (add-before 'configure 'patch-makefile-in
            (lambda _
              (substitute* "Makefile.in"
                (("/usr/local") #$output)))))))

    (synopsis "General Applet Interface Library")
    (description
     "GAI is a C library that abstracts over Window Maker dockapps, GNOME 2
panel applets and ROX panel applets so that a single program can appear in all
three environments without change.  It provides image handling via GdkPixbuf,
configuration storage, a preference-window framework, and event routing.")
    (home-page "https://github.com/norayr/gai")
    (license lgpl2.0+)))  ; COPYING.LIB is LGPL-2.0+
