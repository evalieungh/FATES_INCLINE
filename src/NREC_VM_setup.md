# my workflow for setting up the LSP on an NREC virtual machine with extra volume

LSP instructions at: https://noresmhub.github.io/noresm-land-sites-platform/documentation/#ssh-tunneling-with-example-for-nrec

See also https://github.com/NorESMhub/noresm-land-sites-platform/issues/156

- cloned repo
- changed BACKEND_CORS_ORIGINS=["http://localhost:8000", "http:-ocalhost:8080"] to BACKEND_CORS_ORIGINS=["*"]
- install Docker with this guide: https://docs.docker.com/engineinstall-buntu/ 
- sudo usermod -a -G docker $USER
- newgrp docker
- screen -S lsp
- cd noresm-land-sites-platform
- (add these things to new .env file? https://github.comNorESMhub-oresm-land-sites-platform/blob/main/run_linux.sh)
- docker compose up (eller kanskje bedre: vi run_linux.sh, i,endre-ocker-compose til docker compose, esc :wq, ./run_linux.sh)
- CTRL+a and CTRL+d, screen -list
- ssh -i .ssh/evaskey -L 8000:localhost:8000 -N -f ubuntu@158.39.75.164
- ssh -i .ssh/evaskey -L 8080:localhost:8080 -N -f ubuntu@158.39.75.164
- ssh -i .ssh/evaskey -L 8888:localhost:8888 -N -f ubuntu@158.39.75.164
- ssh -i .ssh/evaskey -L 5800:localhost:5800 -N -f ubuntu@158.39.75.164
- ... do stuff in GUI, then shut things down and download data:
- ..
- make volume and attach to instance, then mount the instance and move stuff there: https://github.com/NorESMhub/noresm-land-sites-platform-ssues/157
- cd ../../../data
- sudo cp -R ../../home/ubuntu/noresm-land-sites-platform/ lsp
- cd lsp/noresm-land-sites-platform/
- give current user (ubuntu) ownership of new folder to avoid need for sudoin every command: 
ubuntu@el-lsp:/data$ sudo chown -R ubuntu: lsp
		
check file use: df -H

****************************

## Log into the VM and move to working directory on mounted volume:

```
ssh -i .ssh/evaskey ubuntu@158.39.75.164
cd ../../../data
```

