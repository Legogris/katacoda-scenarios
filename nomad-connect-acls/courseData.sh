fix_journal() {
  # This fixes an issue with the katacoda base machine that causes journald to
  # fail on startup - H/T https://serverfault.com/a/800047
  if [ ! -f "/etc/machine-id" ]
  then
    systemd-machine-id-setup
    systemd-tmpfiles --create --prefix /var/log/journal
    systemctl start systemd-journald.service
  fi
}

install_cni_plugins() {
  if [ ! -d "/opt/cni/bin" ]
  then
    curl -L -o cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.4/cni-plugins-linux-amd64-v0.8.4.tgz
    sudo mkdir -p /opt/cni/bin
    sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz
  fi
}

install_zip() {
  NAME="$1"
  if [ ! -f "/usr/local/bin/$NAME" ]
  then
    DOWNLOAD_URL="$2"
    curl -L -o /tmp/$NAME.zip $DOWNLOAD_URL
    sudo unzip -d /usr/local/bin/ /tmp/$NAME.zip
    sudo chmod +x /usr/local/bin/$NAME
    rm /tmp/$NAME.zip
  fi
}

install_service() {
  if [ ! -f "/etc/${1}.d/config.hcl" ]
  then
    mkdir -p /etc/${1}.d /opt/${1}/data
    cp /var/tmp/${1}_config.hcl /etc/${1}.d/config.hcl
    cp /var/tmp/${1}.service /etc/systemd/system/${1}.service
    systemctl daemon-reload
  fi
}

## main

fix_journal
install_cni_plugins

install_zip "consul" "https://releases.hashicorp.com/consul/1.7.0/consul_1.7.0_linux_amd64.zip"
install_service "consul"

install_zip "nomad" "https://releases.hashicorp.com/nomad/0.10.4-rc1/nomad_0.10.4-rc1_linux_amd64.zip"
install_service "nomad"

systemctl start consul nomad

ln -s /etc/nomad.d
ln -s /etc/consul.d
