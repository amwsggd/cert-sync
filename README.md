# Web https certs files sync based on rsync

sync https certs files from one to others

use `preparation.sh` to copy files to the remote using rsync
> prepartion.sh also includes a parameter `exclude` to use exclude-file.txt for rsync

use `deploy-cert.sh` to deploy cert which is here and also call the `deploy-locally.sh` both in local and in remote
> the `deploy-locally.sh` file path is temporarily hard-coded 


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

# Hook usage

It's recommend to use a hook to call `deploy-cert.sh` when certs files are updated

## use Systemd.path as certs updating listener

use the file changing below as trigger which is cross-platform supported as the `:` is built-in command in shell
```sh
sudo sh -c ': > /opt/acme/hooks/example.com.renewed'
```

`/etc/systemd/system/deploy-cert-example.com.service`
```ini
[Unit]
Description=Deploy renewed certificate for example.com

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/deploy-cert-example.com.sh
```

`/etc/systemd/system/deploy-cert-example.com.path`
```ini
[Unit]
Description=Watch acme renewal trigger for example.com

[Path]
PathChanged=/opt/acme/hooks/example.com.renewed
Unit=deploy-cert-example.com.service

[Install]
WantedBy=multi-user.target
```

enable it
```sh
sudo systemctl daemon-reload
sudo systemctl enable --now deploy-cert-example.com.path
```

test
```sh
sudo sh -c ': > /opt/acme/hooks/example.com.renewed'
```
