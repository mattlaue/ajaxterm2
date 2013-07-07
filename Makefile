VERSION := $(shell awk 'match($$0, /[0-9]+\.[0-9]+\.[0-9]+/) { print substr($$0, RSTART, RLENGTH) }' setup.py)

all: pkg

pkg: clean
	sed -e 's/VERSION/$(VERSION)/' \
		debian/DEBIAN/control.template > debian/DEBIAN/control
	python setup.py install --root=$(PWD)/debian --prefix=/usr --install-layout=deb
	mkdir -p debian/usr/share/ajaxterm2
	mv debian/usr/www debian/usr/*.ini debian/usr/share/ajaxterm2/
	fakeroot dpkg-deb --build debian .
.PHONY: pkg

clean:
	rm -rf build dist *.deb *.egg-info *.pyc 
	rm -rf debian/usr debian/DEBIAN/control 
.PHONY: clean

install:
	sudo dpkg -i ajaxterm2_$(VERSION)_all.deb
.PHONY: install

uninstall:
	sudo dpkg -r ajaxterm2
.PHONY: uninstall

version:
	@echo $(VERSION)
.PHONY: version
