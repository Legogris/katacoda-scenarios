install_zip()
{
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

install_zip "nomad" "https://releases.hashicorp.com/nomad/0.10.3/nomad_0.10.3_linux_amd64.zip"
install_zip "consul" "https://releases.hashicorp.com/consul/1.6.3/consul_1.6.3_linux_amd64.zip"

mkdir -p /etc/nomad.d /etc/consul.d 
mkdir -p /opt/nomad/data /opt/consul/data

echo "Creating Nomad configuration file..."
  cat > /etc/nomad.d/logging.hcl <<EOF
log_level = "DEBUG"
EOF

  cat > /etc/nomad.d/node.hcl <<EOF
data_dir = "/opt/nomad/data"
server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
EOF

  cat > /etc/consul.d/config.hcl <<EOF
bootstrap_expect = 1
client_addr = "0.0.0.0"
data_dir = "/opt/consul/data"
datacenter = "dc1"
log_level = "DEBUG"
server = true
connect {
 enabled = true
}
ui = true
EOF

  cat > /etc/systemd/system/nomad.service <<EOF
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

# When using Nomad with Consul it is not necessary to start Consul first. These
# lines start Consul before Nomad as an optimization to avoid Nomad logging
# that Consul is unavailable at startup.
Wants=consul.service
After=consul.service

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=65536
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity
OOMScoreAdjust=-1000

[Install]
WantedBy=multi-user.target
EOF

  cat > /etc/systemd/system/consul.service <<EOF
[Unit]
Description=Consul
Documentation=https://consul.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/consul agent -config-dir /etc/consul.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=65536
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable consul
systemctl enable nomad
systemctl start consul
systemctl start nomad
