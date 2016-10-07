from django.conf import settings
from django.conf.urls import url
from django.conf.urls.static import static

from .views import Crash

urlpatterns = [
    url(r'^$', Crash.as_view())
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
