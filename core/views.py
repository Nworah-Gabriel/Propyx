from django.shortcuts import render

# Create your views here.
def homePage(request):
    """
    A functional based view for the home page
    """

    return render(request, "index.html")