#!/bin/bash
echo "##### INICIANDO EL CAMBIO DE CONTRASEÑA PARA EL USUARIO " $1
sudo service mysql stop
echo "Detenido el servicio mysql"
sleep 5s
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld
echo "Creada carpeta temporal"
sleep 5s
sudo /usr/sbin/mysqld --skip-grant-tables --skip-networking &
echo "Se inicia el servicio Mysql con las tablas sin proteger ni acceso a la red"
sleep 5s
mysql -u root -e 'FLUSH PRIVILEGES;'
echo "Actualizados los privilegios"
mysql -u root -e 'USE mysql;'
echo "Seleccionada la base de datos mysql"
mysql -u root -e 'UPDATE user SET authentication_string=PASSWORD("'$2'") WHERE User='$1';'
echo "Asignada la clave indicada al usuario seleccionado"
mysql -u root -e 'UPDATE user SET plugin="mysql_native_password" WHERE User='$1';'
echo "Asignada la configuracion necesaria a la contraseña"
sudo pkill mysqld
echo "Eliminado el daemon de mysql"
sleep 5s
sudo service mysql start
echo "Iniciado el servicio mysql de nuevo"
sleep 5s