from django.shortcuts import render
from django.http import HttpResponse
from rest_framework import generics
from models import Product,Category
from serializers import ProductSerializer, CategorySerializer



class CategoryList(generics.ListCreateAPIView):

    queryset=Category.objects.all()
    serializer_class=CategorySerializer


class CategoryDetail(generics.RetrieveUpdateDestroyAPIView):

    queryset=Category.objects.all()
    serializer_class=CategorySerializer

class ProductList(generics.ListCreateAPIView):

    queryset=Product.objects.all()
    serializer_class=ProductSerializer


class ProductDetail(generics.RetrieveUpdateDestroyAPIView):

    queryset=Product.objects.all()
    serializer_class=ProductSerializer

def home(request):

    return HttpResponse("Hello World")

# Create your views here.
