from django.conf.urls import patterns, url, include
from rest_framework.urlpatterns import format_suffix_patterns
import views


urlpatterns = patterns('',

    url(r'^home/$',views.home,name='home'),

    url(r'^api/product/$', views.ProductList.as_view()),
    #url(r'^api/product/(?P<pk>[0-9]+)/$', views.ProductDetail.as_view()),
    url(r'^api/product/(?P<category>.+)/$', views.ProductFilter.as_view()),

    url(r'^api/category/$', views.CategoryList.as_view()),
    url(r'^api/category/(?P<pk>[0-9]+)/$', views.CategoryDetail.as_view())


)


urlpatterns=format_suffix_patterns(urlpatterns)
