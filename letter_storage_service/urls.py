from django.contrib import admin
from django.urls import path, include # include 임포트
from letter_storage.views import health_check

urlpatterns = [
    path('admin/', admin.site.urls),
    path('health/', health_check),
    # 'image/' 경로로 시작하는 모든 요청을 letter_storage 앱의 urls.py로 전달
    path('api/images/', include('letter_storage.urls')), 
]