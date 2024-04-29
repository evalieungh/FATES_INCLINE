# my workflow for setting up the LSP on an NREC virtual machine with extra volume

Assumes Virtual machine and Volume has already been created at nrec.no. Norwegian Research and Education Cloud, nrec.no, provides virtual machines for University of Oslo users and some others in Norway. Two VMs were set up to increase capacity. See https://github.com/NorESMhub/noresm-land-sites-platform-ssues/157

- log in to virtual machine (`ssh -i .ssh/evaskey ubuntu@158.39.75.164` personal NREC project, cosmo forcing,  `ssh -i .ssh/evaskey ubuntu@158.37.63.209` for LSP NREC project, warmed cosmo + gswp3 forcing)

### Mount Volume on VM for extra storage space

- Make a file system on the disk: `sudo mkfs.xfs /dev/sdb`
- Make a mount point (folder to mount volume in) e.g. called "data" directly under root: `sudo mkdir /data`
- Mount the volume: `sudo mount /dev/sdb /data`

This is not persistent after rebooting the VM (last time I only needed to repeat the last step of mounting the volume). To check storage use: `df -H`

### Install LSP on VM

Modified and expanded on from LSP instructions: https://noresmhub.github.io/noresm-land-sites-platform/documentation/#ssh-tunneling-with-example-for-nrec

- navigate to mounted volume (`cd ../../../data`, see https://github.com/NorESMhub/noresm-land-sites-platform/issues/156)
- clone repo (`git clone https://github.com/NorESMhub/noresm-land-sites-platform.git --config core.autocrlf=input`)
- change BACKEND_CORS_ORIGINS=["http://localhost:8000", "http:-ocalhost:8080"] to BACKEND_CORS_ORIGINS=["*"]
- install Docker with this guide: https://docs.docker.com/engine/install/ubuntu/ 
- `sudo usermod -a -G docker $USER`
- `newgrp docker`
- `screen -S lsp`
- `cd noresm-land-sites-platform`
- give current user (ubuntu) ownership of folder to avoid need for sudo before every command: 
ubuntu@el-lsp:/data$ sudo chown -R ubuntu: lsp (add these things to new .env file? https://github.comNorESMhub-oresm-land-sites-platform/blob/main/run_linux.sh)
- docker compose up (or `vi run_linux.sh`, i, change docker-compose to docker compose, esc, :wq, `./run_linux.sh`)
- detach (hide/close wihtout quitting) the screen with CTRL+a and CTRL+d, 
- the screen should be visible under `screen -list` and can be opened again with `screen -r lsp`
- Open a new local terminal and enable ssh port listening to the relevant NorESM-LSP ports:
- `ssh -i .ssh/evaskey -L 8000:localhost:8000 -N -f ubuntu@158.39.75.164`
- `ssh -i .ssh/evaskey -L 8080:localhost:8080 -N -f ubuntu@158.39.75.164`
- `ssh -i .ssh/evaskey -L 8888:localhost:8888 -N -f ubuntu@158.39.75.164`
- `ssh -i .ssh/evaskey -L 5800:localhost:5800 -N -f ubuntu@158.39.75.164`
- ... do stuff in GUI, then shut things down once the simulation is complete (stop container with Ctrl-C, delete the screen with `screen -XS lsp quit`)
- download data from local terminal, in the format `scp -r [user]@[ip]:[remote_path_to_lsp]/resources/cases/[case_folder_name] [local_save_path]`, for example `scp -r -i .ssh/evaskey ubuntu@158.39.75.164:/data/evalieungh-fork/noresm-land-sites-platform/resources/cases/fc34e8ad047f81cf1289be212fdb43ac_alp4-1500-cosmo-ibsp /mnt/c/Users/evaler/Downloads`

****************************

## Log into the VM and move to working directory on mounted volume:

```
ssh -i .ssh/evaskey ubuntu@158.39.75.164
cd ../../../data
```

### Additional notes:

Close ssh connection, for example if you need to open another. Find remote connections, kill relevant ones:
```
Ps aux
Kill <PID>
```

To make it faster to listen to ports and to close them all down again, I made three simple bash scripts to set up port listening and to 'kill' post listening. Example bash script lspUIs.sh (and another one for the VM on another IP address) sets up listening to all the ports and looks like this:
```
#!/bin/bash
ssh -i .ssh/evaskey -L 8000:localhost:8000 -N -f ubuntu@158.39.75.164
ssh -i .ssh/evaskey -L 8080:localhost:8080 -N -f ubuntu@158.39.75.164
ssh -i .ssh/evaskey -L 8888:localhost:8888 -N -f ubuntu@158.39.75.164
ssh -i .ssh/evaskey -L 5800:localhost:5800 -N -f ubuntu@158.39.75.164
```

...and kill-lsp-port-listening.sh looks like this:
```
#!/bin/bash
fuser -k 8080/tcp
fuser -k 8000/tcp
fuser -k 8888/tcp
fuser -k 5800/tcp
```

each script was made using `vi scriptname.sh`, pressing i, entering the content, press esc, and save with :wq. To give current user permission to execute, I used `sudo chmod u+x scriptname.sh`.

Find "search phrase" inside any/all files in current directory:
`grep -r "search phrase"`