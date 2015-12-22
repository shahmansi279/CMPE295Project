from django.contrib.auth.models import User
from django.db import models

# Create your models here.


class Category(models.Model):

    category_id=models.CharField(max_length=32,unique=True)
    category_desc=models.CharField(max_length=200)
    category_title=models.CharField(max_length=200)


def __unicode__(self):
    return u'%s' % (self.category_id)






class Product(models.Model):


    product_id=models.CharField(max_length=32,unique=True)
    product_desc=models.CharField(max_length=200)
    product_category=models.ForeignKey(Category)
    product_title=models.CharField(max_length=200)


    def __unicode__(self):
        return u'%s by %s %s' % (self.product_id,self.product_category,self.product_title)
