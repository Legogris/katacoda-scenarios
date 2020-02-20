if [ ! -f ~/nomad.d/config.hcl ]
then
  echo -n "Waiting for additional setup tasks to complete.."
  while [ ! -f ~/nomad.d/config.hcl ]
  do
    echo -n "."
    sleep 1
  done
fi
echo ""
