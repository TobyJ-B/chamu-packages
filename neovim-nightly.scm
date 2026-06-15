(define-module (chamu-packages neovim-nightly)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages libevent)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:))

;; A newer libuv since neovim nightly's time.c needs uv_clock_gettime
;; and friends, added in libuv 1.45.0. Guix currently ships 1.44.2.
(define-public libuv-next
  (package
    (inherit libuv)
    (name "libuv-next")
    (version "1.52.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dist.libuv.org/dist/v" version
                            "/libuv-v" version "-dist.tar.gz"))
       (sha256
        (base32 "0sidp0jqf3220wkqapyr22g4jn85j9vw8fqw26v86yzsw8alkwf5"))))))

;; lua5.1-luv bundles its own libuv, which also needs updating so
;; vim.uv exposes the newer libuv API (e.g. available_parallelism),
;; added to the luv binding in 1.44.0-0.
(define-public lua5.1-luv-next
  (let ((commit "v1.50.0-0")
        (version "1.50.0-0"))
    (package
      (inherit lua5.1-luv)
      (version version)
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/luvit/luv")
               (commit commit)))
         (file-name (git-file-name "lua5.1-luv" version))
         (sha256
          (base32 "0hfq12qpl0b2m6fzfaj73cbcyjncqp439rlhzx40lc7rzisbqajc"))))
      (inputs
       (modify-inputs (package-inputs lua5.1-luv)
         (replace "libuv" libuv-next))))))

(define-public neovim-nightly
  (let ((commit "b55a8683091137142fe35469d922605266de6dda"))
    (package
      (inherit neovim)
      (name "neovim-nightly")
      (version (git-version (package-version neovim) "0" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/neovim/neovim")
               (commit commit)))
         (file-name (git-file-name "neovim-nightly" commit))
         (sha256
          (base32 "1anpadhb88zcvgp9rmrzic5dhqr990q85ngi86zflh3pcsvwhj62"))))
      (inputs
       (modify-inputs (package-inputs neovim)
         (replace "libuv" libuv-next)
         (replace "lua5.1-luv" lua5.1-luv-next))))))
