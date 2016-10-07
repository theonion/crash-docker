from django.views.generic.base import TemplateView


class Crash(TemplateView):
    template_name = 'crash.html'
