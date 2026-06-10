# Web https certs files sync based on rsync

sync https certs files from one to others

use `preparation.sh` to copy files to the remote using rsync
> prepartion.sh also includes a parameter `exclude` to use exclude-file.txt for rsync

use `deploy-cert.sh` to deploy cert which is here and also call the `deploy-locally.sh` both in local and in remote
> the `deploy-locally.sh` file path is temporary hard-coded 


it's recommended to use a hook to call `deploy-cert.sh` when certs files are updated


ideal file structure
```
.
├── certs
│   └── xx.xx.com
│       ├── fullchain.pem
│       └── private.pem
├── other-config-files.conf
└── shes
    ├── deploy-cert.sh
    ├── deploy-locally.sh
    ├── exclude-file.txt
    ├── LICENSE
    ├── preparation-remote-hosts-dir.txt
    ├── preparation.sh
    ├── README
    └── remote-hosts-dir.txt
```

