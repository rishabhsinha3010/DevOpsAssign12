from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Login

def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        try:
            user = Login.objects.get(username=username, password=password)
            request.session['username'] = user.username
            return redirect('home')
        except Login.DoesNotExist:
            messages.error(request, 'Invalid credentials')
    return render(request, 'login.html')

def register_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        if Login.objects.filter(username=username).exists():
            messages.error(request, 'Username exists')
        else:
            Login.objects.create(username=username, password=password)
            messages.success(request, 'Registered')
            return redirect('login')
    return render(request, 'register.html')

def home_view(request):
    if 'username' not in request.session:
        return redirect('login')
    username = request.session['username']
    return render(request, 'home.html', {'username': username})

def logout_view(request):
    request.session.flush()
    return redirect('login')