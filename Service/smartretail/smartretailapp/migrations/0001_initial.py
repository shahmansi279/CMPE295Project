# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Category',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('category_id', models.CharField(unique=True, max_length=32)),
                ('category_desc', models.CharField(max_length=200)),
                ('category_title', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('product_id', models.CharField(unique=True, max_length=32)),
                ('product_desc', models.CharField(max_length=200)),
                ('product_title', models.CharField(max_length=200)),
                ('product_category', models.ForeignKey(to='smartretailapp.Category')),
            ],
        ),
    ]
