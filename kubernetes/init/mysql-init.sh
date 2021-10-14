echo "** Creating databases and users"

sql=$(cat << EOF
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
EOF
)

mysql -u root -p$MYSQL_ROOT_PASSWORD -e "$sql"

echo "** Finished creating databases and users"
