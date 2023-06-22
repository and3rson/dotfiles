.PHONY: all
all: | private.pem public.pem

private.pem:
	openssl genrsa -out private.pem 4096

public.pem: | private.pem
	openssl rsa -in private.pem -outform PEM -pubout -out public.pem
