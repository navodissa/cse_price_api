# -*- coding: utf-8 -*-
# @Author: Your name
# @Date:   2021-09-13 14:51:07
# @Last Modified by:   Your name
# @Last Modified time: 2021-09-15 21:03:40
from django.http import response
from rest_framework.test import APITestCase
from django.urls import reverse
from rest_framework import status
import json

class URLTests(APITestCase):
    def test_list_msg(self):
        url = reverse('example')
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(json.loads(response.content), {'data':'You are welcome !!!'})

