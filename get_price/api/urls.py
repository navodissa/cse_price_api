# -*- coding: utf-8 -*-
# @Author: Your name
# @Date:   2021-09-13 14:53:01
# @Last Modified by:   Your name
# @Last Modified time: 2021-09-13 16:16:33

from django.urls import path
from django.urls.resolvers import URLPattern
from get_price.api.views import ExamplePriceDetailsAV

urlpatterns = [
    path('example/', ExamplePriceDetailsAV.as_view(), name='example')
]