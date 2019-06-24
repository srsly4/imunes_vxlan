# Sieci IMUNES (Integrated Multiprotocol Network Emulator/Simulator) na odseparowanych hostach połączonych na poziomie wirtualnej warstwy łącza danych za pomocą technologii VXLAN

IMUNES to realistyczny framework do symulacji/emulacji topologii sieciowych. Oparty jest na jądrze FreeBSD i Linuxa partycjonowanym na wiele lekkich wirtualnych węzłów, które mogą zostać połączone na poziomie jądra w celu utworzenia złożonej topologii sieciowej. W obrębie systemu Linux, IMUNES wykorzystuje technologię Docker i Open vSwitch. Więcej szczegółów można uzyskać na stronie [IMUNES](http://imunes.net/)

Ten DIY ma za zadanie wyjaśnić, w jaki sposób skonfigurować kilka instancji IMUNES na wielu hostach tak, aby z pomocą technologii VXLAN działały jak jedna spójna sieć wirtualna. 

# Instalacja IMUNES na systemie Linux
Celem realizacji DIY wymagane jest zainstalowanie frameworka na przynajmniej dwóch hostach niepodzielonych NAT-em. Instalację pokażemy na przykładzie dwóch dystrybucji systemu Linux (Arch Linux oraz Fedora).


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

Następnie należy upewnić się, że usługi `docker` oraz `openvswitch` działają:

```bash
$ sudo systemctl restart docker
$ sudo systemctl restart openvswitch
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

Następnie należy upewnić się, że w zmiennej środowiskowej PATH znajduje się ścieżka `/usr/local/bin`, jeżeli tak nie jest należy wykonać poniższe polecenie (w zależności od wykorzystywanego interpretera):

```bash
$ echo 'PATH=$PATH:/usr/local/bin' >> ~/.bashrc
```

Co więcej, dokumentacja IMUNES wskazuje, aby zmienna środowiskowa PATH użytkownika `root` również zawierała tę ścieżkę, dlatego w razie konieczności należy wykonać (w zależności od wykorzystywanego interpretera):

```bash
$ sudo su -
# echo 'PATH=$PATH:/usr/local/bin' >> ~/.bashrc
# exit
```

Kolejnym krokiem jest upewnienie się, że `/usr/local/bin` znajduje się w `secure_path`, w tym celu należy w razie konieczności edytować jeden plik przy pomocy polecenia:

```bash
$ sudo visudo
```

Należy znaleźć linię podobną do:

```
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
```

a następnie, jeżeli zajdzie taka potrzeba, dodać tam ścieżkę.


Następnie należy upewnić się, że usługi `docker` oraz `openvswitch` działają:

```bash
$ sudo systemctl restart docker
$ sudo systemctl restart openvswitch
```

Aby możliwe było emulowanie topologii sieciowe wymagane jest pobranie template'u systemu plików, wykonuje się to poleceniem:

```bash
$ sudo imunes -p
```

Następnie można przystąpić do eksperymentów, poniższe polecenie otwiera GUI i umożliwia uruchomienie eksperymentu:

```bash
$ sudo imunes
```

Podczas wykonywania ostatniego polecenia może wystąpić błąd typu:

```bash
Error loading package Tk: couldn't connect to display ":0"
```

Aby go rozwiązać należy wykonać polecenie:

```bash
$ xhost +si:localuser:root
```

## Maszyna wirtualna

Alternatywnie, można użyć sieci maszyn wirutalnych – obraz przygotowanej maszyny ze wszystkimi skryptami dostępny jest do pobrania tutaj: [IMUNES VXLAN Virtual Machine](https://drive.google.com/open?id=1R70IWO3-jHEkoUk4p1LOA9otzN7H4BY7)

## Inne dystrybucje

Instalacja dla innych dystrybucji opisana jest na stronie repozytorium [IMUNES](https://github.com/imunes/imunes)

# Konfiguracja VXLAN
Do półautomatycznej konfiguracji połączenia warstwy drugiej pomiędzy sieciami IMUNES przygotowaliśmy skrypt `imunes_vxlan.sh`. Z uwagi na konieczność konfiguracji sieci wymagane jest jego uruchomienie jako root.

Wykonanie skryptu jest w pełni interaktywne. Najpierw wymagane jest podanie uniknalnego numeru identyfikującego hosta z daną siecią IMUNES (np. kolejne cyfry 1, 2...). Następnie skrypt pozwala użytkownikowi wybrać fizyczny interfejs sieciowy, na którym zostanie skonfigurowane połączenie VXLAN.

Pomyślne wykonanie skryptu powinno skutować wygenerowaniem pliku `.imn` zawierającego szkielet sieci IMUNES dla danego fizycznego hosta z routerem brzegowym posiadającym unikalny adres IP w wirtualnej sieci. Uruchomienie sieci na przynajmniej dwóch hostach powinno umożliwić przeprowadzenie testu echo pomiędzy routerami brzegowymi.

# Zadania
1. Uruchomić IMUNES na trzech hostach w tej samej sieci.
2. Skonfigurować połączenie VXLAN pomiędzy nimi.
3. Korzystając z wygenerowanych szablonów, stwórz w każdej instancji IMUNES sieć złożoną z 4 hostów i 3 routerów (oprócz routera brzegowego połączonego VXLAN) i skonfiguruj routing przy użyciu protokołu OSPF *wyłącznie* wewnątrz niej (adresacja dowolna).
4. Skonfiguruj routing z użyciem protokołu BGP pomiędzy strefami będącymi poszczególnymi sieciami IMUNES.
5. Wykonaj polecenie ping pomiędzy dwoma hostami z różnych stref. 
