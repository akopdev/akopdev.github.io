---
title: "Avoid the N+1 problem in DRF"
tags: ["django", "database"]
---

The N+1 problem is a common issue that can occur when using the Django REST framework serializer. 
It happens when the code makes multiple database queries to retrieve related data, instead of using a single query with a JOIN statement.

One way to fix this issue is by using the `select_related` and `prefetch_related` methods on your queryset. 
These methods allow you to specify which related data should be fetched in a single database query, reducing the number of queries needed.

```python 

from django.db import models

class Author(models.Model):
    name = models.CharField(max_length=100)

class Book(models.Model):
    title = models.CharField(max_length=100)
    author = models.ForeignKey(Author, on_delete=models.CASCADE)


books = Book.objects.all()
for book in books:
    print(book.author.name) 


books = Book.objects.select_related('author').all()
for book in books:
    print(book.author.name)”

```

`select_related` is used for one-to-one and many-to-one relationships while `prefetch_related` is used for one-to-many and many-to-many relationships.



