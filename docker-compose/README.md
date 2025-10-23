All services are routed through an Nginx reverse proxy, which acts as a central entry point for internal and external traffic.  
In the Nginx Docker configuration, a dedicated Docker bridge network is created, and all service containers are attached to this network. This setup ensures seamless internal communication between containers while maintaining proper isolation from the host system.

⚠️ Disclaimer:
The configurations in this repository provide the base setup for the server and containerized services. They do not include detailed service-specific configurations nor cover additional tools or devices that may be used, for example, in a smart home setup.

---

🔒 Sensitive data such as keys, IP addresses, and other private values have been intentionally replaced with the placeholder string `<HIDDEN_DATA>`.
