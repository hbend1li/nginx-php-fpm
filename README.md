[![pipeline status](https://gitlab.com/hbendali/nginx-php-fpm/badges/master/pipeline.svg)](https://gitlab.com/hbendali/nginx-php-fpm/commits/master)
![docker hub](https://img.shields.io/docker/pulls/hbendali/nginx-php-fpm.svg?style=flat-square)
![docker hub](https://img.shields.io/docker/stars/hbendali/nginx-php-fpm.svg?style=flat-square)

## Overview
This is a Dockerfile/image to build a container for nginx and php-fpm.

If you have improvements or suggestions please open an issue or pull request on the GitHub project page.

### Versioning
| Docker Tag | Git Release | Nginx Version | PHP Version | Alpine Version |
|-----|-------|-----|--------|--------|
| latest/1.0.0 | Master Branch |1.14.0 | 7.2.10 | 3.8 |

## Quick Start
To pull from docker hub:
```
docker pull hbendali/nginx-php-fpm
```
### Running
To simply run the container:
```
sudo docker run -d hbendali/nginx-php-fpm
```
or map port 
```
sudo docker run -d -p 80:80 hbendali/nginx-php-fpm
```

You can then browse to ```http://<DOCKER_HOST>``` to view the default install files. To find your ```DOCKER_HOST``` use the ```docker inspect``` to get the IP address (normally 172.17.0.2)

