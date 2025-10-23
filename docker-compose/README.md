All services are routed through an Nginx reverse proxy, which acts as a central entry point for internal and external traffic.  
In the Nginx Docker configuration, a dedicated Docker bridge network is created, and all service containers are attached to this network. This setup ensures seamless internal communication between containers while maintaining proper isolation from the host system.

⚠️ Disclaimer:
The configurations in this repository provide the base setup for the server and containerized services. They do not include detailed service-specific configurations nor cover additional tools or devices that may be used, for example, in a smart home setup.

A simple script to check running containers:
```bash
docker ps -q | xargs -I {} sh -c '
  container_name=$(docker inspect --format "{{.Name}}" {});
  pid=$(docker inspect --format "{{.State.Pid}}" {});
  cap_add=$(docker inspect --format "{{if .HostConfig.CapAdd}}{{range .HostConfig.CapAdd}}{{. }}{{end}}{{else}}None  {{end}}" {});
  cap_drop=$(docker inspect --format "{{if .HostConfig.CapDrop}}{{range .HostConfig.CapDrop}}{{. }}{{end}}{{else}}None{{end}}" {});
  seccomp=$(docker inspect --format "{{.HostConfig.SecurityOpt}}" {} | grep -o "seccomp[^ ]*");
  apparmor=$(docker inspect --format "{{.AppArmorProfile}}" {});
  selinux=$(docker inspect --format "{{.HostConfig.SecurityOpt}}" {} | grep -o "label:[^ ]*");
  echo "Container ID: {}";
  echo "Container Name: ${container_name#/}";
  echo "Process ID: $pid";
  docker inspect --format "{{.State.Pid}}" {} | xargs -I P sh -c "
  echo ""
  echo "Namespaces:";
  ls -l /proc/P/ns;
  echo ""
  echo "Cgroups:";
  cat /proc/P/cgroup"
  echo ""
  echo "Capabilities:";
  echo "CapAdd: $cap_add";
  echo "CapDrop: $cap_drop";
  echo ""
  echo "Seccomp:";
  echo "Profile: ${seccomp:-Default}";
  echo ""
  echo "AppArmor:";
  echo "Profile: ${apparmor:-Disabled}";
  echo ""
  echo "SELinux:";
  echo "Profile: ${selinux:-Disabled}";
  echo "---------";
'
```

---

🔒 Sensitive data such as keys, IP addresses, and other private values have been intentionally replaced with the placeholder string `<HIDDEN_DATA>`.
