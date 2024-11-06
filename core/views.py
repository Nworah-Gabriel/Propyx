from django.shortcuts import render

# Create your views here.
def homePage(request):
    """
    A functional based view for the home page
    """

    return render(request, "index.html")

# Create your views here.
def contact(request):
    """
    A functional based view for the contact page
    """

    return render(request, "contact.html")

# Create your views here.
def about(request):
    """
    A functional based view for the about page
    """

    return render(request, "about.html")

# Create your views here.
def properties(request):
    """
    A functional based view for the properties page
    """

    return render(request, "properties.html")