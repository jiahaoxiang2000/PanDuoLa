.PHONY: build_upload build flash clean

build_upload: build flash

build:
	cmake --build build --config Debug --target all -j 22

flash:
	openocd -f board/st_b-l475e-iot01a.cfg -c "program build/rtthread.elf verify reset exit"

clean:
	rm -rf build