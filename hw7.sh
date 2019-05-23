#!/bin/bash
PASS="password"

echo -e "\nChecking IP's\n"
for i in {20..23}; do
	UP=$(ping -c 1 -W 2 192.168.1.${i})
	if [ $? -ne 0 ]; then
		echo -e "Can't Connect To: 192.168.1.${i}"
		exit 1
	fi
done

echo -e "\nCreating SSH Key\n"
ssh-keygen -f ~/.ssh/id_rsa -t rsa -b 2048 -N ''

echo -e "\nCopying SSH keys\n"
for i in {20..23}; do
	ssh-keyscan 192.168.1.${i} >> ~/.ssh/known_hosts 
	echo "${PASS}" | sshpass ssh-copy-id root@192.168.1.${i} > /dev/null 2>&1
done

echo -e "\nStatying Ansible Playbook\n"
ansible-playbook webserver.yaml -i ./hosts.ini

for i in {20..23}; do
	echo -e "\nGetting Http Response From 192.168.1.${i}\n"
	curl -s  http://192.168.1.${i}
done

exit 0
