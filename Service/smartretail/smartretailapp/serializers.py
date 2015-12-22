from rest_framework import serializers
from models import Product, Category

class CategorySerializer(serializers.ModelSerializer):

    class Meta:
        model=Category
        field=('id','category_id','category_desc','category_title')


class ProductSerializer(serializers.ModelSerializer):

    category=CategorySerializer

    class Meta:
        model=Product

        field=('id','product_id','product_desc','category','product_title')

