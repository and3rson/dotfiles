all:
	pio -f -c vim run

upload-ota:
	pio -f -c vim run --target upload -e ota

upload-usb:
	pio -f -c vim run --target upload -e usb

clean:
	pio -f -c vim run --target clean

program:
	pio -f -c vim run --target program

uploadfs:
	pio -f -c vim run --target uploadfs

update:
	pio -f -c vim update

icons:
	python3 icons.py > ./src/icons.cpp

compile_commands:
	pio run -e ota -t compiledb
