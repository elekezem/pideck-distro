How to build pideck distro:

```
sudo apt-get install pdk
sudo apt-get install make zip
sudo apt-get install unzip debootstrap kpartx dosfstools qemu-user-static lvm2 e2fsprogs

cd ~
git clone http://github.com/64studio/pifactory.git

pdk workspace create pideck
cd pideck
git remote add origin https://github.com/pideck/pideck-distro.git

git pull origin master
make -C 64studio.com clean
make -C 64studio.com
make clean
make
```