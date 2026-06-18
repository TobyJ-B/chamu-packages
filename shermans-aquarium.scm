;;; GNU Guix package definition for Sherman's Aquarium
;;;
;;; Depends on the gai package defined in gai.scm.
;;; Both files must live in the same directory (or the same channel module tree)
;;; so that (gai) can be resolved.
;;;
;;; To build/install:
;;;   guix package -f shermans-aquarium.scm -e '(@ (shermans-aquarium) shermans-aquarium)'
;;;   guix build  -f shermans-aquarium.scm -e '(@ (shermans-aquarium) shermans-aquarium)'

(define-module (shermans-aquarium)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (gai))               ; pulls in the gai package defined in gai.scm

(define-public shermans-aquarium
  (package
    (name "shermans-aquarium")
    (version "3.0.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/norayr/shermans_aquarium")
             (commit "7f3a267248216bccb43ec58e69ddbaa28988bc98")))       
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jslghmbrx0kq7r2zmczn0d0c7d5gd04drklf2d1ybpgygw4zsga"))))

    (build-system gnu-build-system)

    (native-inputs
     (list pkg-config))

    (inputs
     (list gai       ; pkg-config finds gai.pc automatically via Guix's PKG_CONFIG_PATH
           gtk+-2))

    (arguments
     (list
      #:configure-flags
      '(list "--with-gai"
             "--without-sdl"    ; skip XScreenSaver / SDL support
             "--without-xmms")  ; skip XMMS visualisation plugin

      #:phases
      #~(modify-phases %standard-phases
          ;; Upstream bug: shermans/shermans_applet is not installed by make install.
          ;; This replicates the manual `cp` documented in the README.
          (add-after 'install 'install-applet
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (bin (string-append out "/bin")))
                (install-file "shermans/shermans_applet" bin))))

          ;; Wrap the binary so libgai.so is found without needing LD_LIBRARY_PATH
          ;; in the user's shell – replaces the manual prefix in the README.
          (add-after 'install-applet 'wrap-applet
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (gai (assoc-ref inputs  "gai")))
                (wrap-program (string-append out "/bin/shermans_applet")
                  `("LD_LIBRARY_PATH" ":" prefix
                    (,(string-append gai "/lib"))))))))))

    (synopsis "Sherman's Lagoon fish aquarium dockapp / GNOME panel applet")
    (description
     "Sherman's Aquarium places an animated aquarium full of fish from Jim
Toomey's @emph{Sherman's Lagoon} comic strip into a Window Maker dockapp or a
GNOME 2 panel applet.  Fish swim back and forth across the screen; the applet
can also display system-status information.  This is a revival of the original
SourceForge project, brought back to life by Norayr Chilingarian.")
    (home-page "https://github.com/norayr/shermans_aquarium")
    (license gpl2)))  ; COPYING is GPL-2.0
