# Docker-WireGuard

A simple WireGuard server running on Alpine container

# Usage

- Ingredients
  - Linux

    ```console

    foo@bar:~$ source envsetup.sh

    ```

  - Windows

    ```console

    foo@bar:~$ envsetup.bat

    ```

- Just, fire it up !

  ```console

  foo@bar:~$ docker compose up -d

  ```

- Or, put it down ...

  ```console

  foo@bar:~$ docker compose down

  ```

# Features

- Client configuration is auto-generated, and placed in the `storage/` directory of `pwd`

- **mitmproxy** is included as an option to intercept and analyze client's HTTP/S traffic

# References

- [Quick Start - WireGuard](https://www.wireguard.com/quickstart/)

- [Introduction to WireGuard VPN](https://ubuntu.com/server/docs/explanation/intro-to/wireguard-vpn/)

- [How To Set Up WireGuard on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04)

- [Configure a Wireguard interface (wg)](<https://wiki.alpinelinux.org/wiki/Configure_a_Wireguard_interface_(wg)>)

- [Building, Using, and Monitoring WireGuard Containers](https://www.procustodibus.com/blog/2021/11/wireguard-containers/)

- [How to fix connected but no internet access issues in Wireguard + UFW + IPTables](https://jianjye.medium.com/how-to-fix-no-internet-issues-in-wireguard-ed8f4bdd0bd1)

- [Fix: Wireguard connects from Linux / PC, but not from Android](https://www.oakleys.org.uk/blog/2025/10/fix_wireguard_connects_linux_pc_not_android)

- [How to use variables in a command in sed?](https://stackoverflow.com/questions/19151954/how-to-use-variables-in-a-command-in-sed)
