project	= pideck
version	= staging
arch	= armhf
suite	= jessie
source	= 64studio.com

picax_meta=\
	<apt-deb.key>chris@64studio.com</apt-deb.key>

components=\
	$(source)/minimal.xml		\
	$(source)/rpi.xml		\
	$(source)/sshd.xml		\
	$(source)/sudo.xml		\
	$(source)/nano.xml		\
	$(source)/xorg.xml		\
	$(source)/lxde.xml		\
	$(source)/lightdm.xml		\
	$(source)/lxterminal.xml	\
	$(source)/pideck.xml

picax_components=$(shell echo $(components) | tr " " ",")

all: picax.xml repo image image-zip checksum log

clean:
	rm -rf picax.xml images/

picax.xml:
	pdk abstract --label="$(suite)" --meta="$(picax_meta)" --components="$(picax_components)" picax.xml

repo:
	mkdir -p images
	pdk repogen -o images/$(project)_master.apt picax.xml

image:
	#sudo ./build-image-rpi $(project) images/$(project)_master.apt $(suite) $(arch) images/$(project)-$(version).img
	
	sudo /home/chris/projects/rpi/support/pifactory/pifactory $(project) $(suite) images/$(project)-$(version).img images/$(project)_master.apt 

image-zip:
	zip -j images/$(project)-$(version).img.zip images/$(project)-$(version).img

checksum:
	$(eval filename = images/$(project)-$(version).img)
	sha256sum $(filename) > $(filename).sha256sum
	$(eval outdir := $(shell dirname $(filename)))
	sed -i -e 's|$(outdir)/||g' $(filename).sha256sum

log:
	pdk log > images/$(project)-$(version).changelog

# this probably doesn't belong here but i'm lazy
flash:
	sudo dd bs=4M of=/dev/sdb if=images/$(project)-$(version).img
	sudo sync

# nor does this
upload:
	scp images/$(project)-$(version).changelog chris@djz.us:/home/chris/www/pideck/distro/
	scp images/$(project)-$(version).img.sha256sum chris@djz.us:/home/chris/www/pideck/distro/
	scp images/$(project)-$(version).img.zip chris@djz.us:/home/chris/www/pideck/distro/
