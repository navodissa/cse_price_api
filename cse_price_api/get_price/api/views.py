# -*- coding: utf-8 -*-
# @Author: Your name
# @Date:   2021-09-13 15:53:09
# @Last Modified by:   Your name
# @Last Modified time: 2021-09-15 16:44:19

from rest_framework.response import Response
from rest_framework.views import APIView
import logging

logger = logging.getLogger('cse_price_api.get_price.api.views')

class ExamplePriceDetailsAV(APIView):

    def get(self, request):
        data = ['You are welcome']
        logger.debug(data)
        return Response(data)