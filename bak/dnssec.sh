# https://lyalyuev.info/2019/03/12/dnssec-bind9-9/
dnssec-keygen -a NSEC3RSASHA1 -b 2048 -n ZONE
dnssec-keygen -a NSEC3RSASHA1 -b 2048 -n ZONE lan
