
from django.contrib import admin
from smartretailapp.models import Product, Category


# Register your models here.


class CategoryAdmin(admin.ModelAdmin):

    pass


class ProductAdmin(admin.ModelAdmin):

    pass

admin.site.register(Category,CategoryAdmin)
admin.site.register(Product,ProductAdmin)