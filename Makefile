
.PHONY: all clean cleanall cleanrelease install

all: build/pam_wsl_hello.so\
     build/WindowsHelloAuthenticator/WindowsHelloAuthenticator.exe\
     build/WindowsHelloKeyCredentialCreator/WindowsHelloKeyCredentialCreator.exe

build/pam_wsl_hello.so: | build
	cargo build --release
	cp ./target/release/libpam_wsl_hello.so build/pam_wsl_hello.so

build/WindowsHelloAuthenticator/WindowsHelloAuthenticator.exe build/WindowsHelloKeyCredentialCreator/WindowsHelloKeyCredentialCreator.exe: | build
	$(MAKE) -C win_components all
	cp -R win_components/build build/

build:
	mkdir build

clean:
	cargo clean

cleanall: clean
	$(MAKE) -C win_components clean

cleanrelease: cleanall
	rm -rf build
	rm -rf release
	rm release.tar.gz

install: all
	./install.sh

release: all
	mkdir release
	cp -R build release/
	cp install.sh release/
	tar cvzf release.tar.gz release
