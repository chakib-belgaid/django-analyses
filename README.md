# Django-analyses

An energy consumption analyses of several Django projects with different levels of optimization 

We measure the energy consumption of a django web application. by running a script who will visit the webpages and record the energy consumption of the rending fuctions - this includes : 
- get the data from the database 
- compute the data 
- render the data in the django webpage 


Remarque the pypy couldn't launch the postgress implementation because it is note compatible with the module psycopg2-binary 

## early resutls : 


![energy consumption data ](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django-data.png)

![energy consumption data 2](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django-data2.png)

![energy consumption](https://github.com/chakib-belgaid/django-analyses/raw/master/images/django.png)

# TODO 

- Add crud operation 
- Setup a gatling to simulate stress requests 
- Assiciate employees to events 
- Find the function respinsible of invoking the threads to handle each request 

