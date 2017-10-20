export CUCUMBER_SSHD_LISTEN=127.0.0.1
export CUCUMBER_SSHD_PERSIST=yes
export CUCUMBER_SSHD_WAIT_READY=yes

eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
