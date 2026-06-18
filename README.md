# chamu-packages

All my personal packages for guix

## How to add


Add this to channels.scm
```
(cons (channel
        (name 'chamu-packages)
        (url "https://github.com/TobyJ-B/chamu-packages")
        (branch "main")
        (introduction
         (make-channel-introduction
          "8978834b3856ae83f9e8901712785605618d8511"
          (openpgp-fingerprint
           "46529530CEA2EA53C2EB5769BE730730B14BFE1C")))))
```

Then run:

```
guix pull
```

# Packages included

- Neovim Nightly
- gai
- shermans-aquarium


