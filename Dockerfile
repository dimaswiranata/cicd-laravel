# os yang digunakan
os:
  - linux
# bahasa
language: php
# distro 
dist: trusty

php:
  - '7.1'
# service yang digunakan
services:
  - docker
# grouping  task
jobs:
  include:
  # melakukan testing 
    - stage: "Tests"                
      name: "Unit Test PHP"  
      script: 
      - travis_retry composer self-update
      - travis_retry composer install --prefer-source --no-interaction
      - cp .env.example .env
      - php artisan key:generate
      - vendor/bin/phpunit tests/Feature/ExampleTest.php
    # melakukan build images dan publish ke docker hub
    - stage: "Build Docker Image"
      name: "Build Images Docker" 
      script:
      - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
      - docker build -t travis-ci-build-stages-demo .
      - docker images
      - docker tag travis-ci-build-stages-demo $DOCKER_USERNAME/cicd-laravel
      - docker push $DOCKER_USERNAME/cicd-laravel