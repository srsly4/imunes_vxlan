# IMUNES - Integrated Multiprotocol Network Emulator/Simulator

IMUNES to realistyczny framework do symulacji/emulacji topologii sieciowych. Oparty jest na jądrze FreeBSD i Linuxa partycjonowanym na wiele lekkich wirtualnych węzłów, które mogą zostać połączone na poziomie jądra w celu utworzenia złożonej topologii sieciowej 
Więcej szczegółów można uzyskać na stronie [IMUNES](http://imunes.net/)

W obrębie systemu Linux, IMUNES wykorzystuje technologię Docker i Open vSwitch

# Instalacja na systemie Linux

## Wymagane pakiety:
1. tcl
2. tk
3. tcllib
4. wireshark (with GUI)
5. ImageMagick
6. Docker
7. OpenvSwitch
8. nsenter (część paketu util-linux od wersji 2.23+)
9. xterm
10. make



## Arch Linux

### Sposób 1.

```bash
$ sudo pacman -S tk wireshark-qt imagemagick docker \
    make openvswitch xterm
```

Aby zainstalować pakiet `tcllib` należy skorzystać z AUR (Arch User Repository), w tym celu należy najpierw upewnić się, że pakiet `base-devel` jest zainstalowany i w razie konieczności, zainstalować go:

```bash
$ sudo pacman -S base-devel
```


```bash
$ git clone https://aur.archlinux.org/tcllib.git
$ cd tcllib && makepkg -sri
```

Następnie należy upewnić się, że usługi `docker` oraz `openvswitch` działają:

```bash
$ sudo systemctl restart docker
$ sudo systemctl restart openvswitch
```

Mając już zainstalowane wymagane pakiety, można przystąpić do instalacji IMUNES:

```bash
$ git clone https://github.com/imunes/imunes.git
$ cd imunes
$ sudo make install
```

Aby możliwe było emulowanie topologii sieciowe wymagane jest pobranie template'u systemu plików, wykonuje się to poleceniem:

```bash
$ sudo imunes -p
```

Następnie można przystąpić do eksperymentów, poniższe polecenie otwiera GUI i umożliwia uruchomienie eksperymentu:

```bash
$ sudo imunes
```

### Sposób 2.

Aby zainstalować IMUNES można skorzystać z AUR. W tym celu warto zainstalować AUR helper, zaprezentowane zostanie to na przykładzie `yay`:


Aby zainstalować pakiet `yay` należy najpierw upewnić się, że pakiet `base-devel` jest zainstalowany i w razie konieczności, zainstalować go:

```bash
$ sudo pacman -S base-devel
```

Następnie można przystąpić do instalacji `yay`

```bash
$ git clone https://aur.archlinux.org/yay.git
$ cd yay
$ makepkg -sri
```

Mając zainstalowany pakiet `yay` można przystąpić do instalacji IMUNES:


```bash
$ yay -S imunes-git
```

Aby możliwe było emulowanie topologii sieciowe wymagane jest pobranie template'u systemu plików, wykonuje się to poleceniem:

```bash
$ sudo imunes -p
```

Następnie można przystąpić do eksperymentów, poniższe polecenie otwiera GUI i umożliwia uruchomienie eksperymentu:

```bash
$ sudo imunes
```

## Fedora

Zanim można przystąpić do instalacji potrzebnych pakietów, należy dodać repozytorium, z którego można pobrać wymagany pakiet `docker`:

```bash
$ sudo dnf -y install dnf-plugins-core
$ sudo dnf config-manager \
      --add-repo \
      https://download.docker.com/linux/fedora/docker-ce.repo
```


Instalacja potrzebnych pakietów:

```bash
$ sudo dnf install openvswitch docker-ce docker-ce-cli containerd.io wireshark-qt \
    xterm ImageMagick tcl tcllib tk kernel-modules-extra util-linux
```

Następnie należy upewnić się, że w `/usr/local/bin`
