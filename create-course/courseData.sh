install_zip()
{
  NAME="$1"
  if [ ! -f "/usr/local/bin/$NAME" ]
  then
    DOWNLOAD_URL="$2"
    curl -L -o ~/$NAME.zip $DOWNLOAD_URL
    sudo unzip -d /usr/local/bin/ ~/$NAME.zip
    sudo chmod +x /usr/local/bin/$NAME
    rm ~/$NAME.zip
  fi
}

install_zip "nomad" "https://releases.hashicorp.com/nomad/0.10.3/nomad_0.10.3_linux_amd64.zip"

sudo mkdir -p /etc/nomad.d
sudio mkdir -p /opt/nomad/data

