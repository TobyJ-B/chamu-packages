# chamu-packages

All my personal packages for guix

## How to add


Add this to channels.scm
```
(cons (channel
        (name 'chamu-packages)
        (url "https://github.com/youruser/chamu-packages")
        (branch "main")
        (introduction
         (make-channel-introduction
          "8978834"
          (openpgp-fingerprint
           "46529530CEA2EA53C2EB5769BE730730B14BFE1C")))))
```

