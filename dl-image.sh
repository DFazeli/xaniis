#!/bin/bash
base_image=$1
registry_image_name=$(echo $1 | awk -F\/ '{print $1}')
repo_image_name=$(echo $1 | awk -F\/ '{print $2}'| awk -F: '{print $1}')
image_name=$(echo $1| awk -F: '{print $1}' |awk -F\/ '{print $(NF)}')
image_tag=$(echo $1 | awk -F: '{print $2}')
echo "------- Image info ---------------------------"
echo "registry_image_name => $registry_image_name"
echo "repo_image_name     => $repo_image_name"
echo "image_name          => $image_name"
echo "image_tag           => $image_tag"
echo "----------------------------------------------"
echo -ne '\n'
echo "Start image pull $1 from Xaniis vpn server"
echo -ne '\n'
ssh -t davood@212.24.99.72  "cd /var/www/image/ && sudo -S docker pull $base_image && sudo -S docker save -o  /var/www/image/$image_name-$image_tag.tar $base_image  && sudo -S chmod 755 /var/www/image/*.tar"
echo -ne '\n'
echo "---- downlaod $repo_image_name-$image_tag.tar file from Xaniis vpn server ---"
wget 212.24.99.72:8081/$image_name-$image_tag.tar
docker load -i $image_name-$image_tag.tar
docker tag $1 repo.xaniis.local/$2/$image_name:$image_tag
echo -ne '\n'
echo "---- push repo.xaniis.local/$2/$image_name:$image_tag to xaniis locla repository ---"
docker push repo.xaniis.local/$2/$image_name:$image_tag
echo -ne '\n\n'
echo "[***** you can pull your image from this address:*****]"
echo -ne '\n'
echo "
==> repo.xaniis.local/$2/$image_name:$image_tag
"

#***  How to use ***

./dl-image.sh bitnami/redis:6.2 bitnami
./dl-image.sh  k8s.gcr.io/e2e-test-images/jessie-dnsutils:1.3 infra




