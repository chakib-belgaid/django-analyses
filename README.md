# Django-analyses

An energy consumption analyses of several Django projects with different levels of optimization 

We measure the energy consumption of a django web application. by running a script who will visit the webpages and record the energy consumption of the rending fuctions - this includes : 
- get the data from the database 
- compute the data 
- render the data in the django webpage 


Remarque the pypy couldn't launch the postgress implementation because it is note compatible with the module psycopg2-binary 

# How to do : 

- To start the application with sqlite 

    docker-compose up -d sqlite 

- To start the application with postgres 

    docker-compose up -d postgres

# early resutls : 


## Energy consumption data 

![energy consumption data ](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django-data.png)

## With groups 
![energy consumption data 2](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django-data2.png)

## Energy consumption Measures normalized according to the lowest value 

![energy consumption data normalized ](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django-data-norm.png)

## Box plots of the energy consumptions 
![energy consumption](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django.png)

## Energy consumption based on unit tests 
![unit tests energy consumption ](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django-unitests.png)


# TODO 

- Add crud operation 
- Setup a gatling to simulate stress requests 
- Assiciate employees to events 
- Find the function respinsible of invoking the threads to handle each request 


