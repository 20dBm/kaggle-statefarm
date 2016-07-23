# install requirements
apt-get install -yqq wget unzip

# download datasets
wget --load-cookies cookies.txt \
https://www.kaggle.com/c/state-farm-distracted-driver-detection/download/imgs.zip
wget --load-cookies cookies.txt \
https://www.kaggle.com/c/state-farm-distracted-driver-detection/download/sample_submission.csv.zip
wget --load-cookies cookies.txt \
https://www.kaggle.com/c/state-farm-distracted-driver-detection/download/driver_imgs_list.csv.zip

# unzip datasets
unzip -qq ./imgs.zip
unzip ./sample_submission.csv.zip
unzip ./driver_imgs_list.csv.zip

# remove zip files
rm ./*.zip
