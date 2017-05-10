# Proxy Switch
Switches proxy on/off accross your Linux environment and common dev tools.

# Install
- Download ``proxy_switch.sh``
- Configure a ``~/.proxy.conf`` file containing the following informations:
```
USER="user"
PASSWORD="password"
HOST="host"
PORT="port"
```

# Usage
Usage: ./proxy_switch.sh [option...] {on|off}

   -i, --info           		displays the proxy settings

# Troubleshooting
- Make sure ``~/.proxy.conf`` file is set with appropriate configurations.
- Make sure ``proxy_switch.sh`` is runnable via:
``chmod +x proxy_switch.sh``
