# Адаптация Entware-ng для ZyXEL Keenetic

Собранные здесь пакеты позволяют:
* [использовать](http://forums.zyxmon.org/viewtopic.php?f=5&t=5288) Entware-ng на кинетиках с прошивками NDMSv1 от 29.12.2003 и новее.
* [использовать](http://forums.zyxmon.org/viewtopic.php?f=5&t=5246) Entware-ng на кинетиках с последними NDMSv2, имеющими [компонент OPKG](http://keenopt.ru/).

Изменения в пакетах основном сводятся к тому, чтобы "отучить" софт от использования файлов в каталогах `/etc`, `/bin` и прочих за пределами папки `/opt` и обеспечить автозапуск сервисов при старте роутера.


## Сборка пакетов

Для сборки модифицированных пакетов [разверните](https://github.com/Entware-ng/Entware-ng/wiki/Compile-packages-from-sources) билдрут Entware-ng:
```
git clone https://github.com/Entware-ng/Entware-ng.git
cd Entware-ng
```
Допишите в файл `feeds.conf` строчку
```
src-git keenopt4entware https://github.com/ndmsystems/entware.git
```
Обновите подключенный фид и установите из него все пакеты:
```
./scripts/feeds update keenopt4entware
./scripts/feeds install -a -p keenopt4entware
```
Скопируйте патч для uClibc и .config для билдрута:
```
cp feeds/keenopt4entware/toolchain/uClibc/patches/9999-keenetic.patch toolchain/uClibc/patches/
cp feeds/keenopt4entware/.config .config
```
Задайте максимальный PKG_RELEASE для библиотек libc, чтобы изменённые библиотеки имели приоритет перед стандартными из Entware-ng:
```
sed -i -e 's|^\(PKG_RELEASE:\)=.*|\1=50|g' package/libs/toolchain/Makefile
```
Соберите тулчейн и пакеты:
```
make
```
Собранные пакеты будут находиться в папке `bin`. Именно в таком виде они перенесены в [отдельный репозиторий](http://ndm.zyxmon.org/binaries/keenetic/) для кинетиков.
