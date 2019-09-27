FROM python:3.7.4 
RUN pip install "django<2.3" model_mommy psycopg2-binary pyRAPL
WORKDIR /django 
ADD djangoapp . 

ENTRYPOINT [ "python","manage.py" ]
# ENTRYPOINT [ "bash" ]
CMD ["runserver","--settings=energy.settings.sqlite","0.0.0.0:8000"]